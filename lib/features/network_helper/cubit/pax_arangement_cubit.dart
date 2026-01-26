// pax_arrangement_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miracle_experience_mobile_app/core/utils/logger_util.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/balloon_basket_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/repositories/pax_arrangement_repository.dart';
import 'package:miracle_experience_mobile_app/core/utils/enum.dart';

class PaxArrangementCubit extends Cubit<BalloonBasketModel> {
  final int assignmentId;
  final PaxArrangementRepository repository;
  final BalloonBasketModel _apiState;

  PaxArrangementCubit({
    required this.assignmentId,
    required this.repository,
    required BalloonBasketModel apiState,
    required BalloonBasketModel initialState,
  }) : _apiState = apiState,
       super(initialState);

  void update(BalloonBasketModel newState) {
    emit(newState);
    repository.save(assignmentId, newState);
  }

  Future<void> assignPassenger(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
    CompartmentType compartment,
  ) async {
    final updatedCompartments = _cloneCompartments();
    final updatedUnassigned =
        List<ModelResponseBalloonManifestAssignmentsPaxes>.from(
          state.unassigned,
        );

    if (updatedCompartments[compartment]!.length >= state.maxCapacity) return;

    // Remove from all compartments
    for (final list in updatedCompartments.values) {
      list.removeWhere((p) => p.id == passenger.id);
    }

    // Remove from unassigned
    updatedUnassigned.removeWhere((p) => p.id == passenger.id);

    // Add to target compartment
    updatedCompartments[compartment]!.add(passenger);

    final nextState = state.copyWith(
      compartments: updatedCompartments,
      unassigned: updatedUnassigned,
    );

    emit(nextState);
    await repository.save(assignmentId, nextState);
  }

  Future<void> removePassenger(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
  ) async {
    final updatedCompartments = _cloneCompartments();
    final updatedUnassigned =
        List<ModelResponseBalloonManifestAssignmentsPaxes>.from(
          state.unassigned,
        );

    for (final list in updatedCompartments.values) {
      list.removeWhere((p) => p.id == passenger.id);
    }

    if (!updatedUnassigned.any((p) => p.id == passenger.id)) {
      updatedUnassigned.add(passenger);
    }

    final nextState = state.copyWith(
      compartments: updatedCompartments,
      unassigned: updatedUnassigned,
    );

    emit(nextState);
    await repository.save(assignmentId, nextState);
  }

  void reset() {
    repository.clear(assignmentId);
    emit(_apiState);
  }

  Map<CompartmentType, List<ModelResponseBalloonManifestAssignmentsPaxes>>
  _cloneCompartments() {
    return {
      for (final e in state.compartments.entries) e.key: List.from(e.value),
    };
  }

  /// Factory constructor to create from API assignment

  factory PaxArrangementCubit.fromApi({
    required ModelResponseBalloonManifestAssignments assignments,
  }) {
    final capacityPerCompartment =
        assignments.capacity != null && assignments.capacity! > 0
        ? (assignments.capacity! / 4).ceil()
        : 1;

    final compartments = {
      CompartmentType.topLeft: <ModelResponseBalloonManifestAssignmentsPaxes>[],
      CompartmentType.topRight:
          <ModelResponseBalloonManifestAssignmentsPaxes>[],
      CompartmentType.bottomLeft:
          <ModelResponseBalloonManifestAssignmentsPaxes>[],
      CompartmentType.bottomRight:
          <ModelResponseBalloonManifestAssignmentsPaxes>[],
    };

    final unassigned = <ModelResponseBalloonManifestAssignmentsPaxes>[];

    for (final pax in assignments.paxes ?? []) {
      final q = pax.quadrantPosition;
      timber('${pax.name}: ${pax.quadrantPosition}');
      if (q != null && q >= 0 && q <= 3) {
        compartments[CompartmentType.values[q]]!.add(pax);
      } else {
        unassigned.add(pax);
      }
    }

    final apiState = BalloonBasketModel(
      compartments: compartments,
      unassigned: unassigned,
      maxCapacity: capacityPerCompartment,
    );

    final repository = PaxArrangementRepository();

    // 🔑 restore happens HERE
    final restoredState = repository.restore(
      assignmentId: assignments.id ?? 0,
      apiState: apiState,
    );

    return PaxArrangementCubit(
      assignmentId: assignments.id ?? 0,
      repository: repository,
      apiState: apiState, // immutable baseline
      initialState: restoredState, // api OR local
    );
  }
}
