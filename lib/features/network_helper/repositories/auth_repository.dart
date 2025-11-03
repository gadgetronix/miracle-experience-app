import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../../core/basic_features_network.dart';

class AuthRepository {
  static Future<APIResultState<ModelResponseSigninEntity>> callSigninAPI(
    ModelRequestSigninEntity modelRequestSigninEntity,
  ) async {
    var networkResult = await APIHelper.instance.performRequestWithRetry(
      apiMethod: () => APIHelper.instance.callPostApi(
        NetworkConstant.signin,
        modelRequestSigninEntity,
        false,
      ),
    );

    var apiResultFromNetwork =
        getAPIResultFromNetwork<ModelResponseSigninEntity>(networkResult);
    return apiResultFromNetwork;
  }

  static Future<APIResultState<BaseResponseModelEntity>> callSignoutAPI(
    ModelRequestSigninEntity modelRequestSigninEntity,
  ) async {
    var networkResult = await APIHelper.instance.performRequestWithRetry(
      apiMethod: () => APIHelper.instance.callPostApi(
        NetworkConstant.signOut,
        modelRequestSigninEntity,
        false,
      ),
    );

    var apiResultFromNetwork = getAPIResultFromNetwork<BaseResponseModelEntity>(
      networkResult,
    );
    return apiResultFromNetwork;
  }
}
