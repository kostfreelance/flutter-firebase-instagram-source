import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ActionSheet {
  static void open(
    List<ActionSheetItem> items
  ) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 20.sp
    );
    List<CupertinoActionSheetAction> actions = items.map((item) =>
      CupertinoActionSheetAction(
        child: Text(
          item.text,
          style: textStyle
        ),
        onPressed: () {
          Get.back();
          item.onPressed();
        }
      )
    ).toList();
    Get.bottomSheet(
      CupertinoActionSheet(
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: Get.back,
          child: Text(
            'Cancel',
            style: textStyle
          )
        )
      )
    );
  }
}

class ActionSheetItem {
  final String text;
  final Function() onPressed;

  ActionSheetItem({
    required this.text,
    required this.onPressed
  });
}