import 'package:miracle_experience_mobile_app/generated/json/base/json_field.dart';
import 'package:miracle_experience_mobile_app/generated/json/model_response_signin_entity.g.dart';
import 'dart:convert';
export 'package:miracle_experience_mobile_app/generated/json/model_response_signin_entity.g.dart';

@JsonSerializable()
class ModelResponseSigninEntity {
	String? name;
	String? email;
	int? userRole;
	ModelResponseSigninAccessToken? accessToken;

	ModelResponseSigninEntity();

	factory ModelResponseSigninEntity.fromJson(Map<String, dynamic> json) => $ModelResponseSigninEntityFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseSigninEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ModelResponseSigninAccessToken {
	String? token;
	String? tokenType;
	String? validFrom;
	String? validTo;

	ModelResponseSigninAccessToken();

	factory ModelResponseSigninAccessToken.fromJson(Map<String, dynamic> json) => $ModelResponseSigninAccessTokenFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseSigninAccessTokenToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}