import 'package:flutter/material.dart';
import '../widgets/custom_rich_text_widget.dart';
import '../basic_features.dart';

class RoundedRectangleButton extends ElevatedButton {
  RoundedRectangleButton.textButton({
    super.key,
    required final String text,
    final double? miniWidth,
    final double? height,
    final TextStyle? textStyle,
    final double? elevation,
    final double? cornerRadius,
    final Color? btnBgColor,
    final Color? borderColor,
    required super.onPressed,
  }) : assert(text.isNotEmpty, "Text must not be null"),
       super(
         child: Text(text, style: textStyle ?? fontStyleSemiBold18),
         style: ElevatedButton.styleFrom(
           elevation: 0,
           minimumSize: Size(
             miniWidth ?? double.infinity,
             height ?? Dimensions.h50,
           ),
           // fixedSize:
           // Size(miniWidth ?? double.infinity, height ?? Dimensions.h40),
           backgroundColor: btnBgColor ?? Colors.transparent,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(
               cornerRadius ?? Dimensions.r10,
             ),
             side: BorderSide(color: borderColor ?? Colors.transparent),
           ),
         ),
       );

  RoundedRectangleButton.iconTextButton({
    super.key,
    required final String text,
    required final Widget icon,
    final double? miniWidth,
    final double? height,
    final TextStyle? textStyle,
    final double? elevation,
    final double? cornerRadius,
    final Color? btnBgColor,
    final Color? borderColor,
    required super.onPressed,
  }) : assert(text.isNotEmpty, "Text must not be null"),
       super(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             icon,
             SizedBox(width: Dimensions.w5),
             Text(text, style: textStyle ?? fontStyleSemiBold18),
           ],
         ),
         style: ElevatedButton.styleFrom(
           elevation: 0,
           minimumSize: Size(
             miniWidth ?? double.infinity,
             height ?? Dimensions.h60,
           ),
           // fixedSize:
           // Size(miniWidth ?? double.infinity, height ?? Dimensions.h40),
           backgroundColor: btnBgColor ?? Colors.transparent,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(
               cornerRadius ?? Dimensions.r10,
             ),
             side: BorderSide(color: borderColor ?? Colors.transparent),
           ),
         ),
       );
}

class MyButton extends StatelessWidget {
  final double? miniWidth;
  final double? height;
  final TextStyle? textStyle;
  final double? elevation;
  final String? title;
  final bool? loading;
  final double? cornerRadius;
  final Color? btnBgColor, disableBgColor;
  final VoidCallback? onPressed;
  final BorderSide? borderSide;

  const MyButton({
    super.key,
    this.miniWidth,
    this.height,
    this.elevation,
    this.cornerRadius,
    required this.title,
    this.btnBgColor,
    this.textStyle,
    required this.onPressed,
    this.loading,
    this.borderSide,
    this.disableBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size(miniWidth ?? double.infinity, height ?? Dimensions.h55),
        backgroundColor: btnBgColor ?? ColorConst.primaryColor,
        disabledBackgroundColor: disableBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius ?? Dimensions.r8),
          side: borderSide ?? BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          title!,
          style: textStyle ?? fontStyleBold14.apply(color: Colors.white),
        ),
      ),
    );
  }
}

class MyImageTextButton extends StatelessWidget {
  final double? miniWidth;
  final double? height;
  final TextStyle? textStyle;
  final double? elevation;
  final String? title;
  final bool? loading;
  final double? cornerRadius;
  final Color? btnBgColor;
  final Function onPressed;
  final BorderSide? borderSide;
  final Widget icon;
  final String? label;

  const MyImageTextButton({
    super.key,
    this.miniWidth,
    this.height,
    this.elevation,
    this.cornerRadius,
    required this.title,
    this.btnBgColor,
    this.textStyle,
    required this.onPressed,
    this.loading,
    this.borderSide,
    required this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: elevation ?? 0,
          fixedSize: Size(
            miniWidth ?? double.infinity,
            height ?? Dimensions.h55,
          ),
          backgroundColor: btnBgColor ?? ColorConst.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius ?? Dimensions.r8),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        onPressed: () {
          onPressed();
        },
        icon: icon,
        label: Text(label ?? title!, style: textStyle),
      ),
    );
  }
}

class MyOutLineButton extends StatelessWidget {
  final double? miniWidth;
  final double? height;
  final TextStyle? textStyle;
  final double? elevation;
  final String? title;
  final bool? loading;
  final double? cornerRadius;
  final Color? btnBgColor;
  final Color? borderColor;
  final Function onPressed;

