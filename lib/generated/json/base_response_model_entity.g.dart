import 'package:miracle_experience_mobile_app/generated/json/base/json_convert_content.dart';
import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';

BaseResponseModelEntity $BaseResponseModelEntityFromJson(
    Map<String, dynamic> json) {
  final BaseResponseModelEntity baseResponseModelEntity = BaseResponseModelEntity();
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    baseResponseModelEntity.message = message;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    baseResponseModelEntity.status = status;
  }
  final dynamic result = json['result'];
  if (result != null) {
    baseResponseModelEntity.result = result;
  }
  return baseResponseModelEntity;
}

Map<String, dynamic> $BaseResponseModelEntityToJson(
    BaseResponseModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['message'] = entity.message;
  data['status'] = entity.status;
  data['result'] = entity.result;
  return data;
}

extension BaseResponseModelEntityExtension on BaseResponseModelEntity {
  BaseResponseModelEntity copyWith({
    String? message,
    int? status,
    dynamic result,
  }) {
    return BaseResponseModelEntity()
      ..message = message ?? this.message
      ..status = status ?? this.status
      ..result = result ?? this.result;
  }
}