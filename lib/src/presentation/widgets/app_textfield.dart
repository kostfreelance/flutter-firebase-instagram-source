import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final Function() onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const AppTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.keyboardType,
    this.obscureText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(6.r)
      ),
      borderSide: BorderSide(
        width: 0.5,
        color: AppColors.lightGrey
      ),
    );
    return TextField(
      style: TextStyle(
        fontSize: 16.sp,
        color: AppColors.black
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: AppColors.grey
        ),
        enabledBorder: inputBorder,  
        focusedBorder: inputBorder,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 14.w
        ),
        filled: true,
        fillColor: AppColors.veryLightGrey
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: (value) => onChanged()
    );
  }
}