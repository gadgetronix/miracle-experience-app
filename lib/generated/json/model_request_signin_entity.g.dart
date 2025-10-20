import 'package:miracle_experience_mobile_app/generated/json/base/json_convert_content.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';

ModelRequestSigninEntity $ModelRequestSigninEntityFromJson(
    Map<String, dynamic> json) {
  final ModelRequestSigninEntity modelRequestSigninEntity = ModelRequestSigninEntity();
  final String? deviceToken = jsonConvert.convert<String>(json['deviceToken']);
  if (deviceToken != null) {
    modelRequestSigninEntity.deviceToken = deviceToken;
  }
  final bool? isSignout = jsonConvert.convert<bool>(json['isSignout']);
  if (isSignout != null) {
    modelRequestSigninEntity.isSignout = isSignout;
  }
  final String? appVersion = jsonConvert.convert<String>(json['appVersion']);
  if (appVersion != null) {
    modelRequestSigninEntity.appVersion = appVersion;
  }
  final String? osVersion = jsonConvert.convert<String>(json['osVersion']);
  if (osVersion != null) {
    modelRequestSigninEntity.osVersion = osVersion;
  }
  final String? deviceMf = jsonConvert.convert<String>(json['deviceMf']);
  if (deviceMf != null) {
    modelRequestSigninEntity.deviceMf = deviceMf;
  }
  final String? deviceModel = jsonConvert.convert<String>(json['deviceModel']);
  if (deviceModel != null) {
    modelRequestSigninEntity.deviceModel = deviceModel;
  }
  final String? uId = jsonConvert.convert<String>(json['uId']);
  if (uId != null) {
    modelRequestSigninEntity.uId = uId;
  }
  final int? userRole = jsonConvert.convert<int>(json['userRole']);
  if (userRole != null) {
    modelRequestSigninEntity.userRole = userRole;
  }
  final int? platform = jsonConvert.convert<int>(json['platform']);
  if (platform != null) {
    modelRequestSigninEntity.platform = platform;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    modelRequestSigninEntity.email = email;
  }
  final String? password = jsonConvert.convert<String>(json['password']);
  if (password != null) {
    modelRequestSigninEntity.password = password;
  }
  return modelRequestSigninEntity;
}

Map<String, dynamic> $ModelRequestSigninEntityToJson(
    ModelRequestSigninEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['deviceToken'] = entity.deviceToken;
  data['isSignout'] = entity.isSignout;
  data['appVersion'] = entity.appVersion;
  data['osVersion'] = entity.osVersion;
  data['deviceMf'] = entity.deviceMf;
  data['deviceModel'] = entity.deviceModel;
  data['uId'] = entity.uId;
  data['userRole'] = entity.userRole;
  data['platform'] = entity.platform;
  data['email'] = entity.email;
  data['password'] = entity.password;
  return data;
}

extension ModelRequestSigninEntityExtension on ModelRequestSigninEntity {
  ModelRequestSigninEntity copyWith({
    String? deviceToken,
    bool? isSignout,
    String? appVersion,
    String? osVersion,
    String? deviceMf,
    String? deviceModel,
    String? uId,
    int? userRole,
    int? platform,
    String? email,
    String? password,
  }) {
    return ModelRequestSigninEntity()
      ..deviceToken = deviceToken ?? this.deviceToken
      ..isSignout = isSignout ?? this.isSignout
      ..appVersion = appVersion ?? this.appVersion
      ..osVersion = osVersion ?? this.osVersion
      ..deviceMf = deviceMf ?? this.deviceMf
      ..deviceModel = deviceModel ?? this.deviceModel
      ..uId = uId ?? this.uId
      ..userRole = userRole ?? this.userRole
      ..platform = platform ?? this.platform
      ..email = email ?? this.email
      ..password = password ?? this.password;
  }
}