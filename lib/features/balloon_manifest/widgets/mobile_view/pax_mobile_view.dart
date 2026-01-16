part of '../../balloon_manifest_body.dart';

class PaxMobileView extends StatefulWidget {
  const PaxMobileView({super.key, required this.passengers, required this.assignment});

  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final ModelResponseBalloonManifestAssignments assignment;

  @override
  State<PaxMobileView> createState() => _PaxMobileViewState();
}

class _PaxMobileViewState extends State<PaxMobileView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.passengers.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final passenger = widget.passengers[index];
        return _buildMobilePassengerRow(passenger, index + 1);
      },
    );
  }

  Widget _buildMobilePassengerRow(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,

    int number,
  ) {
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
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    passenger.editedName ?? passenger.name ?? '',
                    style: passengerInfoMobileTextStyle.copyWith(fontSize: 15),
                  ),
                  Text(
                    '${passenger.weight.toString()} KG',
                    style: passengerInfoMobileTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "${AppString.driver.endWithColon()} ${passenger.driverName ?? ''}",
                      style: passengerInfoMobileTextStyle.copyWith(
                        color: ColorConst.textGreyColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "${AppString.pickup.endWithColon()} ${passenger.location?.capitalizeByWord() ?? ''}",
                      style: passengerInfoMobileTextStyle.copyWith(
                        color: ColorConst.textGreyColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}