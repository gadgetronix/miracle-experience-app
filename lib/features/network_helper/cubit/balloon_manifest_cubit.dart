import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
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

  Future<void> callUploadSignatureAPI({
    required int assignmentId,
    required String signedDate,
    required File signatureFile,
  }) async {
    emit(const LoadingState());

    final APIResultState<BaseResponseModelEntity> apiResultFromNetwork =
        await BalloonManifestRepository.callUploadSignatureAPI(
          assignmentId: assignmentId,
          signatureFile: signatureFile,
          signedDate: signedDate,
        );

    final result = apiResultFromNetwork;

    if (result.resultType == APIResultType.noInternet) {
      // 🔥 Store this request locally for retry
      await SharedPrefUtils.setPendingSignatures(
        data: {
          "assignmentId": assignmentId,
          "SignedDate": signedDate,
          "signatureFilePath": signatureFile.path,
        },
        isList: false,
      );
    }
    emit(apiResultFromNetwork);
  }
}

class UpdatePaxNameCubit
    extends Cubit<APIResultState<BaseResponseModelEntity>?> {
  UpdatePaxNameCubit() : super(null);

  Future<void> callPaxNameUpdateAPI({
    required int id,
    required String name,
    required BuildContext context,
  }) async {
    emit(const LoadingState());

    final APIResultState<BaseResponseModelEntity> apiResultFromNetwork =
        await BalloonManifestRepository.callPaxNameUpdateAPI(
          id: id,
          name: name,
        );

    final result = apiResultFromNetwork;

    if (result.resultType == APIResultType.noInternet) {
      // 🔥 Store this request locally for retry
      await SharedPrefUtils.setPendingManifestPaxNames(
        data: {"id": id, "name": name},
        isList: false,
      );
      context.read<OfflineSyncCubit>().notifyPendingWorkAdded();
    }
    emit(apiResultFromNetwork);
  }
}

class OfflineSyncCubit extends Cubit<OfflineSyncState> {
  StreamSubscription? _connectivitySub;

  OfflineSyncCubit() : super(OfflineSyncState.idle) {
    _startSyncProcess();
  }

  Future<void> _startSyncProcess() async {
    // Try immediately on app start
    await _syncAllPending();

    // Listen for internet restoration
    _connectivitySub = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final hasConnection =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (hasConnection) {
        await _syncAllPending();
      }
    });
  }

  Future<void> _syncAllPending() async {
    emit(OfflineSyncState.syncing);

    await _retryPendingSignatures();
    await _retryPendingNameUpdates();

    _emitPendingOrIdle();
  }

  Future<void> _retryPendingSignatures() async {
    final pendingList = SharedPrefUtils.getPendingSignatures() ?? [];

    if (pendingList.isEmpty) return;

    for (final item in List<String>.from(pendingList)) {
      try {
        final data = jsonDecode(item);
        final file = File(data['signatureFilePath']);

        if (!file.existsSync()) continue;

        final signedDate = data['SignedDate'];

        final apiResult =
            await BalloonManifestRepository.callUploadSignatureAPI(
              assignmentId: data['assignmentId'],
              signedDate: signedDate,
              signatureFile: file,
            );

        if (apiResult.resultType == APIResultType.success) {
          final cacheData = SharedPrefUtils.getBalloonManifest();
          if (cacheData != null && cacheData.assignments.isNotNullAndEmpty) {
            cacheData.assignments!.first.signature =
                ModelResponseBalloonManifestSignature()
                  ..date = signedDate
                  ..imageName = 'success.png';

            SharedPrefUtils.setBalloonManifest(cacheData.toString());
          }

          pendingList.remove(item);
        }
      } catch (_) {
        // ignore and continue
      }
    }

    await SharedPrefUtils.setPendingSignatures(
      pendingSignatureList: pendingList,
      isList: true,
    );
  }

  Future<void> _retryPendingNameUpdates() async {
    final pendingNameList = SharedPrefUtils.getPendingManifestPaxNames() ?? [];

    if (pendingNameList.isEmpty) return;

    for (final item in List<String>.from(pendingNameList)) {
      try {
        final data = jsonDecode(item);

        final apiResult = await BalloonManifestRepository.callPaxNameUpdateAPI(
          id: data['id'],
          name: data['name'],
        );

        if (apiResult.resultType == APIResultType.success) {
          pendingNameList.remove(item);
        }
      } catch (_) {
        // ignore and continue
      }
    }

    await SharedPrefUtils.setPendingManifestPaxNames(
      pendingPaxNameUpdate: pendingNameList,
      isList: true,
    );
  }

  void notifyPendingWorkAdded() {
    emit(OfflineSyncState.pending);
  }

  void _emitPendingOrIdle() {
    final hasPendingSignatures =
        (SharedPrefUtils.getPendingSignatures() ?? []).isNotEmpty;

    final hasPendingNames =
        (SharedPrefUtils.getPendingManifestPaxNames() ?? []).isNotEmpty;

    if (hasPendingSignatures || hasPendingNames) {
      emit(OfflineSyncState.pending);
    } else {
      emit(OfflineSyncState.completed);
      emit(OfflineSyncState.idle); // settles UI
    }
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
