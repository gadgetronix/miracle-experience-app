import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichTextWidget extends RichText {
  CustomRichTextWidget.getDualText({
    super.key,
    required String firstText,
    required String secondText,
    required TextStyle firstTextStyle,
    TextAlign? textAlign,
    int? maxlines,
    required TextStyle secondTextStyle,
  }) : super(
         //    maxLines: null,
         // overflow: TextOverflow.ellipsis,
         textAlign: textAlign ?? TextAlign.start,
         text: TextSpan(
           text: firstText,
           style: firstTextStyle,
           children: <TextSpan>[
             TextSpan(
               text: secondText,
               style: secondTextStyle,
             ),
           ],
         ),
       );

  CustomRichTextWidget.threeRichText({
    super.key,
    required String firstText,
    required String secondText,
    required String thirdText,
    required TextStyle firstTextStyle,
    required TextStyle secondTextStyle,
    required TextStyle thirdTextStyle,
    GestureRecognizer? onSecondTextTap,
    TextAlign? textAlign,
  }) : super(
         textAlign: textAlign ?? TextAlign.left,
         text: TextSpan(
           text: firstText,
           style: firstTextStyle,
           children: <TextSpan>[
             const TextSpan(text: " "),
             TextSpan(
               text: secondText,
               style: secondTextStyle,
               recognizer: onSecondTextTap,
             ),
             const TextSpan(text: " "),
             TextSpan(text: thirdText, style: thirdTextStyle),
           ],
         ),
       );
}
