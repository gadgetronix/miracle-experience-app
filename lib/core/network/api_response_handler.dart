import 'dart:convert';

// import 'package:device_info_plus/device_info_plus.dart';


import 'package:miracle_experience_mobile_app/generated/json/base/json_convert_content.dart';

import '../utils/enum.dart';
import '../utils/extension.dart';

// import '../basic_features.dart';
import 'api_result.dart';
import 'network_result.dart';

// Use when you need to manage internal status

// APIResult<T> getAPIResultFromNetwork<T>(NetworkResult networkResult) {
//   switch (networkResult.networkResultType) {
//     case NetworkResultType.error:
//       var baseJson = json.decode(networkResult.result!);
//       BaseResponseModelEntity baseResponseEntity =
//       BaseResponseModelEntity.fromJson(baseJson);
//
//       if (baseResponseEntity.status == 503) {
//         // navigateToPageAndRemoveAllPage(UNDER_MAINTENANCE);
//       } else if (baseResponseEntity.status == 426) {
//         // navigateToPageAndRemoveAllPage(FORCE_UPDATE);
//       }
//
//       logger.d(  baseResponseEntity.status);
//       return APIResult.failure(baseResponseEntity.message,
//           result: baseResponseEntity.result?.first);
//     case NetworkResultType.noInternet:
//       // navigateToPageAndRemoveAllPage(No_INTERNET_ROUTE);
//       // if(SharedPrefUtils.getIsUserLoggedIn()){
//       //   navigateToPageAndRemoveAllPage(const NoInterNetScreen());
//       // }
//       // else{
//         Const.showToast("No Internet Connection");
//       // }
//       return APIResult.noInternet();
//     case NetworkResultType.timeOut:
//       Const.showToast("Request timeOut");
//       logger.w("user timeOut");
//       return APIResult.timeOut();
//     case NetworkResultType.unauthorised:
//
//       SharedPrefUtils.remove();
//       Const.showToast("Your account is deactivated or deleted.");
//       //  navigateToPageAndRemoveAllPage(LOGIN_ROUTE);
//
//       return APIResult.sessionExpired();
//
//     case NetworkResultType.notFound:
//       SharedPrefUtils.remove();
//
//       return APIResult.userUnauthorised();
//     case NetworkResultType.cacheError:
//       return APIResult.failure(AppString.error);
//     case NetworkResultType.success:
//     default:
//       {
//         logger.wtf("11");
//         if (networkResult.result.isNullOrEmpty()) {
//           logger.w("user isNullOrEmpty");
//           return APIResult.failure("");
//         }
//         try {
//           var baseJson = json.decode(networkResult.result!);
//           BaseResponseModelEntity baseResponseEntity =
//           BaseResponseModelEntity.fromJson(baseJson);
//           // BaseResponseModel baseResponseEntity = JsonConvert.fromJsonAsT(baseJson);
//           if (baseResponseEntity.status == APIResultConstant.error) {
//             logger.w("user-- ERROR");
//             return APIResult.failure(baseResponseEntity.message.orEmpty(),);
//           } else if (baseResponseEntity.status == APIResultConstant.userUnauthorised) {
//             logger.w("user unautorized");
//             // navigateToPageAndRemoveAllPage(GlobalVariable.navigatorKey.currentContext!, LOGIN_ROUTE,);
//             return APIResult.userUnauthorised();
//           } else if (baseResponseEntity.status ==
//               APIResultConstant.userDeleted) {
//             logger.w("user USER_DELETED");
//             return APIResult.userUnauthorised();
//           } else {
//             print("Inside success");
//             if (baseResponseEntity.result != null) {
//                if (baseResponseEntity.result.runtimeType != String) {
//                  T? responseModel =
//                      JsonConvert.fromJsonAsT<T>(baseResponseEntity.result);
//
//                  return APIResult.success(
//                      baseResponseEntity.message.orEmpty(), responseModel);
//                }
//               return APIResult.success(baseResponseEntity.message.orEmpty(),
//                   baseResponseEntity.result);
//             } else {
//               return APIResult.success(
//                   baseResponseEntity.message.orEmpty(), null);
//             }
//           }
//         } catch (e, s) {
//           logger.w("result failure catch");
//           // FirebaseCrashlytics.instance.recordError(e, s);
//           return APIResult.failure(AppString.error);
//         }
//       }
//   }
// }

