import 'dart:io';

import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/repositories/balloon_manifest_repository.dart';

import '../../../core/basic_features_network.dart';

class BalloonManifestCubit
    extends Cubit<APIResultState<ModelResponseBalloonManifestEntity>?> {
  BalloonManifestCubit() : super(null);

  Future<void> callBalloonManifestAPI() async {
    emit(const LoadingState());

    final APIResultState<ModelResponseBalloonManifestEntity>
    apiResultFromNetwork =
        await BalloonManifestRepository.callBalloonManifestAPI();

    emit(apiResultFromNetwork);
  }
}

class UploadSignatureCubit
    extends Cubit<APIResultState<BaseResponseModelEntity>?> {
  UploadSignatureCubit() : super(null);

  Future<void> callUploadSignatureAPI({required String manifestId,
    required int assignmentId,
    required String date,
    required String signatureImageBase64,
    required File signatureFile,}) async {
    emit(const LoadingState());

    final APIResultState<BaseResponseModelEntity>
    apiResultFromNetwork =
        await BalloonManifestRepository.callUploadSignatureAPI(
          manifestId: manifestId,
          assignmentId: assignmentId,
          signatureImageBase64: signatureImageBase64,
          signatureFile: signatureFile,
          date: date
        );

    emit(apiResultFromNetwork);
  }
}
