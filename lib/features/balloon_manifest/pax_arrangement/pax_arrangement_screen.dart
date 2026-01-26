import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/pax_arangement_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/balloon_basket_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

import '../../../core/basic_features.dart';
import 'widgets/balloon_grid.dart';
import 'widgets/passenger_tile.dart';

class PaxArrangementScreen extends StatefulWidget {
  final ModelResponseBalloonManifestAssignments assignments;

  const PaxArrangementScreen({super.key, required this.assignments});

  @override
  State<PaxArrangementScreen> createState() => _PaxArrangementScreenState();
}

class _PaxArrangementScreenState extends State<PaxArrangementScreen> {
  final ScrollController _scrollController = ScrollController();
  late double _screenHeight;
  late double gridHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;

    final capacity = widget.assignments.capacity != null
        ? ((widget.assignments.capacity)! / 4).toInt()
        : 1;

    gridHeight = _compartmentHeight(capacity);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _compartmentHeight(int passengerCount) {
    const tileHeight = 45.0;
    const spacing = 4.0;
    const padding = 14.0;
    return padding + (passengerCount * (tileHeight + spacing));
  }

  void _handleAutoScroll(Offset globalPosition) {
    if (!_scrollController.hasClients) return;

    const edgeThreshold = 80.0;
    const scrollSpeed = 8.0;

    final dy = globalPosition.dy;
    final currentOffset = _scrollController.offset;
    final maxOffset = _scrollController.position.maxScrollExtent;

    if (dy < edgeThreshold && currentOffset > 0) {
      _scrollController.jumpTo(
        (currentOffset - scrollSpeed).clamp(0.0, maxOffset),
      );
    } else if (dy > _screenHeight - edgeThreshold &&
        currentOffset < maxOffset) {
      _scrollController.jumpTo(
        (currentOffset + scrollSpeed).clamp(0.0, maxOffset),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PaxArrangementCubit.fromApi(assignments: widget.assignments),
      child: Scaffold(
        appBar: CustomAppBar.backActionCenterTitleAppBar(
          title: widget.assignments.shortCode ?? AppString.basketView,
          showLeading: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      context.read<PaxArrangementCubit>().reset();
                    },
                    child: Text(
                      AppString.reset,
                      style: fontStyleRegular14.apply(
                        color: ColorConst.textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<PaxArrangementCubit, BalloonBasketModel>(
            builder: (context, state) {
              final sortedUnassigned = [...state.unassigned]
                ..sort(
                  (a, b) =>
                      (a.bookingCode ?? '').compareTo(b.bookingCode ?? ''),
                );

              // 2️⃣ Group by bookingCode
              final Map<
                String,
                List<ModelResponseBalloonManifestAssignmentsPaxes>
              >
              grouped = {};

              for (final p in sortedUnassigned) {
                final key = p.bookingCode ?? 'Unknown';
                grouped.putIfAbsent(key, () => []).add(p);
              }
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    BalloonGrid(gridHeight: gridHeight),
                    const SizedBox(height: 8),
                    // ...state.unassigned.map(
                    //   (p) => PassengerTile(
                    //     passenger: p,
                    //     onDragUpdate: _handleAutoScroll,
                    //   ),
                    // ),
                    ...grouped.entries.expand((entry) {
                      return [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     vertical: 8,
                        //     horizontal: 4,
                        //   ),
                        //   child: Text(
                        //     entry.key,
                        //     style: const TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        ...entry.value.map(
                          (p) => PassengerTile(
                            passenger: p,
                            onDragUpdate: _handleAutoScroll,
                          ),
                        ),
                      ];
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
