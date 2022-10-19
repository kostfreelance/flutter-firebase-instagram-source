import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const AppButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.backgroundColor,
    this.borderRadius,
    this.border
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: (onPressed == null) ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: borderRadius ?? BorderRadius.zero,
            border: border
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: onPressed,
            child: Container(
              padding: padding ?? EdgeInsets.zero,
              child: Align(
                alignment: alignment ?? Alignment.center,
                child: child
              )
            )
          )
        )
      )
    );
  }
}