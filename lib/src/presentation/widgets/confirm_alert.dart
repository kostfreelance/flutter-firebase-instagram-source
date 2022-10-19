import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

abstract class ConfirmAlert {
  static void open(
    String title, {
    required Function() onConfirm 
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        contentPadding: EdgeInsets.all(30.r),
        content: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.black
          )
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'No',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.blue
              )
            )
          ),
          TextButton(
            child: Text(
              'Yes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.blue
              )
            ),
            onPressed: () {
              Get.back();
              onConfirm();
            }
          )
        ]
      )
    );
  }
}