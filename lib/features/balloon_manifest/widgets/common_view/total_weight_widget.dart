part of '../../balloon_manifest_body.dart';

class TotalWeightWidget extends StatelessWidget {
  const TotalWeightWidget({super.key, required this.passengers});
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: Const.isTablet || Const.isLandscape ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: ColorConst.whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '${AppString.total.endWithColon()} ${passengers.fold<double>(0.0, (sum, pax) => sum + ((pax.weight ?? 0).toDouble())).toStringAsFixed(0)} KG',
          style: Const.isTablet || Const.isLandscape
              ? passengerInfoTextStyle.copyWith(fontWeight: FontWeight.bold)
              : passengerInfoMobileTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
      ),
    );
  }
}
