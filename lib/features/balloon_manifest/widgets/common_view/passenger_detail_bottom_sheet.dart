part of '../../balloon_manifest_body.dart';

class PassengerDetailBottomSheet extends StatefulWidget {
  final ModelResponseBalloonManifestAssignmentsPaxes passenger;
  final Function(String editedName) onNameUpdated;
  final int assignmentId;

  const  PassengerDetailBottomSheet({
    super.key,
    required this.passenger,
    required this.onNameUpdated,
    required this.assignmentId,
  });

  @override
  State<PassengerDetailBottomSheet> createState() =>
      _PassengerDetailBottomSheetState();
}

class _PassengerDetailBottomSheetState
    extends State<PassengerDetailBottomSheet> {
  late final TextEditingController _nameController;
  final ValueNotifier<bool> _isEditingEnabled = ValueNotifier(false);
  final UpdatePaxNameCubit updatePaxNameCubit = UpdatePaxNameCubit();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text:
          widget.passenger.editedName ??
          widget.passenger.name ??
          'Unknown Passenger',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _isEditingEnabled.dispose();
    super.dispose();
  }

  void _onSave() {
    final editedName = _nameController.text.trim();
    if (editedName.isEmpty) return;
    final ModelResponseBalloonManifestEntity? cacheData =
        SharedPrefUtils.getBalloonManifest();
    cacheData?.assignments!
            .firstWhere((assignment) => assignment.id == widget.assignmentId)
            .paxes!
            .firstWhere((pax) => pax.id == widget.passenger.id)
            .editedName =
        editedName;
          SharedPrefUtils.setBalloonManifest(cacheData.toString());
    updatePaxNameCubit.callPaxNameUpdateAPI(
      id: widget.passenger.id!,
      name: editedName, 
    );
    widget.onNameUpdated(editedName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isEditingEnabled,
            builder: (_, editingEnabled, __) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      readOnly: !editingEnabled,
                      autofocus: true,
                      style: fontStyleBold18,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (editingEnabled) {
                        _onSave();
                      } else {
                        _isEditingEnabled.value = true;
                      }
                    },
                    child: Text(
                      editingEnabled ? AppString.save : AppString.edit,
                      style: passengerInfoMobileTextStyle.copyWith(
                        color: ColorConst.textGreyColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            Divider(height: 20, color: Colors.grey.shade300),
                _buildDetailRow(AppString.driver, widget.passenger.driverName ?? '-'),
              _buildDetailRow(
                AppString.nationality,
                widget.passenger.country ?? '-',
              ),
              _buildDetailRow(AppString.mf, widget.passenger.gender ?? '-'),
              _buildDetailRow(
                AppString.tourOperator,
                widget.passenger.bookingBy?.capitalizeByWord() ?? '-',
              ),
              _buildDetailRow(
                AppString.permit,
                widget.passenger.permitNumber ?? '-',
              ),
              _buildDetailRow(
                AppString.pickupLocation,
                widget.passenger.location?.capitalizeByWord() ?? '-',
              ),
              _buildDetailRow(
                AppString.kg,
                widget.passenger.weight != null
                    ? '${widget.passenger.weight!.toStringAsFixed(0)} KG'
                    : '-',
              ),
              if (widget.passenger.specialRequest.isNotNullAndEmpty()) ...[
                _buildDetailRow(
                  AppString.specialRequest,
                  widget.passenger.specialRequest ?? '-',
                ),  
              ],
                      ],
                    ),
            ),
          ),]
    ));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text("$label:", style: passengerInfoMobileTextStyle),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: passengerInfoMobileTextStyle),
          ),
        ],
      ),
    );
  }
}
