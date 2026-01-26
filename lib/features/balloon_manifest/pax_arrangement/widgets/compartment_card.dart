import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/pax_arangement_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/balloon_basket_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

import '../../../../core/basic_features.dart';
import 'passenger_tile.dart';

class CompartmentCard extends StatelessWidget {
  final CompartmentType type;

  const CompartmentCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaxArrangementCubit, BalloonBasketModel>(
      builder: (context, state) {
        final passengers = state.compartments[type]!;

        return DragTarget<ModelResponseBalloonManifestAssignmentsPaxes>(
          onAcceptWithDetails: (details) {
            context.read<PaxArrangementCubit>().assignPassenger(
              details.data,
              type,
            );
          },
          builder: (_, __, ___) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width:
                        type == CompartmentType.topLeft ||
                            type == CompartmentType.topRight
                        ? 0.5
                        : 0,
                    color: Colors.grey,
                  ),
                  right: BorderSide(
                    width:
                        type == CompartmentType.topLeft ||
                            type == CompartmentType.bottomLeft
                        ? 0.5
                        : 0,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...passengers.map(
                    (p) => PassengerTile(
                      passenger: p,
                      onRemove: () {
                        context.read<PaxArrangementCubit>().removePassenger(p);
                      },
                      isAssigned: true,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
