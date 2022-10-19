import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'app_button.dart';

class AppNavBar extends StatelessWidget with PreferredSizeWidget {
  final double preferredSizeHeight = 50.h;
  final Widget? leftButton;
  final Widget? title;
  final Widget? rightButton;

  AppNavBar({
    Key? key,
    this.leftButton,
    this.title,
    this.rightButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.veryLightGrey,
            border: Border(
              bottom: BorderSide(
                color: AppColors.lightGrey,
                width: 0.5
              )
            )
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftButton ?? Container(),
                    rightButton ?? Container()
                  ]
                ),
                title ?? Container()
              ]
            )
          )
        )
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredSizeHeight);
}

class AppNavBarBackButton extends StatelessWidget {
  final Function()? onPressed;

  const AppNavBarBackButton({
    Key? key,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      width: 50.h,
      height: 50.h,
      onPressed: onPressed ?? Get.back,
      child: Icon(
        Icons.arrow_back_ios,
        color: AppColors.black,
        size: 28.r
      )
    );
  }
}

class AppNavBarTitle extends StatelessWidget {
  final String title;

  const AppNavBarTitle(
    this.title, {
      Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: AppColors.black
      )
    );
  }
}