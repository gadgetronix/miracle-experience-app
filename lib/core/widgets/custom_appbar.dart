import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../basic_features.dart';

class CustomAppBar extends AppBar {
  CustomAppBar.backActionCenterTitleAppBar({
    super.key,
    required String title,
    Widget? titleWidget,
    double super.elevation = 0.5,
    Color? bgColor,
    TextStyle? textStyle,
    bool showLeading = true,
    bool centerTile = true,
    Function? backPress,
    bool isRoundBackArrow = false,
    bool isSpacing = true,
    super.actions,
  }) : super(
         automaticallyImplyLeading: false,
         centerTitle: centerTile,
         backgroundColor: ColorConst.whiteColor,
         surfaceTintColor: Colors.transparent,

         leading: showLeading
             ? Padding(
                 padding: EdgeInsets.only(left: Dimensions.w3),
                 child: InkWell(
                   child: const Icon(
                     Icons.arrow_back_ios_new,
                     size: 20,
                     color: ColorConst.textColor,
                   ),
                   onTap: () {
                     if (backPress != null) {
                       backPress();
                       return;
                     } else {
                       Navigator.pop(GlobalVariable.appContext);
                     }
                   },
                 ),
               )
             : null,
         title: titleWidget ?? Text(title, style: textStyle ?? fontStyleBold18),
       );

  CustomAppBar.rowAppBar({super.key, double elevation = 1, required Widget row})
    : super(
        elevation: elevation,
        title: row,
        centerTitle: true,
        automaticallyImplyLeading: false,
      );

  CustomAppBar.blankAppbar({double? height, super.backgroundColor, super.key})
    : super(
        toolbarHeight: height ?? 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      );
}
