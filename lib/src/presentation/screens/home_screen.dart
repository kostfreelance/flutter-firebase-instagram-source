import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/home_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_list_tile.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/video_without_controls.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_list_view.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_progress_indicator.dart';
import 'post_detail_screen.dart';
import 'comments_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
  with AutomaticKeepAliveClientMixin<HomeScreen> {
  late HomeController _homeController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _homeController = Get.put(HomeModule.controller());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppNavBar(
        title: Text(
          'yourApp',
          style: TextStyle(
            fontFamily: 'Cookie-Regular',
            fontSize: 35.sp,
            color: AppColors.black
          )
        )
      ),
      body: Obx(() =>
        _ListBuilder(
          showInfinityLoader: _homeController.showInfinityLoader,
          items: _homeController.posts.value,
          fetchNextItems: _homeController.fetchNextPosts,
          onRefresh: _homeController.fetchPosts,
          onLikePressed: _homeController.onLikePressed,
          onSharePressed: _homeController.onSharePressed,
          onRemovePressed: _homeController.onRemovePressed
        )
      )
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final bool showInfinityLoader;
  final List<Post>? items;
  final Function() fetchNextItems;
  final Function() onRefresh;
  final Function(int) onLikePressed;
  final Function(Post) onSharePressed;
  final Function(Post) onRemovePressed;

  const _ListBuilder({
    Key? key,
    required this.showInfinityLoader,
    required this.items,
    required this.fetchNextItems,
    required this.onRefresh,
    required this.onLikePressed,
    required this.onSharePressed,
    required this.onRemovePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (items != null) ?
      RefreshIndicator(
        onRefresh: () async {
          onRefresh();
          return Future.value();
        },
        child: items!.isNotEmpty ? 
          InfinityListView<Post>(
            items: items!,
            itemWidget: (items, index) {
              Post item = items[index];
              return _ItemBuilder(
                item: item,
                onLikePressed: () => onLikePressed(index),
                onSharePressed: () => onSharePressed(item),
                onRemovePressed: () => onRemovePressed(item)
              );
            },
            showLoader: showInfinityLoader,
            fetchNextItems: fetchNextItems
          ) :
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: const NoDataLabel('No Posts Yet')
                )
              ]
            )
          )
      ) :
      const AppProgressIndicator();
  }
}

class _ItemBuilder extends StatelessWidget {
  final Post item;
  final Function() onLikePressed;
  final Function() onSharePressed;
  final Function() onRemovePressed;

  const _ItemBuilder({
    Key? key,
    required this.item,
    required this.onLikePressed,
    required this.onSharePressed,
    required this.onRemovePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double previewWidth = MediaQuery.of(context).size.width;
    double previewHeight = MediaQuery.of(context).size.width / 1.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppListTile(
          leading: Container(
            margin: EdgeInsets.only(
              left: 15.w,
              right: 12.w
            ),
            child: item.user.imageUrl.isNotEmpty ?
              CircleAvatar(
                radius: 15.r,
                backgroundColor: AppColors.black,
                backgroundImage: NetworkImage(item.user.imageUrl)
              ) :
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle
                ),
              )
          ),
          title: Text(
            item.user.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black
            )
          ),
          trailing: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              item.date,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey
              )
            )
          ),
          height: 48.h,
          onPressed: () =>
            Get.to(ProfileScreen(user: item.user))
        ),
        GestureDetector(
          child: item.fileType == 'video' ?
            VideoWithoutControlsWidget(
              child: item.fileUrl,
              width: previewWidth,
              height: previewHeight
            ) :
            Stack(
              children: [
                Container(
                  color: AppColors.black,
                  width: previewWidth,
                  height: previewHeight,
                ),
                Image.network(
                  item.fileUrl,
                  width: previewWidth,
                  height: previewHeight,
                  fit: BoxFit.cover
                )
              ]
            ),
            onTap: () =>
              Get.to(PostDetailScreen(post: item))
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.only(
                    left: 13.w,
                    right: 6.5.w
                  ),
                  onPressed: onLikePressed,
                  child: Icon(
                    item.isLiked ?
                      Icons.favorite :
                      Icons.favorite_border,
                    color: item.isLiked ?
                      AppColors.red :
                      AppColors.black,
                    size: 28.h
                  )
                ),
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.5.w),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.black,
                    size: 28.h
                  ),
                  onPressed: () =>
                    Get.to(CommentsScreen(postId: item.id))
                ),
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.only(
                    left: 6.5.w,
                    right: 13.w
                  ),
                  onPressed: onSharePressed,
                  child: Icon(
                    Icons.share,
                    color: AppColors.black,
                    size: 28.h
                  )
                )
              ]
            ),
            item.user.isCurrent ?
              AppButton(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                onPressed: onRemovePressed,
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.black,
                  size: 28.h
                )
              ) :
              Container()
          ]
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
            bottom: 10.h
          ),
          child: Text(
            (item.likesCount == 1) ?
              '1 like' :
              '${item.likesCount.toString()} likes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: 15.h
          ),
          child: RichText(
            text: TextSpan(
              text: item.user.name,
              style: TextStyle(
                fontFamily: 'Lato-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.black
              ),
              children: [
                TextSpan(
                  text: ' ${item.caption}',
                  style: const TextStyle(fontWeight: FontWeight.normal)
                )
              ]
            )
          )
        )
      ]
    );
  }
}