part of '../../balloon_manifest_body.dart';

class PaxTabletView extends StatefulWidget {
  const PaxTabletView({
    super.key,
    required this.leftPadding,
    required this.rightPadding,
    required this.passengers,
    required this.assignment,
  });

  final double leftPadding, rightPadding;
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final ModelResponseBalloonManifestAssignments assignment;

  @override
  State<PaxTabletView> createState() => _PaxTabletViewState();
}

class _PaxTabletViewState extends State<PaxTabletView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColumnHeaders(
          leftPadding: widget.leftPadding,
          rightPadding: widget.rightPadding,
        ),
        _buildTabletPassengersList(
          leftPadding: widget.leftPadding,
          rightPadding: widget.rightPadding,
        ),
      ],
    );
  }

  Widget _buildColumnHeaders({
    required double leftPadding,
    required double rightPadding,
  }) {
    return Container(
      padding: EdgeInsets.only(
        right: rightPadding,
        left: leftPadding,
        top: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(color: ColorConst.whiteColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildColumnHeader('#', flex: 1),
          const SizedBox(width: 5),
          _buildColumnHeader(AppString.driverName, flex: 4),
          const SizedBox(width: 5),
          _buildColumnHeader(AppString.fullName, flex: 4),
          const SizedBox(width: 5),
          _buildColumnHeader(AppString.nationality, flex: 3),
          _buildColumnHeader(AppString.mf, flex: 1),
          _buildColumnHeader(AppString.tourOperator, flex: 4),
          const SizedBox(width: 3),
          _buildColumnHeader(AppString.permit, flex: 2),
          const SizedBox(width: 3),
          _buildColumnHeader(AppString.pickupLocation, flex: 4),
          const SizedBox(width: 5),
          _buildColumnHeader(AppString.kg, flex: 1),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(title, style: fontStyleBold10),
    );
  }

  Widget _buildTabletPassengersList({
    required double leftPadding,
    required double rightPadding,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.passengers.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final passenger = widget.passengers[index];
        return _buildTabletPassengerRow(
          passenger,
          index + 1,
          leftPadding: leftPadding,
          rightPadding: rightPadding,
        );
      },
    );
  }

  Widget _buildTabletPassengerRow(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
    int number, {
    required double leftPadding,
    required double rightPadding,
  }) {
    return GestureDetector(
      onTap: () {
        CustomBottomSheet.instance.modalBottomSheet(
          child: PassengerDetailBottomSheet(
            passenger: passenger,
            assignmentId: widget.assignment.id ?? 0,
            onNameUpdated: (editedName) {
              setState(() {
                passenger.editedName = editedName;
              });
            },
          ),
          context: context,
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          right: rightPadding,
          left: leftPadding,
          top: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(color: ColorConst.whiteColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Number
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(number.toString(), style: passengerInfoTextStyle),
                  if (passenger.quadrantPosition != null) ...[
                    const SizedBox(width: 5),
                    Text(
                      passenger.specialRequest.isNotNullAndEmpty()
                          ? passenger.specialRequest![0]
                          : '',
                      style: passengerInfoTextStyle,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 5),

            // Driver Name
            Expanded(
              flex: 4,
              child: Text(
                passenger.driverName ?? 'Unknown',
                style: passengerInfoTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5),
            // Full Name
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passenger.editedName ?? passenger.name ?? 'Unknown',
                    style: passengerInfoTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            // Nationality
            Expanded(
              flex: 3,
              child: Text(
                passenger.country ?? '-',
                style: passengerInfoTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Gender
            Expanded(
              flex: 1,
              child: Text(
                passenger.gender.isNotNullOrEmpty()
                    ? passenger.gender!.toUpperCase()
                    : '-',
                style: passengerInfoTextStyle,
              ),
            ),

            // Tour Operator
            Expanded(
              flex: 4,
              child: Text(
                passenger.bookingBy?.capitalizeByWord() ?? '-',
                style: passengerInfoTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),

            // Permit Code
            Expanded(
              flex: 2,
              child: Text(
                passenger.permitNumber ?? '-',
                style: passengerInfoTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),

            // Pickup Location
            Expanded(
              flex: 4,
              child: Text(
                passenger.location?.capitalizeByWord() ?? '-',
                style: passengerInfoTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5),

            // Weight
            Expanded(
              flex: 1,
              child: Text(
                passenger.weight != null
                    ? passenger.weight!.toStringAsFixed(0)
                    : '-',
                style: passengerInfoTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
