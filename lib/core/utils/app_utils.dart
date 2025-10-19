import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../basic_features.dart';

class AppUtils {
  AppUtils._();

  static final instance = AppUtils._();

    Future<bool> checkConnectivity({bool showLoader = false}) async {
    // Step 1: Check device network state
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return false;
    }

    // Step 2: Verify actual internet access
    try {
      if(showLoader) {
        EasyLoading.show();
      }
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 2)); // quick timeout
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

}

Future showLogoutDialog({
  String? title,
  String? content,
  String? cancelText,
  Function? noFunction,
  String? yesText,
  Function? yesFunction,
}) {
  return Platform.isAndroid
      ? showDialog(
        context: GlobalVariable.appContext,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.r12),
            ),
            title: Text(title ?? "", style: fontStyleSemiBold16),
            content: Text(content ?? "", style: fontStyleMedium14),
            actions: [
              InkWell(
                onTap: () {
                  if (noFunction != null) {
                    noFunction();
                  }
                },
                child: Text(
                  cancelText ?? "",
                  style: fontStyleMedium14.apply(
                    color: ColorConst.textRedColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (yesFunction != null) {
                      yesFunction();
                    }
                  },
                  child: Text(yesText ?? "", style: fontStyleMedium14),
                ),
              ),
            ],
          );
        },
      )
      : showCupertinoDialog(
        barrierDismissible: true,
        context: GlobalVariable.appContext,
        builder:
            (context) => Theme(
              data: ThemeData(colorScheme: Theme.of(context).colorScheme),
              child: CupertinoAlertDialog(
                // title: Text(title!, style: context.fontStyleMedium16),
                content: Text(content!, style: fontStyleRegular12),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      cancelText!,
                      style: fontStyleMedium14.apply(
                        color: ColorConst.redButtonColor,
                      ),
                    ),
                    onPressed: () => noFunction!(),
                  ),
                  CupertinoDialogAction(
                    child: Text(yesText!, style: fontStyleMedium14),
                    onPressed: () => yesFunction!(),
                  ),
                ],
              ),
            ),
      );
}

Future showCustomDialog({required Widget widget}) {
  return showDialog(
    context: GlobalVariable.appContext,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r12),
        ),
        content: Center(child: widget),
        actions: [
          GestureDetector(
            child: Text("Ok", style: fontStyleMedium14),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future showCupertinoActionDialog({
  BuildContext? context,
  String? title,
  TextStyle? leftTextStyle,
  TextStyle? rightTextStyle,
  String? content,
  String? rightText,
  Function? rightOnTap,
  String? leftText,
  Function? leftOnTap,
}) {
  return showCupertinoDialog(
    context: GlobalVariable.appContext,
    builder:
        (context) => Theme(
          data: ThemeData.light(),
          child: CupertinoAlertDialog(
            title: Text(
              title!,
              style: fontStyleSemiBold17.apply(fontFamily: FontAsset.sfPro),
            ),
            content: Text(
              content!,
              style: fontStyleRegular13.apply(fontFamily: FontAsset.sfPro),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  leftOnTap!();
                },
                child: Text(
                  leftText ?? "",
                  style:
                      leftTextStyle ??
                      fontStyleMedium17.apply(
                        color: ColorConst.blueColor,
                        fontFamily: FontAsset.sfPro,
                      ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  rightOnTap!();
                },
                child: Text(
                  rightText ?? '',

                  style:
                      rightTextStyle ??
                      fontStyleSemiBold17.apply(
                        color: ColorConst.textRedColor,
                        fontFamily: FontAsset.sfPro,
                      ),
                ),
              ),
            ],
          ),
        ),
  );
}
