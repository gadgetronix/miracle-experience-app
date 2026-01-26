// pax_arrangement_repository.dart
import 'dart:convert';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/balloon_basket_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/offline_pax_arrangement_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/pax_arrangement_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

class PaxArrangementRepository {
  /// Restore saved arrangement from SharedPref
  BalloonBasketModel restore({
    required int assignmentId,
    required BalloonBasketModel apiState,
  }) {
    final saved = SharedPrefUtils.getBalloonPassengerArrangement(
      key: 'balloon_arrangement_$assignmentId',
    );

    if (saved == null) return apiState;

    final assignedList = saved.assigned;
    final savedUnassignedIds = saved.unassigned;

    // Build lookup map for all passengers from apiState
    final allPax = [
      ...apiState.unassigned,
      ...apiState.compartments.values.expand((e) => e),
    ];
    final paxById = {for (final p in allPax) p.id: p};

    // Start with empty compartments
    final compartments = {
      for (final t in CompartmentType.values)
        t: <ModelResponseBalloonManifestAssignmentsPaxes>[],
    };

    // Start unassigned with all API unassigned
    final unassigned = <ModelResponseBalloonManifestAssignmentsPaxes>[];

    // Add assigned passengers
    for (final item in assignedList) {
      final paxId = item?.passengerId;
      final quadrant = item?.quadrantPosition;

      final pax = paxById[paxId];
      if (pax != null && quadrant != null && quadrant >= 0 && quadrant <= 3) {
        compartments[CompartmentType.values[quadrant]]!.add(
          pax.copyWith(quadrantPosition: quadrant),
        );
      }
    }

    // Add unassigned passengers
    for (final id in savedUnassignedIds) {
      final pax = paxById[id];
      if (pax != null) unassigned.add(pax);
    }

    final returning = apiState.copyWith(
      compartments: compartments,
      unassigned: unassigned,
    );
    return returning;
  }

  /// Save arrangement locally
  Future<void> save(int assignmentId, BalloonBasketModel state) async {
    final data = OfflinePaxArrangementModel(
      assigned: [],
      unassigned: state.unassigned.map((p) => p.id).toList(),
    );

    state.compartments.forEach((type, paxList) {
      for (final p in paxList) {
        data.assigned.add(
          PaxArrangementModel(passengerId: p.id!, quadrantPosition: type.index),
        );
      }
    });

    await SharedPrefUtils.setBalloonPassengerArrangement(
      key: 'balloon_arrangement_$assignmentId',
      value: jsonEncode(data.toJson()),
    );
  }

  /// Clear saved arrangement
  void clear(int assignmentId) async {
    SharedPrefUtils.removeBalloonPassengerArrangement(
      key: 'balloon_arrangement_$assignmentId',
    );
  }
}
