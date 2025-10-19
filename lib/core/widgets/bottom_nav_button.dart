import 'dart:io';
import 'package:flutter/material.dart';
import '../basic_features.dart';

class BottomNavButton extends StatelessWidget {
  final String text;
  final Color? bgColor, textColor;
  final double? height;
  final String? icon;
  final Color? buttonTextColor;
  final double? elevation;
  final Function onPressed;

  const BottomNavButton({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.height,
    this.bgColor,
    this.icon,
    this.buttonTextColor,
    this.elevation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onPressed();
      },
      child: Container(
          padding: EdgeInsets.only(
              bottom: Dimensions.getSafeAreaBottomHeight() == 0
                  ? 0
                  : Platform.isAndroid
                      ? Dimensions.getSafeAreaBottomHeight()
                      : 12),
          color: bgColor ?? ColorConst.primaryColor,
          height: Dimensions.bottomPadding(),
          width: double.infinity,
          child: Center(
              child: Text(text,
                  style: fontStyleBold14.apply(
                      color: textColor ?? ColorConst.whiteColor)))),
    );
  }
}

class BottomNavButtonWithSpacing extends StatelessWidget {
  final String text;
  final Color? bgColor, textColor;
  final double? height;
  final String? icon;
  final Color? buttonTextColor;
  final double? elevation;
  final Function onPressed;

  const BottomNavButtonWithSpacing({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.height,
    this.bgColor,
    this.icon,
    this.buttonTextColor,
    this.elevation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.commonPaddingForScreen,
          left: Dimensions.commonPaddingForScreen,
          right: Dimensions.commonPaddingForScreen,
          bottom: Dimensions.commonPaddingForScreen +
              (Dimensions.getSafeAreaBottomHeight() == 0
                  ? 0
                  : Platform.isAndroid
                      ? Dimensions.getSafeAreaBottomHeight()
                      : 12)),

      //  height: AppUtils.instance.bottomPadding(context),
      //   width: double.infinity,
      child: MyButton(
        btnBgColor: bgColor ?? ColorConst.primaryColor,
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          onPressed();
        },
        title: text,
        textStyle:
            fontStyleBold14.apply(color: textColor ?? ColorConst.whiteColor),
      ),
    );
  }
}

class LoginBottomNavButton extends StatelessWidget {
  final String text, subText;
  final Function onPressed;

  const LoginBottomNavButton(
      {super.key,
      required this.text,
      required this.subText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onPressed();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
                bottom: Dimensions.getSafeAreaBottomHeight() == 0
                    ? 0
                    : Platform.isAndroid
                        ? Dimensions.getSafeAreaBottomHeight()
                        : 12),
            // color: ColorConst.primaryColor,R
            height: Dimensions.bottomPadding(),
            width: double.infinity,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: text, style: fontStyleSemiBold15),
                    const TextSpan(text: " "),
                    TextSpan(
                        text: subText,
                        style: fontStyleSemiBold15.apply(
                            color: ColorConst.primaryColor)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
