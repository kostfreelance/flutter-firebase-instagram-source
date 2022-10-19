import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/domain/models/user_model.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/auth_module.dart';
import 'package:flutter_firebase_instagram/src/internal/modules/profile_edit_module.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_button.dart';
import 'package:flutter_firebase_instagram/src/presentation/widgets/app_nav_bar.dart';

class ProfileEditScreen extends StatelessWidget {
  final User user;

  const ProfileEditScreen({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    ProfileEditController profileEditController = Get.put(ProfileEditModule.controller(user));
    return Scaffold(
      appBar: AppNavBar(
        leftButton: AppButton(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          onPressed: Get.back,
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.black
            )
          )
        ),
        title: const AppNavBarTitle('Edit Profile'),
        rightButton: Obx(() =>
          AppButton(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            onPressed: profileEditController.isValid.value ?
              () => authController.updateProfile(
                profileEditController.usernameController.text,
                profileEditController.passwordController.text,
                user.imagePath,
                profileEditController.imageFile.value
              ) :
              null,
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.blue
              )
            )
          )
        )
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppButton(
            padding: EdgeInsets.symmetric(vertical: 25.h),
            onPressed: profileEditController.onImagePressed,
            child: Column(
              children: [
                Obx(() =>
                  (profileEditController.imageFile.value != null || user.imageUrl.isNotEmpty) ?
                    CircleAvatar(
                      radius: 45.r,
                      backgroundColor: AppColors.black,
                      backgroundImage: profileEditController.imageFile.value != null ?
                        FileImage(profileEditController.imageFile.value!) :
                        NetworkImage(user.imageUrl) as ImageProvider
                    ) :
                    Container(
                      width: 90.r,
                      height: 90.r,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle
                      )
                    )
                ),
                SizedBox(height: 12.h),
                Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: AppColors.blue
                  )
                )
              ]
            )
          ),
          _TextFieldBuilder(
            label: 'Email',
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
            controller: profileEditController.emailController,
            onChanged: profileEditController.validate
          ),
          _TextFieldBuilder(
            label: 'Username',
            hintText: 'Username',
            controller: profileEditController.usernameController,
            onChanged: profileEditController.validate
          ),
          _TextFieldBuilder(
            label: 'Password',
            hintText: 'Password',
            obscureText: true,
            controller: profileEditController.passwordController,
            onChanged: profileEditController.validate
          ),
          _TextFieldBuilder(
            label: 'Confirm Password',
            hintText: 'Confirm Password',
            obscureText: true,
            controller: profileEditController.confirmPasswordController,
            onChanged: profileEditController.validate
          )
        ]
      )
    );
  }
}

class _TextFieldBuilder extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function() onChanged;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? obscureText;

  const _TextFieldBuilder({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.readOnly,
    this.obscureText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder textfieldBorder = UnderlineInputBorder(      
      borderSide: BorderSide(
        color: AppColors.grey,
        width: 1
      )   
    );
    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 25.h
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey
            )
          ),
          TextField(
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.black
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColors.lightGrey
              ),
              enabledBorder: textfieldBorder,
              focusedBorder: textfieldBorder,
              isDense: true,
              contentPadding: EdgeInsets.only(
                top: 12.h,
                bottom: 8.h
              )
            ),
            keyboardType: keyboardType ?? TextInputType.text,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            controller: controller,
            onChanged: (_) => onChanged()
          )
        ]
      )
    );
  }
}