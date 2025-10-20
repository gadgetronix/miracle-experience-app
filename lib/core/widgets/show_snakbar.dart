import 'package:flutter/material.dart';
import '../basic_features.dart';

void showErrorSnackBar(
  BuildContext context,
  String text, {
  bool needToTranslate = true,
}) {
  hideSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: ColorConst.errorSnackbarColor,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      content: Text(
        text,
        style: fontStyleMedium13.copyWith(color: ColorConst.whiteColor),
      ),
    ),
  );
}

void showSuccessSnackBar(
  BuildContext context,
  String text, {
  bool needToTranslate = true,
}) {
  hideSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: ColorConst.successSnackbarColor,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      content: Text(
        text,
        style: fontStyleMedium13.copyWith(color: ColorConst.whiteColor),
      ),
    ),
  );
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
