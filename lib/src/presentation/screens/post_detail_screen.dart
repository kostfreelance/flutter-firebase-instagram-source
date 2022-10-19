import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/comment_model.dart';
import 'package:flutter_firebase_instagram/src/domain/models/post_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/post_detail_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_list_tile.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/video_with_controls.dart';
import 'comments_screen.dart';
import 'profile_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    PostDetailController controller = Get.put(PostDetailModule.controller(post));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: const AppNavBarBackButton(),
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
        _PostBuilder(
          post: post,
          isLiked: controller.isLiked.value,
          likesCount: controller.likesCount.value,
          commentsCount: controller.commentsCount.value,
          comments: controller.comments.value,
          onLikePressed: controller.onLikePressed,
          onCommentsPressed: () =>
            Get.to(CommentsScreen(postId: post.id)),
          onSharePressed: controller.onSharePressed,
          onRemovePressed: controller.onRemovePressed
        )
      )
    );
  }
}

class _PostBuilder extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final int likesCount;
  final int commentsCount;
  final List<Comment>? comments;
  final Function() onLikePressed;
  final Function() onCommentsPressed;
  final Function() onSharePressed;
  final Function() onRemovePressed;

  const _PostBuilder({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.comments,
    required this.onLikePressed,
    required this.onCommentsPressed,
    required this.onSharePressed,
    required this.onRemovePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double previewSize = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        AppListTile(
          leading: Container(
            margin: EdgeInsets.only(
              left: 15.w,
              right: 12.w
            ),
            child: post.user.imageUrl.isNotEmpty ?
              CircleAvatar(
                radius: 15.r,
                backgroundColor: AppColors.black,
                backgroundImage: NetworkImage(post.user.imageUrl)
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
            post.user.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black,
            )
          ),
          trailing: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              post.date,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey
              )
            )
          ),
          height: 48.h,
          onPressed: () => 
            Get.to(ProfileScreen(user: post.user))
        ),
        post.fileType == 'video' ?
          VideoWithControlsWidget(
            url: post.fileUrl,
            width: previewSize,
            height: previewSize
          ) :
          Image.network(
            post.fileUrl,
            width: previewSize,
            height: previewSize,
            fit: BoxFit.cover
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
                    isLiked ?
                      Icons.favorite :
                      Icons.favorite_border,
                    color: isLiked ?
                      AppColors.red :
                      AppColors.black,
                    size: 28.h
                  )
                ),
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.5.w),
                  onPressed: onCommentsPressed,
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.black,
                    size: 28.h
                  )
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
            post.user.isCurrent ?
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
            (likesCount == 1) ?
              '1 like' :
              '${likesCount.toString()} likes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black
            )
          )
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: RichText(
            text: TextSpan(
              text: post.user.name,
              style: TextStyle(
                fontFamily: 'Lato-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.black
              ),
              children: [
                TextSpan(
                  text: ' ${post.caption}',
                  style: const TextStyle(fontWeight: FontWeight.normal)
                )
              ]
            )
          )
        ),
        AppButton(
          padding: EdgeInsets.all(15.r),
          alignment: Alignment.centerLeft,
          onPressed: onCommentsPressed,
          child: Text(
            (commentsCount > 0) ?
              'View all ${commentsCount.toString()} comments' :
              'Add a comment',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey
              )
          )
        ),
        _CommentListBuilder(comments)
      ]
    );
  }
}

class _CommentListBuilder extends StatelessWidget {
  final List<Comment>? comments;

  const _CommentListBuilder(
    this.comments, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (comments != null) ?
      comments!.isNotEmpty ?
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: 5.h
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments!.map((comment) =>
              _CommentItemBuilder(comment)
            ).toList()
          )
        ) :
        Container() :
      Container();
  }
}

class _CommentItemBuilder extends StatelessWidget {
  final Comment comment;

  const _CommentItemBuilder(
    this.comment, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: comment.user.name,
              style: TextStyle(
                fontFamily: 'Lato-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.black
              ),
              children: [
                TextSpan(
                  text: ' ${comment.content}',
                  style: const TextStyle(fontWeight: FontWeight.normal)
                )
              ]
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 3.h),
            child: Text(
              comment.date,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.grey
              )
            )
          )
        ]
      )
    );
  }
}