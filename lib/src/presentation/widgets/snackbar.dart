import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

abstract class Snackbar {
  static void open(
    String text, {
      SnackbarType? type = SnackbarType.success
    }
  ) {
    Get.rawSnackbar(
      messageText: Text(
        text,
        key: type!.key,
        style: TextStyle(color: AppColors.white)
      ),
      backgroundColor: type.color
    );
  }
}

enum SnackbarType {
  success, error;

  Key get key =>
    Key('snackbar_${toString().split('.').last}');

  Color get color {
    late Color color;
    switch (this) {
      case SnackbarType.success:
        color = AppColors.blue;
        break;
      case SnackbarType.error:
        color = AppColors.red;
        break;
    }
    return color;
  }
}