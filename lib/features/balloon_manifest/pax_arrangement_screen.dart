import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

class BalloonArrangeScreen extends StatefulWidget {
  const BalloonArrangeScreen({
    super.key,
    required this.assignments,
    required this.manifest,
  });

  final ModelResponseBalloonManifestAssignments assignments;
  final ModelResponseBalloonManifestEntity manifest;

  @override
  State<BalloonArrangeScreen> createState() => _BalloonArrangeScreenState();
}

class _BalloonArrangeScreenState extends State<BalloonArrangeScreen> {
  final List<ModelResponseBalloonManifestAssignmentsPaxes>
  topLeftCompartmentPax = [];
  final List<ModelResponseBalloonManifestAssignmentsPaxes>
  topRightCompartmentPax = [];
  final List<ModelResponseBalloonManifestAssignmentsPaxes>
  bottomLeftCompartmentPax = [];
  final List<ModelResponseBalloonManifestAssignmentsPaxes>
  bottomRightCompartmentPax = [];
  final ScrollController _scrollController = ScrollController();

  late int capacity;
  late double gridHeight;
  late double _screenHeight;

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  _screenHeight = MediaQuery.of(context).size.height;
}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void setValues() {
    capacity = widget.assignments.capacity != null
        ? ((widget.assignments.capacity)! / 4).toInt()
        : 1;
    for (final pax in widget.assignments.paxes ?? []) {
      switch (pax.quadrantPosition) {
        case 0:
          topLeftCompartmentPax.add(pax);
          break;
        case 1:
          topRightCompartmentPax.add(pax);
          break;
        case 2:
          bottomLeftCompartmentPax.add(pax);
          break;
        case 3:
          bottomRightCompartmentPax.add(pax);
          break;
      }
    }
    gridHeight = compartmentHeight(capacity);
  }

  double compartmentHeight(int passengerCount) {
    const double tileHeight = 48; // PassengerTile approx height
    const double spacing = 4; // tile margin
    const double padding = 14;

    return (padding) + (passengerCount * (tileHeight + spacing));
  }

