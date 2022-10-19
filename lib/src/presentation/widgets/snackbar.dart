import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

abstract class Snackbar {
  static void open(
    String text, {
      Color? color
    }
  ) {
    Get.rawSnackbar(
      message: text,
      backgroundColor: color ?? AppColors.blue
    );
  }
}