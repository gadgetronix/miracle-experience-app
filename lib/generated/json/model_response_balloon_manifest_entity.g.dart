import 'package:miracle_experience_mobile_app/generated/json/base/json_convert_content.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

ModelResponseBalloonManifestEntity $ModelResponseBalloonManifestEntityFromJson(
    Map<String, dynamic> json) {
  final ModelResponseBalloonManifestEntity modelResponseBalloonManifestEntity = ModelResponseBalloonManifestEntity();
  final String? location = jsonConvert.convert<String>(json['location']);
  if (location != null) {
    modelResponseBalloonManifestEntity.location = location;
  }
  final String? manifestDate = jsonConvert.convert<String>(
      json['manifestDate']);
  if (manifestDate != null) {
    modelResponseBalloonManifestEntity.manifestDate = manifestDate;
  }
  final String? uniqueId = jsonConvert.convert<String>(json['uniqueId']);
  if (uniqueId != null) {
    modelResponseBalloonManifestEntity.uniqueId = uniqueId;
  }
  final List<
      ModelResponseBalloonManifestAssignments>? assignments = (json['assignments'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<ModelResponseBalloonManifestAssignments>(
          e) as ModelResponseBalloonManifestAssignments).toList();
  if (assignments != null) {
    modelResponseBalloonManifestEntity.assignments = assignments;
  }
  return modelResponseBalloonManifestEntity;
}

Map<String, dynamic> $ModelResponseBalloonManifestEntityToJson(
    ModelResponseBalloonManifestEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['location'] = entity.location;
  data['manifestDate'] = entity.manifestDate;
  data['uniqueId'] = entity.uniqueId;
  data['assignments'] = entity.assignments?.map((v) => v.toJson()).toList();
  return data;
}

extension ModelResponseBalloonManifestEntityExtension on ModelResponseBalloonManifestEntity {
  ModelResponseBalloonManifestEntity copyWith({
    String? location,
    String? manifestDate,
    String? uniqueId,
    List<ModelResponseBalloonManifestAssignments>? assignments,
  }) {
    return ModelResponseBalloonManifestEntity()
      ..location = location ?? this.location
      ..manifestDate = manifestDate ?? this.manifestDate
      ..uniqueId = uniqueId ?? this.uniqueId
      ..assignments = assignments ?? this.assignments;
  }
}

ModelResponseBalloonManifestAssignments $ModelResponseBalloonManifestAssignmentsFromJson(
    Map<String, dynamic> json) {
  final ModelResponseBalloonManifestAssignments modelResponseBalloonManifestAssignments = ModelResponseBalloonManifestAssignments();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    modelResponseBalloonManifestAssignments.id = id;
  }
  final String? pilotId = jsonConvert.convert<String>(json['pilotId']);
  if (pilotId != null) {
    modelResponseBalloonManifestAssignments.pilotId = pilotId;
  }
  final String? pilotName = jsonConvert.convert<String>(json['pilotName']);
  if (pilotName != null) {
    modelResponseBalloonManifestAssignments.pilotName = pilotName;
  }
  final ModelResponseBalloonManifestSignature? signature = jsonConvert.convert<
      ModelResponseBalloonManifestSignature>(json['signature']);
  if (signature != null) {
    modelResponseBalloonManifestAssignments.signature = signature;
  }
  final int? tableNumber = jsonConvert.convert<int>(json['tableNumber']);
  if (tableNumber != null) {
    modelResponseBalloonManifestAssignments.tableNumber = tableNumber;
  }
  final double? maxWeightWithPax = jsonConvert.convert<double>(
      json['maxWeightWithPax']);
  if (maxWeightWithPax != null) {
    modelResponseBalloonManifestAssignments.maxWeightWithPax = maxWeightWithPax;
  }
  final double? defaultWeight = jsonConvert.convert<double>(
      json['defaultWeight']);
  if (defaultWeight != null) {
    modelResponseBalloonManifestAssignments.defaultWeight = defaultWeight;
  }
  final double? pilotWeight = jsonConvert.convert<double>(json['pilotWeight']);
  if (pilotWeight != null) {
    modelResponseBalloonManifestAssignments.pilotWeight = pilotWeight;
  }
  final List<int>? knownLanguage = (json['knownLanguage'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<int>(e) as int)
      .toList();
  if (knownLanguage != null) {
    modelResponseBalloonManifestAssignments.knownLanguage = knownLanguage;
  }
  final String? shortCode = jsonConvert.convert<String>(json['shortCode']);
  if (shortCode != null) {
    modelResponseBalloonManifestAssignments.shortCode = shortCode;
  }
  final int? capacity = jsonConvert.convert<int>(json['capacity']);
  if (capacity != null) {
    modelResponseBalloonManifestAssignments.capacity = capacity;
  }
  final List<
      ModelResponseBalloonManifestAssignmentsPaxes>? paxes = (json['paxes'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<
          ModelResponseBalloonManifestAssignmentsPaxes>(
          e) as ModelResponseBalloonManifestAssignmentsPaxes).toList();
  if (paxes != null) {
    modelResponseBalloonManifestAssignments.paxes = paxes;
  }
  return modelResponseBalloonManifestAssignments;
}

Map<String, dynamic> $ModelResponseBalloonManifestAssignmentsToJson(
    ModelResponseBalloonManifestAssignments entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['pilotId'] = entity.pilotId;
  data['pilotName'] = entity.pilotName;
  data['signature'] = entity.signature?.toJson();
  data['tableNumber'] = entity.tableNumber;
  data['maxWeightWithPax'] = entity.maxWeightWithPax;
  data['defaultWeight'] = entity.defaultWeight;
  data['pilotWeight'] = entity.pilotWeight;
  data['knownLanguage'] = entity.knownLanguage;
  data['shortCode'] = entity.shortCode;
  data['capacity'] = entity.capacity;
  data['paxes'] = entity.paxes?.map((v) => v.toJson()).toList();
  return data;
}

extension ModelResponseBalloonManifestAssignmentsExtension on ModelResponseBalloonManifestAssignments {
  ModelResponseBalloonManifestAssignments copyWith({
    int? id,
    String? pilotId,
    String? pilotName,
    ModelResponseBalloonManifestSignature? signature,
    int? tableNumber,
    double? maxWeightWithPax,
    double? defaultWeight,
    double? pilotWeight,
    List<int>? knownLanguage,
    String? shortCode,
    int? capacity,
    List<ModelResponseBalloonManifestAssignmentsPaxes>? paxes,
  }) {
    return ModelResponseBalloonManifestAssignments()
      ..id = id ?? this.id
      ..pilotId = pilotId ?? this.pilotId
      ..pilotName = pilotName ?? this.pilotName
      ..signature = signature ?? this.signature
      ..tableNumber = tableNumber ?? this.tableNumber
      ..maxWeightWithPax = maxWeightWithPax ?? this.maxWeightWithPax
      ..defaultWeight = defaultWeight ?? this.defaultWeight
      ..pilotWeight = pilotWeight ?? this.pilotWeight
      ..knownLanguage = knownLanguage ?? this.knownLanguage
      ..shortCode = shortCode ?? this.shortCode
      ..capacity = capacity ?? this.capacity
      ..paxes = paxes ?? this.paxes;
  }
}

ModelResponseBalloonManifestSignature $ModelResponseBalloonManifestSignatureFromJson(
    Map<String, dynamic> json) {
  final ModelResponseBalloonManifestSignature modelResponseBalloonManifestSignature = ModelResponseBalloonManifestSignature();
  final String? imageName = jsonConvert.convert<String>(json['imageName']);
  if (imageName != null) {
    modelResponseBalloonManifestSignature.imageName = imageName;
  }
  final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
  if (imageUrl != null) {
    modelResponseBalloonManifestSignature.imageUrl = imageUrl;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    modelResponseBalloonManifestSignature.date = date;
  }
  return modelResponseBalloonManifestSignature;
}

Map<String, dynamic> $ModelResponseBalloonManifestSignatureToJson(
    ModelResponseBalloonManifestSignature entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['imageName'] = entity.imageName;
  data['imageUrl'] = entity.imageUrl;
  data['date'] = entity.date;
  return data;
}

extension ModelResponseBalloonManifestSignatureExtension on ModelResponseBalloonManifestSignature {
  ModelResponseBalloonManifestSignature copyWith({
    String? imageName,
    String? imageUrl,
    String? date,
  }) {
    return ModelResponseBalloonManifestSignature()
      ..imageName = imageName ?? this.imageName
      ..imageUrl = imageUrl ?? this.imageUrl
      ..date = date ?? this.date;
  }
}

ModelResponseBalloonManifestAssignmentsPaxes $ModelResponseBalloonManifestAssignmentsPaxesFromJson(
    Map<String, dynamic> json) {
  final ModelResponseBalloonManifestAssignmentsPaxes modelResponseBalloonManifestAssignmentsPaxes = ModelResponseBalloonManifestAssignmentsPaxes();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    modelResponseBalloonManifestAssignmentsPaxes.id = id;
  }
  final bool? isFOC = jsonConvert.convert<bool>(json['isFOC']);
  if (isFOC != null) {
    modelResponseBalloonManifestAssignmentsPaxes.isFOC = isFOC;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    modelResponseBalloonManifestAssignmentsPaxes.name = name;
  }
  final String? editedName = jsonConvert.convert<String>(json['editedName']);
  if (editedName != null) {
    modelResponseBalloonManifestAssignmentsPaxes.editedName = editedName;
  }
  final int? quadrantPosition = jsonConvert.convert<int>(
      json['quadrantPosition']);
  if (quadrantPosition != null) {
    modelResponseBalloonManifestAssignmentsPaxes.quadrantPosition =
        quadrantPosition;
  }
  final String? gender = jsonConvert.convert<String>(json['gender']);
  if (gender != null) {
    modelResponseBalloonManifestAssignmentsPaxes.gender = gender;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    modelResponseBalloonManifestAssignmentsPaxes.age = age;
  }
  final int? weight = jsonConvert.convert<int>(json['weight']);
  if (weight != null) {
    modelResponseBalloonManifestAssignmentsPaxes.weight = weight;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    modelResponseBalloonManifestAssignmentsPaxes.country = country;
  }
  final String? dietaryRestriction = jsonConvert.convert<String>(
      json['dietaryRestriction']);
  if (dietaryRestriction != null) {
    modelResponseBalloonManifestAssignmentsPaxes.dietaryRestriction =
        dietaryRestriction;
  }
  final String? specialRequest = jsonConvert.convert<String>(
      json['specialRequest']);
  if (specialRequest != null) {
    modelResponseBalloonManifestAssignmentsPaxes.specialRequest =
        specialRequest;
  }
  final String? permitNumber = jsonConvert.convert<String>(
      json['permitNumber']);
  if (permitNumber != null) {
    modelResponseBalloonManifestAssignmentsPaxes.permitNumber = permitNumber;
  }
  final String? bookingBy = jsonConvert.convert<String>(json['bookingBy']);
  if (bookingBy != null) {
    modelResponseBalloonManifestAssignmentsPaxes.bookingBy = bookingBy;
  }
  final String? location = jsonConvert.convert<String>(json['location']);
  if (location != null) {
    modelResponseBalloonManifestAssignmentsPaxes.location = location;
  }
  final String? driverName = jsonConvert.convert<String>(json['driverName']);
  if (driverName != null) {
    modelResponseBalloonManifestAssignmentsPaxes.driverName = driverName;
  }
  final String? medicalCondition = jsonConvert.convert<String>(
      json['medicalCondition']);
  if (medicalCondition != null) {
    modelResponseBalloonManifestAssignmentsPaxes.medicalCondition =
        medicalCondition;
  }
  return modelResponseBalloonManifestAssignmentsPaxes;
}

Map<String, dynamic> $ModelResponseBalloonManifestAssignmentsPaxesToJson(
    ModelResponseBalloonManifestAssignmentsPaxes entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['isFOC'] = entity.isFOC;
  data['name'] = entity.name;
  data['editedName'] = entity.editedName;
  data['quadrantPosition'] = entity.quadrantPosition;
  data['gender'] = entity.gender;
  data['age'] = entity.age;
  data['weight'] = entity.weight;
  data['country'] = entity.country;
  data['dietaryRestriction'] = entity.dietaryRestriction;
  data['specialRequest'] = entity.specialRequest;
  data['permitNumber'] = entity.permitNumber;
  data['bookingBy'] = entity.bookingBy;
  data['location'] = entity.location;
  data['driverName'] = entity.driverName;
  data['medicalCondition'] = entity.medicalCondition;
  return data;
}

extension ModelResponseBalloonManifestAssignmentsPaxesExtension on ModelResponseBalloonManifestAssignmentsPaxes {
  ModelResponseBalloonManifestAssignmentsPaxes copyWith({
    int? id,
    bool? isFOC,
    String? name,
    String? editedName,
    int? quadrantPosition,
    String? gender,
    int? age,
    int? weight,
    String? country,
    String? dietaryRestriction,
    String? specialRequest,
    String? permitNumber,
    String? bookingBy,
    String? location,
    String? driverName,
    String? medicalCondition,
  }) {
    return ModelResponseBalloonManifestAssignmentsPaxes()
      ..id = id ?? this.id
      ..isFOC = isFOC ?? this.isFOC
      ..name = name ?? this.name
      ..editedName = editedName ?? this.editedName
      ..quadrantPosition = quadrantPosition ?? this.quadrantPosition
      ..gender = gender ?? this.gender
      ..age = age ?? this.age
      ..weight = weight ?? this.weight
      ..country = country ?? this.country
      ..dietaryRestriction = dietaryRestriction ?? this.dietaryRestriction
      ..specialRequest = specialRequest ?? this.specialRequest
      ..permitNumber = permitNumber ?? this.permitNumber
      ..bookingBy = bookingBy ?? this.bookingBy
      ..location = location ?? this.location
      ..driverName = driverName ?? this.driverName
      ..medicalCondition = medicalCondition ?? this.medicalCondition;
  }
}