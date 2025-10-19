import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color_const.dart';
import '../../constants/dimensions.dart';
import '../../utils/style.dart';

class ExpandTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final double? height;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? title;
  final TextEditingController? textController;
  final Color? hintTextColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? inputType;
  final int? maxLine, maxLength;
  final TextInputType? keyBoardType;
  final bool? obscureText;
  final ValueChanged? onChanged;
  final ValueChanged? onFieldSubmit;
  final FormFieldValidator? validator;
  final String? hintText;
  final Color? boxColor;

  const ExpandTextField(
      {super.key,
      this.readOnly = false,
      this.inputFormatters,
      this.height,
      this.focusNode,
      this.maxLine,
      this.maxLength,
      this.keyBoardType,
      this.title,
      this.validator,
      this.obscureText = false,
      this.textController,
      this.onFieldSubmit,
      this.hintTextColor,
      this.suffixIcon,
      this.onChanged,
      this.textInputAction,
      this.hintText,
      this.inputType,
      this.boxColor,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return  Container(
    //  height: height??Dimensions.h50,

      // padding: EdgeInsets.fromLTRB(Dimensions.w16, 0, Dimensions.h12, 0),
      //padding: EdgeInsets.fromLTRB(20, 11, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.r8),
        ),
        color: boxColor ?? ColorConst.whiteColor,
        border: Border.all(
          color: ColorConst.textFieldBorderColor,
        ),
      ),
      child: Center(
        child: TextFormField(
          readOnly: readOnly,
          textCapitalization: TextCapitalization.sentences,

          focusNode: focusNode,

          obscureText: obscureText!,
          style: readOnly
              ? fontStyleMedium14.apply(
                  color: ColorConst.textColor.withOpacity(0.5))
              : fontStyleSemiBold14,

          textAlignVertical: TextAlignVertical.center,

          //  textAlign: TextAlign.center,
          maxLines: null,
          onFieldSubmitted: onFieldSubmit,
          controller: textController,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r8),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: EdgeInsets.only(
                top: Dimensions.h20,
                left: Dimensions.h16,
                right: Dimensions.h12,
                bottom: Dimensions.h20),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText ?? "",
            hintStyle: fontStyleRegular14.apply(color: ColorConst.hintColor),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),

          onChanged: (val) {
            onChanged!(val);
          },
          onSaved: (value) {
            value = textController!.text;
          },

          keyboardType: keyBoardType,
        ),
      ),
    );
  }
}
