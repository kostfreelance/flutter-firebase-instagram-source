import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/auth_module.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/login_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_textfield.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    LoginController loginController = Get.put(LoginModule.controller());
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
            AppTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              controller: loginController.emailController,
              onChanged: loginController.validate
            ),
            SizedBox(height: 6.h),
            AppTextField(
              obscureText: true,
              hintText: 'Password',
              controller: loginController.passwordController,
              onChanged: loginController.validate
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                height: 36.h,
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.only(right: 10.w),
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.blue
                  )
                ),
                onPressed: () =>
                  Get.toNamed(ResetPasswordScreen.routeName)
              )
            ),
            Obx(() =>
              AppButton(
                height: 44.h,
                backgroundColor: AppColors.blue,
                borderRadius: BorderRadius.circular(6.r),
                onPressed: loginController.isValid.value ?
                  () => authController.login(
                    loginController.emailController.text,
                    loginController.passwordController.text
                  ) : null,
                child: Text(
                  'Log In',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey
                )
              ),
              AppButton(
                height: 44.h,
                padding: EdgeInsets.only(left: 10.w),
                alignment: Alignment.center,
                child: Text(
                  'Sign Up.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.blue
                  )
                ),
                onPressed: () =>
                  Get.toNamed(RegisterScreen.routeName)
              )
            ]
          )
        )
      )
    );
  }
}