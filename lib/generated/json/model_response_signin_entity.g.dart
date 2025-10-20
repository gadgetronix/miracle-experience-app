import 'package:miracle_experience_mobile_app/generated/json/base/json_convert_content.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

ModelResponseSigninEntity $ModelResponseSigninEntityFromJson(
    Map<String, dynamic> json) {
  final ModelResponseSigninEntity modelResponseSigninEntity = ModelResponseSigninEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    modelResponseSigninEntity.name = name;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    modelResponseSigninEntity.email = email;
  }
  final int? userRole = jsonConvert.convert<int>(json['userRole']);
  if (userRole != null) {
    modelResponseSigninEntity.userRole = userRole;
  }
  final ModelResponseSigninAccessToken? accessToken = jsonConvert.convert<
      ModelResponseSigninAccessToken>(json['accessToken']);
  if (accessToken != null) {
    modelResponseSigninEntity.accessToken = accessToken;
  }
  return modelResponseSigninEntity;
}

Map<String, dynamic> $ModelResponseSigninEntityToJson(
    ModelResponseSigninEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['email'] = entity.email;
  data['userRole'] = entity.userRole;
  data['accessToken'] = entity.accessToken?.toJson();
  return data;
}

extension ModelResponseSigninEntityExtension on ModelResponseSigninEntity {
  ModelResponseSigninEntity copyWith({
    String? name,
    String? email,
    int? userRole,
    ModelResponseSigninAccessToken? accessToken,
  }) {
    return ModelResponseSigninEntity()
      ..name = name ?? this.name
      ..email = email ?? this.email
      ..userRole = userRole ?? this.userRole
      ..accessToken = accessToken ?? this.accessToken;
  }
}

ModelResponseSigninAccessToken $ModelResponseSigninAccessTokenFromJson(
    Map<String, dynamic> json) {
  final ModelResponseSigninAccessToken modelResponseSigninAccessToken = ModelResponseSigninAccessToken();
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    modelResponseSigninAccessToken.token = token;
  }
  final String? tokenType = jsonConvert.convert<String>(json['tokenType']);
  if (tokenType != null) {
    modelResponseSigninAccessToken.tokenType = tokenType;
  }
  final String? validFrom = jsonConvert.convert<String>(json['validFrom']);
  if (validFrom != null) {
    modelResponseSigninAccessToken.validFrom = validFrom;
  }
  final String? validTo = jsonConvert.convert<String>(json['validTo']);
  if (validTo != null) {
    modelResponseSigninAccessToken.validTo = validTo;
  }
  return modelResponseSigninAccessToken;
}

Map<String, dynamic> $ModelResponseSigninAccessTokenToJson(
    ModelResponseSigninAccessToken entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['token'] = entity.token;
  data['tokenType'] = entity.tokenType;
  data['validFrom'] = entity.validFrom;
  data['validTo'] = entity.validTo;
  return data;
}

extension ModelResponseSigninAccessTokenExtension on ModelResponseSigninAccessToken {
  ModelResponseSigninAccessToken copyWith({
    String? token,
    String? tokenType,
    String? validFrom,
    String? validTo,
  }) {
    return ModelResponseSigninAccessToken()
      ..token = token ?? this.token
      ..tokenType = tokenType ?? this.tokenType
      ..validFrom = validFrom ?? this.validFrom
      ..validTo = validTo ?? this.validTo;
  }
}