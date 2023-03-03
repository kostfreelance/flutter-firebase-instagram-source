import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/auth_module.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/reset_password_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_textfield.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = '/reset-password';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    ResetPasswordController resetPasswordController = Get.put(ResetPasswordModule.controller());
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'YourApp',
              style: TextStyle(
                fontFamily: 'Cookie-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 50.sp
              )
            ),
            SizedBox(height: 36.h),
            Text(
              "Enter your email and we'll send you a link to get back into your account.",
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey
              )
            ),
            SizedBox(height: 20.h),
            AppTextField(
              key: const Key('reset_password_email_textfield'),
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              controller: resetPasswordController.emailController,
              onChanged: resetPasswordController.validate
            ),
            SizedBox(height: 20.h),
            Obx(() =>
              AppButton(
                key: const Key('reset_password_button'),
                height: 44.h,
                backgroundColor: AppColors.blue,
                borderRadius: BorderRadius.circular(6.r),
                onPressed: resetPasswordController.isValid.value ?
                  () async {
                    await authController.resetPassword(resetPasswordController.emailController.text);
                    resetPasswordController.emailController.text = '';
                    resetPasswordController.validate();
                  } :
                  null,
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.white
                  )
                )
              )
            )
          ]
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: AppColors.lightGrey
              )
            )
          ),
          child: AppButton(
            height: 44.h,
            alignment: Alignment.center,
            onPressed: Get.back,
            child: Text(
              'Back to Log In',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blue
              )
            )
          )
        )
      )
    );
  }
}