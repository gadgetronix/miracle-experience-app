import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

import '../../../core/basic_features_network.dart';

class BalloonManifestRepository {
  static Future<APIResultState<ModelResponseBalloonManifestEntity>>
  callBalloonManifestAPI() async {
    var networkResult = await APIHelper.instance.callGetApi(
      NetworkConstant.balloonManifest,
      null,
      false,
    );

    var apiResultFromNetwork =
        getAPIResultFromNetwork<ModelResponseBalloonManifestEntity>(
          networkResult,
        );
    return apiResultFromNetwork;
  }
}
