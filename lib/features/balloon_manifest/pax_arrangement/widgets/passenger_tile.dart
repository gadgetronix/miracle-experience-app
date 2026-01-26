import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

import '../../../../core/basic_features.dart';

class PassengerTile extends StatelessWidget {
  final ModelResponseBalloonManifestAssignmentsPaxes passenger;
  final VoidCallback? onRemove;
  final void Function(Offset)? onDragUpdate;
  final bool isAssigned;

  const PassengerTile({
    super.key,
    required this.passenger,
    this.onRemove,
    this.onDragUpdate,
    this.isAssigned = false,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<ModelResponseBalloonManifestAssignmentsPaxes>(
      data: passenger,
      onDragUpdate: (d) => onDragUpdate?.call(d.globalPosition),
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
                  isAssigned
                      ? "${passenger.bookingCode ?? ''}, ${passenger.gender ?? ''} ${passenger.age ?? ''}, ${passenger.weight ?? ''} kg"
                      : "${passenger.bookingCode ?? ''}, ${passenger.gender ?? ''} ${passenger.age ?? ''}, ${passenger.weight ?? ''} kg, ${passenger.permitNumber ?? ''}",
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
