import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/profile_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/video_without_controls.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_grid_view.dart';
import 'chat_detail_screen.dart';
import 'followers_screen.dart';
import 'following_screen.dart';
import 'profile_edit_screen.dart';
import 'post_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({
    Key? key,
    this.user
  }) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
  with AutomaticKeepAliveClientMixin<ProfileScreen> {
  late ProfileController _profileController;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(
      ProfileModule.controller(widget.user),
      tag: (widget.user != null) ?
        '${widget.user!.id}${UniqueKey().toString()}' :
        'profile'
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      _ScaffoldBuilder(
        leftButton: (widget.user != null) ?
          AppNavBarBackButton(onPressed: _profileController.onBackPressed) :
          null,
        title: AppNavBarTitle(
          (_profileController.user.value != null) ?
            _profileController.user.value!.name : ''
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (_profileController.user.value != null) ?
              _UserBuilder(
                user: _profileController.user.value!,
                isFollowing: _profileController.isFollowing.value,
                onFollowPressed: _profileController.onFollowPressed,
                onLogoutPressed: _profileController.onLogoutPressed
              ) :
              Container(),
            _PostListBuilder(
              showInfinityLoader: _profileController.showInfinityLoader,
              items: _profileController.posts.value,
              fetchNextItems: _profileController.fetchNextPosts
            )
          ]
        ),
        onBackPressed: _profileController.onBackPressed
      )
    );
  }
}

class _ScaffoldBuilder extends StatelessWidget {
  final Widget? leftButton;
  final Widget title;
  final Widget body;
  final Function() onBackPressed;

  const _ScaffoldBuilder({
    Key? key,
    required this.leftButton,
    required this.title,
    required this.body,
    required this.onBackPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Scaffold scaffoldWidget = Scaffold(
      appBar: AppNavBar(
        leftButton: leftButton,
        title: title
      ),
      body: body
    );
    if (leftButton != null) {
      return WillPopScope(
        onWillPop: () {
          onBackPressed();
          return Future.value(false);
        },
        child: scaffoldWidget
      );
    } else {
      return scaffoldWidget;
    }
  }
}

class _UserBuilder extends StatelessWidget {
  final User user;
  final bool isFollowing;
  final Function() onFollowPressed;
  final Function() onLogoutPressed;

  const _UserBuilder({
    Key? key,
    required this.user,
    required this.isFollowing,
    required this.onFollowPressed,
    required this.onLogoutPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
            top: 15.h,
            right: 15.w
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              user.imageUrl.isNotEmpty ?
                CircleAvatar(
                  radius: 45.r,
                  backgroundColor: AppColors.black,
                  backgroundImage: NetworkImage(user.imageUrl)
                ) :
                Container(
                  width: 90.r,
                  height: 90.r,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle
                  ),
                ),
              _UserCountBuilder(
                value: user.postsCount,
                label: 'Posts'
              ),
              AppButton(
                child: _UserCountBuilder(
                  value: user.followersCount,
                  label: 'Followers'
                ),
                onPressed: () =>
                  Get.to(FollowersScreen(userId: user.id))
              ),
              AppButton(
                child: _UserCountBuilder(
                  value: user.followingCount,
                  label: 'Following'
                ),
                onPressed: () =>
                  Get.to(FollowingScreen(userId: user.id))
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.all(15.r),
          child: Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              user.isCurrent ?
                _UserButtonBuilder(
                  text: 'Edit Profile',
                  onPressed: () =>
                    Get.to(ProfileEditScreen(user: user))
                ) :
                _UserButtonBuilder(
                  text: isFollowing ?
                    'Unfollow' : 'Follow',
                  textColor: isFollowing ?
                    AppColors.black : AppColors.white,
                  backgroundColor: isFollowing ?
                    AppColors.white : AppColors.blue,
                  onPressed: onFollowPressed
                ),
              user.isCurrent ?
                _UserButtonBuilder(
                  text: 'Logout',
                  onPressed: onLogoutPressed
                ) :
                _UserButtonBuilder(
                  text: 'Message',
                  onPressed: () =>
                    Get.to(ChatDetailScreen(user: user))
                )
            ]
          )
        )
      ]
    );
  }
}

class _UserCountBuilder extends StatelessWidget {
  final int value;
  final String label;

  const _UserCountBuilder({
    Key? key,
    required this.value,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.black
          )
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black
          )
        )
      ]
    );
  }
}

class _UserButtonBuilder extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const _UserButtonBuilder({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      height: 34.h,
      width: MediaQuery.of(context).size.width / 2 - 20.w,
      backgroundColor: backgroundColor ?? AppColors.white,
      border: Border.all(color: AppColors.lightGrey),
      borderRadius: BorderRadius.circular(6.r),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: textColor ?? AppColors.black
        )
      )
    );
  }
}

class _PostListBuilder extends StatelessWidget {
  final bool showInfinityLoader;
  final List<Post>? items;
  final Function() fetchNextItems;

  const _PostListBuilder({
    Key? key,
    required this.showInfinityLoader,
    required this.items,
    required this.fetchNextItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (items != null) ?
        items!.isNotEmpty ?
          InfinityGridView<Post>(
            items: items!,
            itemWidget: (items, index) =>
              _PostItemBuilder(items[index]),
            showLoader: showInfinityLoader,
            fetchNextItems: fetchNextItems
          ) :
          const NoDataLabel('No Posts Yet') :
        Container()
    );
  }
}

class _PostItemBuilder extends StatelessWidget {
  final Post post;

  const _PostItemBuilder(
    this.post, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemSize = MediaQuery.of(context).size.width / 3;
    return GestureDetector(
      child: post.fileType == 'video' ?
        VideoWithoutControlsWidget(
          child: post.fileUrl,
          width: itemSize,
          height: itemSize
        ) :
        Image.network(
          post.fileUrl,
          width: itemSize,
          height: itemSize,
          fit: BoxFit.cover
        ),
        onTap: () =>
          Get.to(PostDetailScreen(post: post))
    );
  }
}