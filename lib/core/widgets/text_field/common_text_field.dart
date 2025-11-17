import '../../utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color_const.dart';
// import '../../constants/dimensions.dart';
import '../../utils/style.dart';

class CommonTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final double? height;
  final Widget? suffixIcon;
  final String? title;
  final TextStyle? titleTextStyle;
  final TextEditingController? textController;
  final Color? hintTextColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLine, maxLength, minLine;
  final TextInputType? keyBoardType;
  final bool? obscureText;
  final bool? autoFocus;
  final bool readOnly;
  final Color? fillColor;
  final ValueChanged? onChanged;
  final Function? onTap;
  final ValueChanged? onFieldSubmit;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? prefixIcon;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;

  const CommonTextField({
    super.key,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.height,
    this.focusNode,
    this.maxLine,
    this.maxLength,
    this.keyBoardType,
    this.title,
    this.titleTextStyle,
    this.validator,
    this.obscureText = false,
    this.textController,
    this.onFieldSubmit,
    this.fillColor,
    this.onEditingComplete,
    this.hintTextColor,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.contentPadding,
    this.textInputAction,
    this.textStyle,
    this.hintTextStyle,
    this.hintText,
    this.autoFocus,
    this.prefixIcon,
    this.minLine, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: 6,
              // top: 14,
            ),
            child: Text(title!, style: titleTextStyle ?? fontStyleMedium14),
          ),
        TextFormField(
          key: key,
          textInputAction: textInputAction,
          validator: validator,
          textCapitalization: textCapitalization,
          // readOnly: readOnly,
          enabled: !readOnly,
          focusNode: focusNode,
          obscureText: obscureText ?? false,
          autofocus: autoFocus ?? false,
          maxLines: maxLine ?? 1,
          minLines: minLine,
          maxLength: maxLength,
          controller: textController,
          cursorColor: ColorConst.primaryColor,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmit,
          onEditingComplete: onEditingComplete,
          onChanged: (val) => onChanged?.call(val),
          onTap: () => onTap?.call(),
          keyboardType: keyBoardType,
          style:
              textStyle ??
              (readOnly
                  ? fontStyleMedium14.apply(
                      color: ColorConst.textColor.withOpacity(0.5),
                    )
                  : fontStyleRegular14),
          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            filled: true,
            fillColor: fillColor ?? ColorConst.textFieldColor,
            hintText: hintText ?? '',
            hintStyle:
                hintTextStyle ??
                fontStyleRegular13.apply(color: ColorConst.hintColor),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
            border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorConst.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorConst.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorConst.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ColorConst.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
            errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
