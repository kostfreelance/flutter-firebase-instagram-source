import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Function() onPressed;
  final Widget? subTitle;
  final Widget? trailing;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AppListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.onPressed,
    this.subTitle,
    this.trailing,
    this.height,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        height: height,
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            leading,
            Expanded(
              child: Column(
                mainAxisAlignment: (subTitle != null) ?
                  MainAxisAlignment.spaceEvenly :
                  MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  subTitle ?? Container()
                ]
              )
            ),
            trailing ?? Container()
          ]
        )
      )
    );
  }
}