  const MyOutLineButton({
    super.key,
    this.miniWidth,
    this.height,
    this.borderColor,
    this.elevation,
    this.cornerRadius,
    required this.title,
    this.btnBgColor,
    this.textStyle,
    required this.onPressed,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size(miniWidth ?? double.infinity, height ?? Dimensions.h50),
        backgroundColor: btnBgColor ?? ColorConst.whiteColor,
        side: BorderSide(
          width: 1.0,
          color: borderColor ?? ColorConst.textFieldBorderColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius ?? Dimensions.r10),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Center(
        child: Text(title!, style: textStyle ?? fontStyleSemiBold15),
      ),
    );
  }
}

class CheckedLineButton extends StatelessWidget {
  final double? miniWidth;
  final double? height;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double? elevation;
  final String? title;
  final String? icon;
  final bool? loading;
  final double? cornerRadius;
  final Color? btnBgColor;
  final bool? isSelected;
  final Function onPressed;

  const CheckedLineButton({
    super.key,
    this.miniWidth,
    this.height,
    this.elevation,
    this.cornerRadius,
    required this.title,
    required this.isSelected,
    this.btnBgColor,
    this.icon,
    this.textStyle,
    this.selectedTextStyle,
    required this.onPressed,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.h30,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w2),
              child: Center(
                child: Text(
                  title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: isSelected == true ? selectedTextStyle : textStyle,
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.w3),
            width: Dimensions.w35,
            height: isSelected == true ? Dimensions.h2 : Dimensions.h1,
            color:
                isSelected == true
                    ? ColorConst.primaryColor
                    : Colors.transparent,
          ),
        ],
      ),
    );
    // SizedBox(
    //   width: miniWidth ?? double.infinity,
    //   height: height ?? Dimensions.h50,
    //   child: Column(
    //     children: [
    //       ElevatedButton(
    //         style: ElevatedButton.styleFrom(
    //           elevation: 0,
    //           fixedSize:
    //               Size(miniWidth ?? double.infinity, height ?? Dimensions.h40),
    //           backgroundColor: Colors.transparent,
    //           shape: RoundedRectangleBorder(
    //             borderRadius:
    //                 BorderRadius.circular(cornerRadius ?? Dimensions.r24),
    //           ),
    //         ),
    //         onPressed: () {
    //           onPressed();
    //         },
    //         child: icon != null
    //             ? Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(
    //                         top: 18.0, bottom: 18.0, right: 5.0),
    //                     child: Image.asset(
    //                       icon!,
    //                       width: height,
    //                     ),
    //                   ),
    //                   Text(title ?? "",
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: textStyle ??
    //                           fontStyleMedium10.apply(color: Colors.white)),
    //                 ],
    //               )
    //             : Text(title ?? "",
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //                 style: textStyle ??
    //                     fontStyleMedium10.apply(color: Colors.white)),
    //       ),
    //       SizedBox(
    //         height: Dimensions.h3,
    //       ),
    //       Container(
    //         margin: EdgeInsets.symmetric(horizontal: Dimensions.w8),
    //         height: isSelected == true ? Dimensions.h2 : Dimensions.h1,
    //         color: isSelected == true
    //             ? ColorConst.textPurpleColor
    //             : ColorConst.dividerColor,
    //       )
    //     ],
    //   ),
    // );
  }
}

class RichTextButton extends StatelessWidget {
  final double? miniWidth;
  final double? height;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final double? elevation;
  final String? title;
  final bool? loading;
  final double? cornerRadius;
  final Color? btnBgColor;
  final Function onPressed;
  final String? firstText;
  final String? secondText;

  const RichTextButton({
    super.key,
    this.miniWidth,
    this.height,
    this.elevation,
    this.cornerRadius,
    this.title,
    this.btnBgColor,
    required this.onPressed,
    this.loading,
    this.firstText,
    this.secondText,
    this.firstTextStyle,
    this.secondTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size(miniWidth ?? double.infinity, height ?? Dimensions.h55),
        backgroundColor: btnBgColor ?? ColorConst.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius ?? Dimensions.r8),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Center(
        child: CustomRichTextWidget.getDualText(
          firstText: firstText ?? "", //AppString.iHaveAccepted,
          secondText: secondText ?? "", //AppString.termsConditions,
          firstTextStyle:
              firstTextStyle ??
              fontStyleRegular14.copyWith(color: ColorConst.primaryColor),
          secondTextStyle:
              secondTextStyle ??
              fontStyleBold14.copyWith(color: ColorConst.primaryColor),
        ),
      ),
    );
  }
}
