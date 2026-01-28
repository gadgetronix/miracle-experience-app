import 'package:miracle_experience_mobile_app/core/basic_features.dart';

class OfflineSyncResponseModel {
  
  final SignatureStatus? signatureStatus;
  final OfflineSyncState offlineSyncState;

  OfflineSyncResponseModel({
    this.signatureStatus,
    required this.offlineSyncState
  });

  Map<String, dynamic> toJson() => {
    'signatureStatus': signatureStatus,
    'offlineSyncState': offlineSyncState,
  };

  factory OfflineSyncResponseModel.fromJson(Map<String, dynamic> json) {
    return OfflineSyncResponseModel(
      signatureStatus: json['signatureStatus'],
      offlineSyncState: json['offlineSyncState'],
    );
  }
}
