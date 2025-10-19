import 'package:flutter/material.dart';
import '../basic_features.dart';
import '../widgets/show_snakbar.dart';

import '../network/api_result.dart';

class BlocConsumerRoundedButtonWithBottomSheet<
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
  final Color textColor;
  final Color progressColor;
  final double? textSize;
  final double? height;
  final double? width;
  final double? borderWidth;

  BlocConsumerRoundedButtonWithBottomSheet(
    this.buttonLabel,
    this.onTap,
    this.onSuccess, {
    super.key,
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
    this.progressColor = ColorConst.primaryColor,
    this.textColor = Colors.white,
    this.textSize,
  }) : assert(T != dynamic);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<E, APIResultState<T>?>(
      listener: (BuildContext context, APIResultState<T>? value) {
        if (value != null) {
          if (value.resultType == APIResultType.noInternet) {
            showSnackBar(context, value.message ?? '');
            // _showToastMessage(context, value.message);
            if (onNoInternet != null) Function.apply(onNoInternet!, []);
          } else if (value.resultType == APIResultType.failure) {
            if (needToShowDefaultErrorSnackBar) {
              showSnackBar(context, value.message ?? '');
            }
            if (onError != null) Function.apply(onError!, [value.message]);
          } else if (value.resultType == APIResultType.success) {
            if (needToShowDefaultSuccessSnackBar) {
              // Const.instance.toastSuccess("val");
              showSnackBar(context, value.message ?? '');
            }
            Function.apply(onSuccess, [value.result, value.message]);
          }
        }
      },
      builder: (BuildContext context, APIResultState<T>? value) {
        return GestureDetector(
          onTap: isEnabled
              ? () {
                  if ((value == null ||
                      value.resultType != APIResultType.loading)) {
                    Function.apply(onTap, []);
                  }
                }
              : null,
          child: SizedBox(
            width: width ?? double.infinity,
            child: APIResult.isLoading(value)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Dimensions.h25,
                        height: Dimensions.h25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    buttonLabel,
                    style:
                        textStyle ??
                        fontStyleSemiBold17.apply(color: Colors.white),
                  ),
          ),
        );
      },
    );
  }
}
