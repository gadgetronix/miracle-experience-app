// balloon_basket_model.dart
import 'package:equatable/equatable.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import '../../../../core/basic_features.dart';

class BalloonBasketModel extends Equatable {
  final Map<CompartmentType, List<ModelResponseBalloonManifestAssignmentsPaxes>>
  compartments;
  final List<ModelResponseBalloonManifestAssignmentsPaxes> unassigned;
  final int maxCapacity;

  const BalloonBasketModel({
    required this.compartments,
    required this.unassigned,
    required this.maxCapacity,
  });

  BalloonBasketModel copyWith({
    Map<CompartmentType, List<ModelResponseBalloonManifestAssignmentsPaxes>>?
    compartments,
    List<ModelResponseBalloonManifestAssignmentsPaxes>? unassigned,
    int? maxCapacity,
  }) {
    return BalloonBasketModel(
      compartments: compartments ?? this.compartments,
      unassigned: unassigned ?? this.unassigned,
      maxCapacity: maxCapacity ?? this.maxCapacity,
    );
  }

  double getLeftWeight() {
    final leftPax = [
      ...compartments[CompartmentType.topLeft]!,
      ...compartments[CompartmentType.bottomLeft]!,
    ];
    return leftPax.fold(0.0, (sum, p) => sum + (p.weight ?? 0));
  }

  double getRightWeight() {
    final rightPax = [
      ...compartments[CompartmentType.topRight]!,
      ...compartments[CompartmentType.bottomRight]!,
    ];
    return rightPax.fold(0.0, (sum, p) => sum + (p.weight ?? 0));
  }

  @override
  List<Object?> get props => [compartments, unassigned, maxCapacity];
}
