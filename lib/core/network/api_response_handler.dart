import 'dart:convert';

import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/authentications/signin_screen.dart';

import '../../generated/json/base/json_convert_content.dart';

// import '../basic_features.dart';
import 'api_result.dart';
import 'api_result_constant.dart';
import 'base_response_model_entity.dart';
import 'network_result.dart';

// Use when you need to manage internal status

APIResultState<T> getAPIResultFromNetwork<T>(NetworkResult networkResult) {
  switch (networkResult.networkResultType) {
    case NetworkResultType.error:
      var baseJson = json.decode(networkResult.result!);
      BaseResponseModelEntity baseResponseEntity =
          BaseResponseModelEntity.fromJson(baseJson);

      if (baseResponseEntity.status == 503) {
        // navigateToPageAndRemoveAllPage(UNDER_MAINTENANCE);
      } else if (baseResponseEntity.status == 426) {
        // navigateToPageAndRemoveAllPage(FORCE_UPDATE);
      }

      timber(baseResponseEntity.status);
      return FailureState(
        message: baseResponseEntity.message,
        result: baseResponseEntity.result,
        resultType: APIResultType.failure,
      );
    case NetworkResultType.noInternet:
      return const NoInternetState(resultType: APIResultType.noInternet);
    case NetworkResultType.timeOut:
      logger.w("user timeOut");
      return TimeOutState(resultType: APIResultType.timeOut);
    case NetworkResultType.unauthorised:
      SharedPrefUtils.onLogout();
      showErrorSnackBar(
        "Session Expired. Please login again.",
      );
      navigateToPageAndRemoveAllPage(SigninScreen());

      return UserUnauthorisedState(
        message: "User Unauthorised",
        resultType: APIResultType.unauthorised,
      );

    case NetworkResultType.notFound:
      SharedPrefUtils.onLogout();
      navigateToPageAndRemoveAllPage(SigninScreen());
      return const UserDeletedState(resultType: APIResultType.notFound);
    case NetworkResultType.success:
    default:
      {
        if (networkResult.result.isNullOrEmpty()) {
          return const FailureState(
            message: "",
            resultType: APIResultType.failure,
          );
        }
        try {
          var baseJson = json.decode(networkResult.result!);
          BaseResponseModelEntity baseResponseEntity =
              BaseResponseModelEntity.fromJson(baseJson);
          // BaseResponseModel baseResponseEntity = JsonConvert.fromJsonAsT(baseJson);
          if (baseResponseEntity.status == APIResultConstant.error) {
            return FailureState(
              message: baseResponseEntity.message.orEmpty(),
              resultType: APIResultType.failure,
            );
          } else if (baseResponseEntity.status ==
              APIResultConstant.userUnauthorised) {
            logger.w("user unautorized");
            navigateToPageAndRemoveAllPage(SigninScreen());
            return UserUnauthorisedState(
              message: "User Unauthorised",
              resultType: APIResultType.unauthorised,
            );
          } else if (baseResponseEntity.status ==
              APIResultConstant.userDeleted) {
            navigateToPageAndRemoveAllPage(SigninScreen());
            return UserUnauthorisedState(
              message: "User Unauthorised",
              resultType: APIResultType.unauthorised,
            );
          } else {
            if (baseResponseEntity.result != null) {
              if (baseResponseEntity.result.runtimeType != String) {
                T? responseModel = JsonConvert.fromJsonAsT<T>(
                  baseResponseEntity.result,
                );

                return SuccessState(
                  message: baseResponseEntity.message.orEmpty(),
                  resultType: APIResultType.success,
                  result: responseModel,
                );
              }
              return SuccessState(
                message: baseResponseEntity.message.orEmpty(),
                resultType: APIResultType.success,
                result: baseResponseEntity.result,
              );
            } else {
              return SuccessState(
                message: baseResponseEntity.message.orEmpty(),
                resultType: APIResultType.success,
                result: null,
              );
            }
          }
        } catch (e, s) {
          logger.w("result failure catch");
          // FirebaseCrashlytics.instance.recordError(e, s);
          return FailureState(
            message: e.toString(),
            resultType: APIResultType.failure,
          );
        }
      }
  }
}
