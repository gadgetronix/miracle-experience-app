import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../basic_features.dart';


class LoginTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final String? countryCode;
  final String? isdCode;
  final Widget? suffixIcon;

  final String? title;
  final TextEditingController? textController;
  final Color? hintTextColor;
  final FocusNode? focusNode;
  final TextInputType keyBoardType;
  final ValueChanged? onChanged;
  final ValueChanged? onFieldSubmit;
  final FormFieldValidator? validator;
  final String? hintText;
  final Function(String? code, String? dialcode) getCountryCode;
  final bool showCountryCode;
  final bool isRoundedCornor;
  final TextInputAction? textInputAction;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool readOnly;
  final bool showFlag;
  final Color? textFieldColor;
  final Color? fillColor;

  const LoginTextField({
    super.key,
    this.inputFormatters,
    this.suffixIcon,
    this.focusNode,
    this.isdCode,
    this.countryCode,
    this.title,
    this.validator,
    this.textController,
    this.onFieldSubmit,
    this.hintTextColor,
    this.onChanged,
    this.hintText,
    required this.getCountryCode,
    this.isRoundedCornor = true,
    this.showCountryCode = true,
    this.keyBoardType = TextInputType.phone,
    this.textInputAction,
    this.hintTextStyle,
    required this.readOnly,
    this.showFlag = true,
    this.textFieldColor,
    this.textStyle,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotNullAndEmpty())
          Padding(
            padding: EdgeInsets.only(
              bottom: Dimensions.h8,
              top: Dimensions.h14,
            ),
            child: Text(title!, style: fontStyleSemiBold13),
          ),
        Container(
          height: Dimensions.h50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.r8)),
            color: textFieldColor ?? ColorConst.textFieldColor,
            border: Border.all(color: ColorConst.dividerColor),
          ),
          child: Row(
            children: [
              // Visibility(
              //   visible: showCountryCode,
              //   child: CountryCodePicker(
              //     onChanged: (e) {
              //       logger.d(e.dialCode!.replaceAll("+", ""));
              //       logger.d(e.code!.replaceAll("+", ""));

              //       getCountryCode(e.code, e.dialCode);
              //     },
              //     initialSelection: countryCode ?? "+255",
              //     padding: EdgeInsets.only(
              //       left: showCountryCode ? Dimensions.w8 : Dimensions.w16,
              //     ),
              //     textStyle:
              //         textStyle ??
              //         (readOnly
              //             ? fontStyleMedium13.apply(
              //               color: ColorConst.textColor.withOpacity(0.5),
              //             )
              //             : fontStyleSemiBold14),
              //     showCountryOnly: false,
              //     dialogSize: Size(
              //       MediaQuery.of(context).size.width - 50,
              //       MediaQuery.of(context).size.height - 250,
              //     ),
              //     showOnlyCountryWhenClosed: false,
              //     favorite: const ['+1'],
              //     showFlag: showFlag,
              //     flagWidth: Dimensions.w33,
              //     flagDecoration: const BoxDecoration(shape: BoxShape.circle),
              //   ),
              // ),
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  readOnly: readOnly,
                  style:
                      textStyle ??
                      (readOnly
                          ? fontStyleMedium13.apply(
                            color: ColorConst.textColor.withOpacity(0.5),
                          )
                          : fontStyleSemiBold14),
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: onFieldSubmit,
                  controller: textController,
                  inputFormatters: inputFormatters,
                  textInputAction: textInputAction,
                  maxLength: 11,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: Dimensions.h15,
                      bottom: Dimensions.h15,
                      right: Dimensions.h12,
                      left: showCountryCode ? 0 : Dimensions.w16,
                    ),
                    counterText: "",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    fillColor: fillColor ?? ColorConst.textFieldFillColor,
                    filled: true,
                    hintText: hintText ?? "",
                    hintStyle:
                        hintTextStyle ??
                        fontStyleRegular14.apply(color: ColorConst.hintColor),
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
            ],
          ),
        ),
      ],
    );
  }
}
