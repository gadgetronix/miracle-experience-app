import 'package:flutter/material.dart';
import '../widgets/show_snakbar.dart';

import '../basic_features.dart';
import '../network/api_result.dart';

class BlocConsumerRoundedButtonWithProgress<
  E extends Cubit<APIResultState<T>?>,
  T
>
    extends StatelessWidget {
  final String buttonLabel;
  final void Function() onTap;
  final void Function(T? result, String successMessage) onSuccess;
  final void Function(String? message)? onError;
  final void Function()? onNoInternet;
  final bool needToShowDefaultSuccessSnackBar;
  final bool needToShowDefaultErrorSnackBar;
  final bool isEnabled;
  final Color backGroundColor;
  final TextStyle? textStyle;
  final Color borderColor;
  final Color? textColor;
  final Color? progressColor;
  final double? textSize;
  final double? height;
  final double? width;
  final double? borderWidth;
  final String? trailingImage;

  BlocConsumerRoundedButtonWithProgress({
    super.key,
    required this.buttonLabel,
    required this.onTap,
    required this.onSuccess,
    this.onError,
    this.onNoInternet,
    this.height,
    this.width,
    this.needToShowDefaultSuccessSnackBar = false,
    this.needToShowDefaultErrorSnackBar = true,
    this.isEnabled = true,
    this.textStyle,
    this.borderWidth = 1.0,
    this.backGroundColor = ColorConst.primaryColor,
    this.borderColor = Colors.transparent,
    this.progressColor,
    this.textColor,
    this.textSize, this.trailingImage,
  }) : assert(T != dynamic);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<E, APIResultState<T>?>(
      listener: (BuildContext context, APIResultState<T>? value) {
        timber("Value is: ${value?.resultType} ${value?.message}");
        if (value != null) {
          if (value.resultType == APIResultType.noInternet) {
            // Const.showToast(value.message);
            if (onNoInternet != null) Function.apply(onNoInternet!, []);
          } else if (value.resultType == APIResultType.failure) {
            if (needToShowDefaultErrorSnackBar) {
              showErrorSnackBar(value.message ?? '');
            }
            if (onError != null) Function.apply(onError!, [value.message]);
          } else if (value.resultType == APIResultType.unauthorised) {
            if (needToShowDefaultErrorSnackBar) {
              showErrorSnackBar(value.message ?? '');
            }
            if (onError != null) Function.apply(onError!, [value.message]);
          } else if (value.resultType == APIResultType.success) {
            if (needToShowDefaultSuccessSnackBar) {
              showSuccessSnackBar(value.message ?? '');
            }
            Function.apply(onSuccess, [value.result, value.message]);
          }
        }
      },
      builder: (BuildContext context, APIResultState<T>? value) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: borderWidth!),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isEnabled
              ? () {
                  if ((value == null ||
                      value.resultType != APIResultType.loading)) {
                    Function.apply(onTap, []);
                  }
                }
              : null,
          child: APIResult.isLoading(value)
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor ?? ColorConst.whiteColor),
                  ),
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(trailingImage != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(trailingImage ?? '', height: 20, width: 20,),
                  ),
                  Text(
                      buttonLabel,
                      style:
                          textStyle ??
                          fontStyleSemiBold16.apply(color: textColor ?? Colors.white),
                    ),
                ],
              ),
        );
      },
    );
  }
}
