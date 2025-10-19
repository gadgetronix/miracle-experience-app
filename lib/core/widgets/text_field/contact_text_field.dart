import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color_const.dart';
import '../../constants/dimensions.dart';
import '../../utils/style.dart';

class ContactTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final Widget? suffixIcon;
  final String? title;
  final TextEditingController? textController;
  final Color? hintTextColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? inputType;
  final int? maxLine, minLine, maxLength;
  final TextInputType? keyBoardType;
  final bool? obscureText;
  final ValueChanged? onChanged;
  final ValueChanged? onFieldSubmit;
  final FormFieldValidator? validator;
  final String? hintText;

  const ContactTextField({
    super.key,
    this.inputFormatters,
    this.height,
    this.focusNode,
    this.maxLine,
    this.minLine,
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
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        // padding: EdgeInsets.fromLTRB(Dimensions.w16, 0, Dimensions.h12, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.r14)),
          color: ColorConst.whiteColor,
          // border: Border.all(color: ColorConst.textFieldBorderColor),
        ),
        child: TextFormField(
          focusNode: focusNode,
          textCapitalization: TextCapitalization.sentences,

          textInputAction: textInputAction,
          style: fontStyleSemiBold14,
          // textAlignVertical: TextAlignVertical.center,
          //  textAlign: TextAlign.center,
          maxLines: maxLine,
          minLines: minLine,
          onFieldSubmitted: onFieldSubmit,
          controller: textController,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r8),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
            ),
            contentPadding: EdgeInsets.only(
              top: Dimensions.h18,
              left: Dimensions.h16,
              right: Dimensions.h12,
              bottom: Dimensions.h18,
            ),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText ?? "",
            hintStyle: fontStyleRegular14.apply(color: ColorConst.hintColor),
            suffixIcon: suffixIcon,
          ),

          onChanged: (val) {
            if (onChanged != null) {
              onChanged!(val);
            }
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
