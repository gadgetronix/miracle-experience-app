import 'package:miracle_experience_mobile_app/generated/json/base/json_field.dart';
import 'package:miracle_experience_mobile_app/generated/json/model_request_signin_entity.g.dart';
import 'dart:convert';
export 'package:miracle_experience_mobile_app/generated/json/model_request_signin_entity.g.dart';

@JsonSerializable()
class ModelRequestSigninEntity {
	String? deviceToken;
	bool? isSignout;
	String? appVersion;
	String? osVersion;
	String? deviceMf;
	String? deviceModel;
	String? uId;
	int? userRole;
	int? platform;
	String? email;
	String? password;

	ModelRequestSigninEntity();

	factory ModelRequestSigninEntity.fromJson(Map<String, dynamic> json) => $ModelRequestSigninEntityFromJson(json);

	Map<String, dynamic> toJson() => $ModelRequestSigninEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}