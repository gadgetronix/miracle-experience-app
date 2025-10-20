import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../../core/basic_features_network.dart';

class AuthRepository {
  static Future<APIResultState<ModelResponseSigninEntity>> callSigninAPI(
    ModelRequestSigninEntity modelRequestSigninEntity,
  ) async {
    var networkResult = await APIHelper.instance.callPostApi(
      NetworkConstant.signin,
      modelRequestSigninEntity,
      false,
    );

    var apiResultFromNetwork =
        getAPIResultFromNetwork<ModelResponseSigninEntity>(networkResult);
    return apiResultFromNetwork;
  }
}
