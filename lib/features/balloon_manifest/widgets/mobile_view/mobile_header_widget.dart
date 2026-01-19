part of '../../balloon_manifest_body.dart';

class MobileHeaderWidget extends StatelessWidget {
  const MobileHeaderWidget({
    super.key,
    required this.manifest,
    required this.assignment,
  });

  final ModelResponseBalloonManifestEntity manifest;
  final ModelResponseBalloonManifestAssignments assignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppString.pilot.capitalizeByWord().endWithColon()} ${assignment.pilotName?.capitalizeByWord()}',
          style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
        ),
        const SizedBox(height: 8),

        // First Row: Date & Location
        Row(
          children: [
            Expanded(
              child: HeaderInfoWidget(
                label: AppString.date.toUpperCase(),
                value: manifest.manifestDate.orEmpty(),
              ),
            ),
            Expanded(
              child: HeaderInfoWidget(
                label: AppString.location.toUpperCase(),
                value: manifest.location.orEmpty(),
              ),
            ),

            Expanded(
              child: HeaderInfoWidget(
                label: AppString.balloon.toUpperCase(),
                value: assignment.shortCode.orEmpty(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: HeaderInfoWidget(
                label: AppString.table.toUpperCase(),
                value: assignment.tableNumber.toString(),
              ),
            ),
            Expanded(
              child: HeaderInfoWidget(
                label: AppString.passengers.toUpperCase(),
                value: assignment.paxes?.length.toString() ?? '',
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
