import 'dart:io';

import 'package:dio/dio.dart';
import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

import '../../../core/basic_features_network.dart';

class BalloonManifestRepository {
  static Future<APIResultState<ModelResponseBalloonManifestEntity>>
  callBalloonManifestAPI() async {
    var networkResult = await APIHelper.instance.performRequestWithRetry(
      apiMethod: () => APIHelper.instance.callGetApi(
        NetworkConstant.balloonManifest,
        null,
        false,
      ),
    );

    var apiResultFromNetwork =
        getAPIResultFromNetwork<ModelResponseBalloonManifestEntity>(
          networkResult,
        );
    return apiResultFromNetwork;
  }

  static Future<APIResultState<BaseResponseModelEntity>>
  callUploadSignatureAPI({
    required int assignmentId,
    required String signedDate,
    required File signatureFile,
  }) async {
    FormData formData = FormData.fromMap({
      "AssignmentId": assignmentId,
      "SignedDate": signedDate,
      "SignatureFile": await MultipartFile.fromFile(
        signatureFile.path,
        filename: signatureFile.path.split("/").last,
      ),
    });

    var networkResult = await APIHelper.instance.performRequestWithRetry(
      apiMethod: () => APIHelper.instance.callPostMultiPartWithFromData(
        NetworkConstant.uploadSignature,
        formData,
        false,
      ),
    );

    var apiResultFromNetwork = getAPIResultFromNetwork<BaseResponseModelEntity>(
      networkResult,
    );
    return apiResultFromNetwork;
  }
}
