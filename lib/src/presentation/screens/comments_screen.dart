import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/comments_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/no_data_label.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/infinity_list_view.dart';
import 'profile_screen.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;

  const CommentsScreen({
    Key? key,
    required this.postId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommentsController controller = Get.put(CommentsModule.controller(postId));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: const AppNavBarBackButton(),
        title: const AppNavBarTitle('Comments')
      ),
      body: Column(
        children: [
          Obx(() =>
            _ListBuilder(
              showInfinityLoader: controller.showInfinityLoader,
              items: controller.comments.value,
              fetchNextItems: controller.fetchNextComments
            )
          ),
          Obx(() =>
            _BottomBarBuilder(
              isCommentValid: controller.isCommentValid.value,
              commentController: controller.commentController,
              onCommentChanged: controller.onCommentChanged,
              onPostPressed: controller.onPostPressed
            )
          )
        ]
      )
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final bool showInfinityLoader;
  final List<Comment>? items;
  final Function() fetchNextItems;

  const _ListBuilder({
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
          InfinityListView<Comment>(
            items: items!,
            itemWidget: (items, index) =>
              _ItemBuilder(items[index]),
            showLoader: showInfinityLoader,
            fetchNextItems: fetchNextItems
          ) :
          const NoDataLabel('No Comments Yet') :
        Container()
    );
  }
}

class _ItemBuilder extends StatelessWidget {
  final Comment item;

  const _ItemBuilder(
    this.item, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 15.w),
              child: item.user.imageUrl.isNotEmpty ?
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.black,
                  backgroundImage: NetworkImage(item.user.imageUrl)
                ) :
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle
                  )
                )
            ),
            onTap: () =>
              Get.to(ProfileScreen(user: item.user))
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
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
                        text: ' ${item.content}',
                        style: const TextStyle(fontWeight: FontWeight.normal)
                      )
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 3.h),
                  child: Text(
                    item.date,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.grey
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}

class _BottomBarBuilder extends StatelessWidget {
  final bool isCommentValid;
  final TextEditingController commentController;
  final Function() onCommentChanged;
  final Function() onPostPressed;

  const _BottomBarBuilder({
    Key? key,
    required this.isCommentValid,
    required this.commentController,
    required this.onCommentChanged,
    required this.onPostPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.lightGrey)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.black
                ),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 12.h
                  )
                ),
                maxLines: null,
                autofocus: true,
                controller: commentController,
                onChanged: (_) => onCommentChanged()
              )
            ),
            AppButton(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h
              ),
              borderRadius: BorderRadius.circular(20.r),
              onPressed: isCommentValid ?
                onPostPressed : null,
              child: Text(
                'Post',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.blue
                )
              )
            )
          ]
        )
      )
    );
  }
}