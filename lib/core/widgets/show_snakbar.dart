import 'package:flutter/material.dart';
import '../basic_features.dart';

void showErrorSnackBar(
  String text, {
  bool needToTranslate = true,
}) {
  hideSnackBar(GlobalVariable.appContext);
  ScaffoldMessenger.of(GlobalVariable.appContext).showSnackBar(
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
  String text, {
  bool needToTranslate = true,
}) {
  hideSnackBar(GlobalVariable.appContext);
  ScaffoldMessenger.of(GlobalVariable.appContext).showSnackBar(
    SnackBar(
      backgroundColor: ColorConst.successColor,
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
