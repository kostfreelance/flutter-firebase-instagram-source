import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/auth_module.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/register_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_textfield.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    RegisterController registerController = Get.put(RegisterModule.controller());
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
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
                    'Sign up to see photos and videos from your friends.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.grey
                    )
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    controller: registerController.emailController,
                    onChanged: registerController.validate
                  ),
                  SizedBox(height: 6.h),
                  AppTextField(
                    hintText: 'Username',
                    controller: registerController.usernameController,
                    onChanged: registerController.validate
                  ),
                  SizedBox(height: 6.h),
                  AppTextField(
                    obscureText: true,
                    hintText: 'Password',
                    controller: registerController.passwordController,
                    onChanged: registerController.validate
                  ),
                  SizedBox(height: 6.h),
                  AppTextField(
                    obscureText: true,
                    hintText: 'Confirm Password',
                    controller: registerController.confirmPasswordController,
                    onChanged: registerController.validate
                  ),
                  SizedBox(height: 20.h),
                  Obx(() =>
                    AppButton(
                      height: 44.h,
                      backgroundColor: AppColors.blue,
                      borderRadius: BorderRadius.circular(6.r),
                      onPressed: registerController.isValid.value ?
                        () => authController.register(
                          registerController.usernameController.text,
                          registerController.emailController.text,
                          registerController.passwordController.text
                        ) : null,
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.white
                        )
                      )
                    )
                  )
                ]
              )
            ]
          )
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey
                )
              ),
              AppButton(
                height: 44.h,
                padding: EdgeInsets.only(left: 10.w),
                alignment: Alignment.center,
                onPressed: Get.back,
                child: Text(
                  'Sign In.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.blue
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}