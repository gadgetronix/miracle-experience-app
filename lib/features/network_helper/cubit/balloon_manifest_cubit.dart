import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/repositories/balloon_manifest_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> callUploadSignatureAPI({
    required String manifestId,
    required int assignmentId,
    required String date,
    required String signatureImageBase64,
    required File signatureFile,
  }) async {
    emit(const LoadingState());

    final APIResultState<BaseResponseModelEntity> apiResultFromNetwork =
        await BalloonManifestRepository.callUploadSignatureAPI(
          manifestId: manifestId,
          assignmentId: assignmentId,
          signatureImageBase64: signatureImageBase64,
          signatureFile: signatureFile,
          date: date,
        );

    final result = apiResultFromNetwork;

    if (result.resultType == APIResultType.noInternet) {
      // 🔥 Store this request locally for retry
      await SharedPrefUtils.setPendingSignatures(
        data: {
          "manifestId": manifestId,
          "assignmentId": assignmentId,
          "date": date,
          "signatureFilePath": signatureFile.path,
          "signatureImageBase64": signatureImageBase64,
        },
        isList: false,
      );
    }
    emit(apiResultFromNetwork);
  }
}

class OfflineSyncCubit extends Cubit<OfflineSyncState> {
  OfflineSyncCubit() : super(OfflineSyncState.idle) {
    _startSyncProcess(); // run at app start
  }

  /// Initialize both: immediate retry + listen for internet restoration
  void _startSyncProcess() {
    //Try immediately on app start (in case pending uploads exist)
    _retryPendingSignatures();

    //Listen for internet restoration
    Connectivity().onConnectivityChanged.listen((results) async {
      timber("Connectivity changed: $results");

      final hasConnection =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (hasConnection) {
        timber("Internet restored, retrying pending signatures...");
        await _retryPendingSignatures();
      }
    });
  }

  /// Reads pending signatures from local storage and uploads them
  Future<void> _retryPendingSignatures() async {
    emit(OfflineSyncState.syncing);

    final pendingList = SharedPrefUtils.getPendingSignatures() ?? [];

    if (pendingList.isEmpty) return;

    for (final item in List<String>.from(pendingList)) {
      try {
        final data = jsonDecode(item);
        final file = File(data['signatureFilePath']);

        if (!file.existsSync()) continue;

        final apiResultFromNetwork =
            await BalloonManifestRepository.callUploadSignatureAPI(
              manifestId: data['manifestId'],
              assignmentId: data['assignmentId'],
              date: data['date'],
              signatureImageBase64: data['signatureImageBase64'],
              signatureFile: file,
            );

        if (apiResultFromNetwork.resultType == APIResultType.success) {
          // Remove successfully uploaded entry
          emit(OfflineSyncState.completed);
          pendingList.remove(item);
        }
      } catch (e) {
        // ignore individual failures, continue
      }
    }

    // Save back remaining failed ones
    await SharedPrefUtils.setPendingSignatures(
      pendingSignatureList: pendingList,
      isList: true,
    );
  }
}
