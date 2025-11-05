part of '../passengers_list_widget.dart';

class TabletHeaderWidget extends StatelessWidget {
  const TabletHeaderWidget({
    super.key,
    required this.manifest,
    required this.assignment,
    required this.status,
    required this.helper,
  });

  final ModelResponseBalloonManifestEntity manifest;
  final ModelResponseBalloonManifestAssignments assignment;
  final SignatureStatus status;
  final BalloonManifestHelper helper;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppString.pilot.toUpperCase().endWithColon()} ${assignment.pilotName?.toUpperCase()}',
                style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  HeaderInfoWidget(
                    label: AppString.date.toUpperCase(),
                    value: manifest.manifestDate.orEmpty(),
                  ),
                  const SizedBox(width: 24),
                  HeaderInfoWidget(
                    label: AppString.location.toUpperCase(),
                    value: manifest.location.orEmpty(),
                  ),
                  const SizedBox(width: 24),
                  HeaderInfoWidget(
                    label: AppString.balloon.toUpperCase(),
                    value: assignment.shortCode.orEmpty(),
                  ),
                  const SizedBox(width: 24),
                  HeaderInfoWidget(
                    label: AppString.table.toUpperCase(),
                    value: assignment.tableNumber.toString(),
                  ),
                  const SizedBox(width: 24),
                  HeaderInfoWidget(
                    label: AppString.passengers.toUpperCase(),
                    value: assignment.paxes?.length.toString() ?? '',
                  ),
                ],
              ),
            ],
          ),
        ),
        status == SignatureStatus.pending
            ? GestureDetector(
                onTap: () {
                  SignatureBottomSheet.show(
                    context: context,
                    manifestId: manifest.uniqueId,
                    assignmentId: assignment.id,
                    helper: helper,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConst.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppString.sign,
                    style: fontStyleBold14.copyWith(
                      color: ColorConst.primaryColor,
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Text(
                        AppString.signed,
                        style: fontStyleBold14.copyWith(
                          color: ColorConst.whiteColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.done, color: ColorConst.whiteColor),
                    ],
                  ),
                  SizedBox(height: 4),
                  ValueListenableBuilder<String>(
                    valueListenable: helper.signatureTime,
                    builder: (context, value, child) {
                      return Text(
                        value,
                        style: fontStyleRegular12.copyWith(
                          color: ColorConst.whiteColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
      ],
    );
  }
}