void _handleAutoScroll(Offset globalPosition) {
  if (!_scrollController.hasClients) return;

  const edgeThreshold = 80.0;
  const scrollSpeed = 8.0; // pixels per frame

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
      create: (_) => BalloonBloc(
        topLeftCompartmentPax: topLeftCompartmentPax,
        topRightCompartmentPax: topRightCompartmentPax,
        bottomLeftCompartmentPax: bottomLeftCompartmentPax,
        bottomRightCompartmentPax: bottomRightCompartmentPax,
        maxCapacity: capacity,
      ),
      child: Scaffold(
        appBar: CustomAppBar.backActionCenterTitleAppBar(
          title: widget.assignments.shortCode ?? AppString.basketView,
          showLeading: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: (){
                              context.read<BalloonBloc>().add(const ResetPassenger());
                    },
                    child: Text(
                      AppString.reset,
                      style: fontStyleRegular14.apply(color: ColorConst.textColor),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<BalloonBloc, BalloonState>(
            buildWhen: (prev, curr) => prev.compartments != curr.compartments,
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff8f9fa),
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff8f9fa),
                              border: Border(
                                top: BorderSide(
                                  width: 0.001,
                                  color: Colors.grey,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('TOP', style: fontStyleRegular14),
                          ),
                          Divider(height: 0),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: gridHeight,
                                ),
                            itemCount: CompartmentType.values.length,
                            itemBuilder: (context, index) {
                              return CompartmentCard(
                                type: CompartmentType.values[index],
                              );
                            },
                          ),
                          Divider(height: 0),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff8f9fa),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.001,
                                  color: Colors.grey,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${state.getLeftWeight().toStringAsFixed(0)} KG', style: fontStyleRegular14),
                                Text('BOTTOM', style: fontStyleRegular14),
                                Text('${state.getRightWeight().toStringAsFixed(0)} KG', style: fontStyleRegular14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ...state.unassigned.map((p) => PassengerTile(passenger: p, onDragUpdate: _handleAutoScroll,)),
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

class CompartmentCard extends StatelessWidget {
  final CompartmentType type;

  const CompartmentCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalloonBloc, BalloonState>(
      builder: (context, state) {
        final passengers = state.compartments[type]!;

        return DragTarget<ModelResponseBalloonManifestAssignmentsPaxes>(
          onAcceptWithDetails: (p) {
            context.read<BalloonBloc>().add(AssignPassenger(p.data, type));
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
                        : 0.0,
                    color:
                        type == CompartmentType.topLeft ||
                            type == CompartmentType.topRight
                        ? Colors.grey
                        : Colors.transparent,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...passengers.map(
                    (p) => PassengerTile(
                      passenger: p,
                      onRemove: () =>
                          context.read<BalloonBloc>().add(RemovePassenger(p)),
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

class PassengerTile extends StatelessWidget {
  final ModelResponseBalloonManifestAssignmentsPaxes passenger;
  final VoidCallback? onRemove;
  final void Function(Offset)? onDragUpdate;

  const PassengerTile({super.key, required this.passenger, this.onRemove, this.onDragUpdate});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<ModelResponseBalloonManifestAssignmentsPaxes>(
      data: passenger,
      onDragUpdate: (details) {
        onDragUpdate?.call(details.globalPosition);
      },
      feedback: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Material(child: _tile(showRemove: false)),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: _tile()),
      child: _tile(),
    );
  }

  Widget _tile({bool showRemove = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.name ?? '-',
                  style: fontStyleRegular12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${passenger.gender}, ${passenger.age}, ${passenger.weight} kg, ${passenger.permitNumber}",
                  style: fontStyleRegular12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onRemove != null && showRemove)
            InkWell(onTap: onRemove, child: const Icon(Icons.close, size: 14)),
        ],
      ),
    );
  }
}

class BalloonBloc extends Bloc<BalloonEvent, BalloonState> {
    final BalloonState _initialState;
  BalloonBloc({
    required int maxCapacity,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    topLeftCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    topRightCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    bottomLeftCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    bottomRightCompartmentPax,
  }) : _initialState = BalloonState.initial(
          maxCapacity: maxCapacity,
          topLeftCompartmentPax: List.from(topLeftCompartmentPax),
          topRightCompartmentPax: List.from(topRightCompartmentPax),
          bottomLeftCompartmentPax: List.from(bottomLeftCompartmentPax),
          bottomRightCompartmentPax: List.from(bottomRightCompartmentPax),
        ),
        super(
         BalloonState.initial(
           maxCapacity: maxCapacity,
           topLeftCompartmentPax: topLeftCompartmentPax,
           topRightCompartmentPax: topRightCompartmentPax,
           bottomLeftCompartmentPax: bottomLeftCompartmentPax,
           bottomRightCompartmentPax: bottomRightCompartmentPax,
         ),
       ) {
    on<AssignPassenger>(_onAssign);
    on<RemovePassenger>(_onRemove);
    on<ResetPassenger>(_onReset);
  }

  void _onReset(ResetPassenger event, Emitter<BalloonState> emit) {
  emit(
    BalloonState(
      maxCapacity: _initialState.maxCapacity,
      unassigned: List.from(_initialState.unassigned),
      compartments: {
        for (final entry in _initialState.compartments.entries)
          entry.key: List.from(entry.value),
      },
    ),
  );
}


  void _onAssign(AssignPassenger event, Emitter<BalloonState> emit) {
    final updatedCompartments =
        Map<
          CompartmentType,
          List<ModelResponseBalloonManifestAssignmentsPaxes>
        >.fromEntries(
          state.compartments.entries.map(
            (e) => MapEntry(
              e.key,
              List<ModelResponseBalloonManifestAssignmentsPaxes>.from(e.value),
            ),
          ),
        );

    if (updatedCompartments[event.compartment]!.length >= state.maxCapacity) {
      return;
    }

    // Remove passenger from everywhere
    for (final list in updatedCompartments.values) {
      list.removeWhere((p) => p.id == event.passenger.id);
    }

    final updatedUnassigned =
        List<ModelResponseBalloonManifestAssignmentsPaxes>.from(
          state.unassigned,
        )..removeWhere((p) => p.id == event.passenger.id);

    updatedCompartments[event.compartment]!.add(event.passenger);

    emit(
      BalloonState(
        unassigned: updatedUnassigned,
        compartments: updatedCompartments,
        maxCapacity: state.maxCapacity,
      ),
    );
  }

  void _onRemove(RemovePassenger event, Emitter<BalloonState> emit) {
    final updatedCompartments =
        Map<
          CompartmentType,
          List<ModelResponseBalloonManifestAssignmentsPaxes>
        >.fromEntries(
          state.compartments.entries.map(
            (e) => MapEntry(
              e.key,
              List<ModelResponseBalloonManifestAssignmentsPaxes>.from(e.value),
            ),
          ),
        );

    for (final list in updatedCompartments.values) {
      list.removeWhere((p) => p.id == event.passenger.id);
    }

    final updatedUnassigned =
        List<ModelResponseBalloonManifestAssignmentsPaxes>.from(
          state.unassigned,
        )..add(event.passenger);

    emit(
      BalloonState(
        unassigned: updatedUnassigned,
        compartments: updatedCompartments,
        maxCapacity: state.maxCapacity,
      ),
    );
  }
}

class BalloonState extends Equatable {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> unassigned;
  final Map<CompartmentType, List<ModelResponseBalloonManifestAssignmentsPaxes>>
  compartments;
  final int maxCapacity;

  const BalloonState({
    required this.maxCapacity,
    required this.unassigned,
    required this.compartments,
  });

  factory BalloonState.initial({
    required int maxCapacity,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    topLeftCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    topRightCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    bottomLeftCompartmentPax,
    required List<ModelResponseBalloonManifestAssignmentsPaxes>
    bottomRightCompartmentPax,
  }) {
    return BalloonState(
      maxCapacity: maxCapacity,
      unassigned: [],
      compartments: {
        CompartmentType.topLeft: topLeftCompartmentPax,
        CompartmentType.topRight: topRightCompartmentPax,
        CompartmentType.bottomLeft: bottomLeftCompartmentPax,
        CompartmentType.bottomRight: bottomRightCompartmentPax,
      },
    );
  }

  double getLeftWeight() {
  final leftPax = [
    ...compartments[CompartmentType.topLeft]!,
    ...compartments[CompartmentType.bottomLeft]!
  ];
  return leftPax.fold(0.0, (sum, p) => sum + (p.weight ?? 0));
}

double getRightWeight() {
  final rightPax = [
    ...compartments[CompartmentType.topRight]!,
    ...compartments[CompartmentType.bottomRight]!
  ];
  return rightPax.fold(0.0, (sum, p) => sum + (p.weight ?? 0));
}

  @override
  List<Object?> get props => [unassigned, compartments, maxCapacity];
}

abstract class BalloonEvent extends Equatable {
  const BalloonEvent();

  @override
  List<Object?> get props => [];
}

class ResetPassenger extends BalloonEvent {
  const ResetPassenger();
}

class AssignPassenger extends BalloonEvent {
  final ModelResponseBalloonManifestAssignmentsPaxes passenger;
  final CompartmentType compartment;

  const AssignPassenger(this.passenger, this.compartment);
}

class RemovePassenger extends BalloonEvent {
  final ModelResponseBalloonManifestAssignmentsPaxes passenger;
  const RemovePassenger(this.passenger);
}

enum CompartmentType { topLeft, topRight, bottomLeft, bottomRight }
