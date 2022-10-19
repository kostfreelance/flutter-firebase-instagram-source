import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

class NoDataLabel extends StatelessWidget {
  final String label;

  const NoDataLabel(
    this.label, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: AppColors.black
        )
      )
    );
  }
}