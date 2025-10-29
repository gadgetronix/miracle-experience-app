import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/balloon_manifest_screen.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

part 'mobile_view/mobile_header_widget.dart';
part 'tablet_view/tablet_header_widget.dart';
part 'header_info_widget.dart';

class PassengersListWidget extends StatefulWidget {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final BalloonManifestHelper helper;
  final ModelResponseBalloonManifestEntity manifest;
  final ModelResponseBalloonManifestAssignments assignment;

  const PassengersListWidget({
    super.key,
    required this.passengers,
    required this.helper,
    required this.manifest,
    required this.assignment,
  });

  @override
  State<PassengersListWidget> createState() => _PassengersListWidgetState();
}

class _PassengersListWidgetState extends State<PassengersListWidget> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.passengers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.helper.loadManifestData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  const Divider(height: 1, thickness: 1),
                  if (Const.isTablet) ...[
                    _buildColumnHeaders(),
                    _buildTabletPassengersList(),
                  ] else ...[
                    _buildMobilePassengersList(),
                  ],
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade300,
                  ),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
        if (!Const.isTablet)
          MobileViewSignWidget(
            helper: widget.helper,
            manifestId: widget.manifest.uniqueId,
            assignmentId: widget.assignment.id,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return BlocListener<OfflineSyncCubit, OfflineSyncState>(
      listener: (context, state) {
        if (state == OfflineSyncState.completed) {
          widget.helper.signatureStatus.value = SignatureStatus.success;
          final cacheData = SharedPrefUtils.getBalloonManifest();
          if (cacheData != null &&
              cacheData.assignments.isNotNullAndEmpty &&
              cacheData.assignments!.first.signature != null) {
            widget.helper.signatureTime.value = Const.convertDateTimeToDMYHM(
              cacheData.assignments!.first.signature!.date!,
            );
          }
        }
      },
      child: ValueListenableBuilder<SignatureStatus>(
        valueListenable: widget.helper.signatureStatus,
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Const.isTablet ? 25 : 16,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: value == SignatureStatus.success
                  ? ColorConst.successColor
                  : ColorConst.primaryColor,
            ),
            child: Const.isTablet
                ? TabletHeaderWidget(
                    status: value,
                    manifest: widget.manifest,
                    assignment: widget.assignment,
                    helper: widget.helper,
                  )
                : MobileHeaderWidget(
                    manifest: widget.manifest,
                    assignment: widget.assignment,
                  ),
          );
        },
      ),
    );
  }

  // ========== TABLET VIEW ==========
  Widget _buildColumnHeaders() {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 25, top: 12, bottom: 12),
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
          const SizedBox(width: 5),
          _buildColumnHeader(AppString.permit, flex: 2),
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

  Widget _buildTabletPassengersList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.passengers.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final passenger = widget.passengers[index];
        return _buildTabletPassengerRow(passenger, index + 1);
      },
    );
  }

  Widget _buildTabletPassengerRow(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
    int number,
  ) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 25, top: 12, bottom: 12),
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
                  passenger.name ?? 'Unknown',
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
          const SizedBox(width: 5),

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
    );
  }

  // ========== MOBILE VIEW ==========
  Widget _buildMobilePassengersList() {
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
          child: _buildPassengerDetailBottomSheet(passenger),
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
                    passenger.name ?? '',
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

  Widget _buildPassengerDetailBottomSheet(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                passenger.name ?? 'Unknown Passenger',
                style: fontStyleBold18,
              ),
            ),
            Divider(thickness: 1, height: 20, color: Colors.grey.shade300),

            // Details List
            _buildDetailRow(AppString.driver, passenger.driverName ?? '-'),
            _buildDetailRow(AppString.nationality, passenger.country ?? '-'),
            _buildDetailRow(AppString.mf, passenger.gender ?? '-'),
            _buildDetailRow(
              AppString.tourOperator,
              passenger.bookingBy?.capitalizeByWord() ?? '-',
            ),
            _buildDetailRow(AppString.permit, passenger.permitNumber ?? '-'),
            _buildDetailRow(
              AppString.pickupLocation,
              passenger.location?.capitalizeByWord() ?? '-',
            ),
            _buildDetailRow(
              AppString.kg,
              passenger.weight != null
                  ? '${passenger.weight!.toStringAsFixed(0)} KG'
                  : '-',
            ),
            if (passenger.specialRequest.isNotNullAndEmpty()) ...[
              _buildDetailRow(
                AppString.specialRequest,
                passenger.specialRequest ?? '-',
              ),
            ],
          ],
        ),
      ),
    );
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

  // ========== SHARED WIDGETS ==========

  Widget _buildFooter() {
    final totalWeight = widget.passengers.fold<double>(
      0.0,
      (sum, pax) => sum + ((pax.weight ?? 0).toDouble()),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: Const.isTablet ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: ColorConst.whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppString.takeOffWeight.endWithColon()} ${((widget.assignment.pilotWeight ?? 0) + (widget.assignment.defaultWeight ?? 0) + totalWeight).toStringAsFixed(0)}',
                style: Const.isTablet
                    ? passengerInfoTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : passengerInfoMobileTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              ),
              Text(
                '${AppString.total.endWithColon()} ${totalWeight.toStringAsFixed(0)} KG',
                style: Const.isTablet
                    ? passengerInfoTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : passengerInfoMobileTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No Passengers Assigned',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
