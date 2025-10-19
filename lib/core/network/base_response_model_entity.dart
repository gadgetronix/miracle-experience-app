import 'package:miracle_experience_mobile_app/generated/json/base/json_field.dart';
import 'package:miracle_experience_mobile_app/generated/json/base_response_model_entity.g.dart';
import 'dart:convert';
export 'package:miracle_experience_mobile_app/generated/json/base_response_model_entity.g.dart';

@JsonSerializable()
class BaseResponseModelEntity {
	String? message;
	int? status;
	dynamic result;

	BaseResponseModelEntity();

	factory BaseResponseModelEntity.fromJson(Map<String, dynamic> json) => $BaseResponseModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $BaseResponseModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}