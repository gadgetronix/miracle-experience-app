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
         //  backgroundColor: ColorConst.primaryColor,
         flexibleSpace: Container(
           decoration: BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
               colors: [
                 // This color will be at the very top (the status bar area)
                 ColorConst.primaryColor,
                 // This color will be at the bottom (the main AppBar area)
                 Colors.white,
               ],
               // The gradient stops exactly at the boundary between the status bar and the AppBar.
               // This creates the sharp two-color effect.
               stops: [
                 0.5,
                 Dimensions.getSafeAreaTopHeight() /
                     (Dimensions.getSafeAreaTopHeight() + kToolbarHeight),
               ],
             ),
           ),
         ),
         // This is crucial for the icon brightness.
         // We set it to light because the top part is red.
         systemOverlayStyle: const SystemUiOverlayStyle(
           statusBarIconBrightness: Brightness.light,
         ),
         leading:
             showLeading
                 ? Padding(
                   padding: EdgeInsets.only(left: Dimensions.w3),
                   child: InkWell(
                     child: const Icon(
                       Icons.arrow_back_ios,
                       size: 20,
                       color: ColorConst.blackColor,
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
         title:
             titleWidget ??
             Text(title, style: textStyle ?? fontStyleSemiBold18),
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
      );
}
