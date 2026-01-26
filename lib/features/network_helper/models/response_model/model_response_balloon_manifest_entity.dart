import 'package:miracle_experience_mobile_app/generated/json/base/json_field.dart';
import 'package:miracle_experience_mobile_app/generated/json/model_response_balloon_manifest_entity.g.dart';
import 'dart:convert';
export 'package:miracle_experience_mobile_app/generated/json/model_response_balloon_manifest_entity.g.dart';

@JsonSerializable()
class ModelResponseBalloonManifestEntity {
	String? location;
	String? manifestDate;
	String? uniqueId;
	List<ModelResponseBalloonManifestAssignments>? assignments;

	ModelResponseBalloonManifestEntity();

	factory ModelResponseBalloonManifestEntity.fromJson(Map<String, dynamic> json) => $ModelResponseBalloonManifestEntityFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseBalloonManifestEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ModelResponseBalloonManifestAssignments {
	int? id;
	String? pilotId;
	String? pilotName;
	ModelResponseBalloonManifestSignature? signature;
	int? tableNumber;
	double? maxWeightWithPax;
	double? defaultWeight;
	double? pilotWeight;
	List<int>? knownLanguage;
	String? shortCode;
	int? capacity;
	List<ModelResponseBalloonManifestAssignmentsPaxes>? paxes;

	ModelResponseBalloonManifestAssignments();

	factory ModelResponseBalloonManifestAssignments.fromJson(Map<String, dynamic> json) => $ModelResponseBalloonManifestAssignmentsFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseBalloonManifestAssignmentsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ModelResponseBalloonManifestSignature {
	String? imageName;
	String? imageUrl;
	String? date;

	ModelResponseBalloonManifestSignature();

	factory ModelResponseBalloonManifestSignature.fromJson(Map<String, dynamic> json) => $ModelResponseBalloonManifestSignatureFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseBalloonManifestSignatureToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}


@JsonSerializable()
class ModelResponseBalloonManifestAssignmentsPaxes {
	int? id;
	bool? isFOC;
	String? name;
	String? editedName;
	int? quadrantPosition;
	String? gender;
	int? age;
	int? weight;
	String? country;
	String? dietaryRestriction;
	String? specialRequest;
	String? permitNumber;
	String? bookingBy;
	String? bookingCode;
	String? location;
	String? driverName;
	String? medicalCondition;

	ModelResponseBalloonManifestAssignmentsPaxes();

	factory ModelResponseBalloonManifestAssignmentsPaxes.fromJson(Map<String, dynamic> json) => $ModelResponseBalloonManifestAssignmentsPaxesFromJson(json);

	Map<String, dynamic> toJson() => $ModelResponseBalloonManifestAssignmentsPaxesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}