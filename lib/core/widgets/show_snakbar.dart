import 'package:flutter/material.dart';
import '../basic_features.dart';

void showSnackBar(BuildContext context, String text,
    {bool needToTranslate = true,
    Color textColor = ColorConst.whiteColor,
    Color? backgroundColor}) {
  hideSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: backgroundColor ?? ColorConst.blackColor.withOpacity(0.7),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    content: Text(
      text,
      style: fontStyleMedium13.copyWith(color: textColor),
    ),
  ));
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
