import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

abstract class StatusLoader {
  static StateSetter? _setState;
  static String _status = '0%';

  static set status(String status) {
    if (_setState != null) {
      _setState!(() {
        _status = status;
      });
    }
  }

  static void open() {
    Get.dialog(
      StatefulBuilder(
        builder: (_, setState) {
          _setState = setState;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue)),
              Container(
                padding: EdgeInsets.only(top: 15.h),
                child: Text(
                  _status,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28.sp,
                    color: AppColors.blue,
                    decoration: TextDecoration.none
                  )
                )
              )
            ]
          );
        }
      ),
      barrierDismissible: false
    );
  }

  static void close() {
    Get.back();
  }
}