APIResultState<T> getAPIResultFromNetworkWithoutBase<T>(
  NetworkResult networkResult,
) {
  switch (networkResult.networkResultType) {
    case NetworkResultType.error:
      return const FailureState(
        message: "Error",
        resultType: APIResultType.failure,
      );
    case NetworkResultType.noInternet:
      return const NoInternetState(resultType: APIResultType.noInternet);
    case NetworkResultType.unauthorised:
      return UserUnauthorisedState(
        message: "User Unauthorised",
        resultType: APIResultType.unauthorised,
      );
    case NetworkResultType.notFound:
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
          if (networkResult.result != null) {
            var baseJson = json.decode(networkResult.result!);

            T? responseModel = JsonConvert.fromJsonAsT<T>(baseJson);

            return SuccessState(
              message: "",
              resultType: APIResultType.success,
              result: responseModel,
            );
          } else {
            return const SuccessState(
              message: "",
              resultType: APIResultType.success,
              result: null,
            );
          }
        } catch (e) {
          //FirebaseCrashlytics.instance.recordError(e, s);
          return FailureState(
            message: e.toString(),
            resultType: APIResultType.failure,
          );
        }
      }
  }
}

// APIResult<T> getAPIResultFromNetworkWithoutBase<T>(
//     NetworkResult networkResult) {
//   switch (networkResult.networkResultType) {
//     case NetworkResultType.error:
//       return APIResult.failure(AppString.error);
//     case NetworkResultType.noInternet:
//       return APIResult.noInternet();
//     case NetworkResultType.unauthorised:
//       return APIResult.userUnauthorised();
//     case NetworkResultType.notFound:
//       return APIResult.userDeleted();
//     case NetworkResultType.success:
//     default:
//       {
//         if (networkResult.result.isNullOrEmpty()) {
//           return APIResult.failure("", result: networkResult.result);
//         }
//         try {
//           if (networkResult.result != null) {
//             // var baseJson = json.decode(networkResult.result!);
//             // T? responseModel = JsonConvert.fromJsonAsT<T>(baseJson);
//             return APIResult.success(
//               "",
//               networkResult.result.toString(),
//             );
//           } else {
//             return APIResult.success("", null);
//           }
//         } catch (e) {
//           //FirebaseCrashlytics.instance.recordError(e, s);
//           return APIResult.failure(e.toString());
//         }
//       }
//   }
// }

// APIResult<T> getAPIResultFromNetwork<T>(NetworkResult networkResult) {
//   switch (networkResult.networkResultType) {
//     case NetworkResultType.ERROR:
//       final ErrorResponse model =
//       ApiUtil.instance.jsonConverter(ErrorResponse(), networkResult.result.toString());
//       return APIResult.failure(model.message , result: networkResult.result.toString());
//     case NetworkResultType.NO_INTERNET:
//       return APIResult.noInternet();
//     case NetworkResultType.UNAUTHORISED:
//       StartupService.remove();
//       // navigateToPageAndRemoveAllPage(
//       //   GlobalVariable.navigatorKey.currentContext!,
//       //   DEACTIVE_ROUTE,
//       // );
//       /// todo ask
//       return APIResult.sessionExpired();

//     case NetworkResultType.NOTFOUND:
//       StartupService.remove();
//       // navigateToPageAndRemoveAllPage(
//       // GlobalVariable.navigatorKey.currentContext!,
//       // DEACTIVE_ROUTE,
//       // );
//       ///todo ask
//       return APIResult.userUnauthorised();
//     case NetworkResultType.CACHEERROR:
//       return APIResult.failure(AppString.ERROR);
//     case NetworkResultType.TIMEOUT:
//       return APIResult.failure(AppString.requestTimeout);
//     case NetworkResultType.SUCCESS:
//     default:
//       {
//         if (networkResult.result.isNullOrEmpty()) {
//           logger.w("user isNullOrEmpty");
//           return APIResult.failure("");
//         }
//         try {
//           return APIResult.success(null, networkResult.result.toString());
//         } catch (e, s) {
//           logger.w("result failure catch");
//           // FirebaseCrashlytics.instance.recordError(e, s);
//           return APIResult.failure(AppString.ERROR);
//         }
//       }
//   }
// }

// APIResult<T> getAPIResultFromNetworkWithoutBase<T>(
//     NetworkResult networkResult) {
//   switch (networkResult.networkResultType) {
//     case NetworkResultType.ERROR:
//       return APIResult.failure(AppString.ERROR);
//     case NetworkResultType.NO_INTERNET:
//       return APIResult.noInternet();
//     case NetworkResultType.UNAUTHORISED:
//       return APIResult.userUnauthorised();
//     case NetworkResultType.NOTFOUND:
//       return APIResult.userDeleted();
//     case NetworkResultType.SUCCESS:
//     default:
//       {
//         if (networkResult.result.isNullOrEmpty()) {
//           return APIResult.failure("", result: networkResult.result);
//         }
//         try {
//           if (networkResult.result != null) {
//             // var baseJson = json.decode(networkResult.result!);
//             // T? responseModel = JsonConvert.fromJsonAsT<T>(baseJson);
//             return APIResult.success(
//               "",
//               networkResult.result.toString(),
//             );
//           } else {
//             return APIResult.success("", null);
//           }
//         } catch (e, s) {
//           //FirebaseCrashlytics.instance.recordError(e, s);
//           return APIResult.failure(e.toString());
//         }
//       }
//   }
// }
