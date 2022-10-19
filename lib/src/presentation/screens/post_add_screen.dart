import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/app_file_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/post_add_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/video_without_controls.dart';

class PostAddScreen extends StatelessWidget {
  final AppFile file;
  
  const PostAddScreen({
    Key? key,
    required this.file
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostAddController controller = Get.put(PostAddModule.controller(file));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: const AppNavBarBackButton(),
        title: const AppNavBarTitle('New Post'),
        rightButton: Obx(() =>
          AppButton(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            onPressed: controller.isValid.value ?
              controller.onSharePressed : null,
            child: Text(
              'Share',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.blue
              )
            )
          )
        )
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(15.r),
            child: (file.type == 'video') ?
              VideoWithoutControlsWidget(
                child: file.content,
                width: 70.r,
                height: 70.r
              ) :
              Image.file(
                file.content,
                width: 70.r,
                height: 70.r,
                fit: BoxFit.cover
              )
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.black
              ),
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(
                  top: 15.h,
                  right: 15.w,
                  bottom: 15.h
                )
              ),
              maxLines: null,
              autofocus: true,
              controller: controller.captionController,
              onChanged: (caption) =>
                controller.onCaptionChanged()
            )
          )
        ]
      )
    );
  }
}