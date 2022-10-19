import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

class AppProgressIndicator extends StatelessWidget {
  final double? size;

  const AppProgressIndicator({
    Key? key,
    this.size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: (size != null) ?
          EdgeInsets.all(size! / 2.0) : EdgeInsets.zero,
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
          strokeWidth: (size != null) ?
            (size! / 8) : 4.r
        )
      )
    );
  }
}