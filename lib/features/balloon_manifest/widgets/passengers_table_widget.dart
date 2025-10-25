import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/base_response_model_entity.dart';

class PassengersListWidget extends StatefulWidget {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final String manifestId;
  final int assignmentId;
  final String pilotName;
  final String balloonCode;
  final int tableNumber;
  final String location;
  final String date;
  final double otherWeights;
  final String? signature;

  const PassengersListWidget({
    super.key,
    required this.passengers,
    required this.pilotName,
    required this.balloonCode,
    required this.tableNumber,
    required this.location,
    required this.date,
    required this.otherWeights,
    required this.manifestId,
    required this.assignmentId,
    this.signature,
  });

  @override
  State<PassengersListWidget> createState() => _PassengersListWidgetState();
}

class _PassengersListWidgetState extends State<PassengersListWidget> {
  late ValueNotifier<SignatureStatus> signatureStatus;

  final ValueNotifier<String> signatureTime = ValueNotifier<String>('');

  @override
  initState() {
    super.initState();
    signatureStatus = ValueNotifier<SignatureStatus>(
      widget.signature.isNotNullAndEmpty()
          ? SignatureStatus.success
          : SharedPrefUtils.getPendingSignatures().isNotNullAndEmpty &&
                SharedPrefUtils.getPendingSignatures()!.any((element) {
                  final data = jsonDecode(element);
                  return data['manifestId'] == widget.manifestId &&
                      data['assignmentId'] == widget.assignmentId;
                })
          ? SignatureStatus.pending
          : SignatureStatus.offlinePending,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.passengers.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, thickness: 1),
            if (Const.isTablet) ...[
              _buildColumnHeaders(),
              _buildTabletPassengersList(),
            ],
            Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),

            _buildFooter(),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return BlocListener<OfflineSyncCubit, OfflineSyncState>(
      listener: (context, state) {
        if (state == OfflineSyncState.completed) {
          signatureStatus.value = SignatureStatus.success;
          signatureTime.value = Const.convertDateTimeToDMYHM(DateTime.now());
        }
      },
      child: ValueListenableBuilder<SignatureStatus>(
        valueListenable: signatureStatus,
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
                ? _buildTabletHeader(status: value)
                : _buildMobileHeader(status: value),
          );
        },
      ),
    );
  }

  Widget _buildTabletHeader({SignatureStatus? status}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppString.pilot.toUpperCase().endWithColon()} ${widget.pilotName.toUpperCase()}',
                style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildHeaderInfo(AppString.date.toUpperCase(), widget.date),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.location.toUpperCase(),
                    widget.location,
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.balloon.toUpperCase(),
                    widget.balloonCode,
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.table.toUpperCase(),
                    widget.tableNumber.toString(),
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.passengers.toUpperCase(),
                    widget.passengers.length.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
        status == SignatureStatus.pending
            ? GestureDetector(
                onTap: () {
                  _buildSignatureSheet(
                    manifestId: widget.manifestId,
                    assignmentId: widget.assignmentId,
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
                    valueListenable: signatureTime,
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

  Widget _buildMobileHeader({SignatureStatus? status}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppString.pilot.toUpperCase().endWithColon()} ${widget.pilotName.toUpperCase()}',
          style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
        ),
        const SizedBox(height: 8),

        // First Row: Date & Location
        Row(
          children: [
            Expanded(
              child: _buildHeaderInfo(
                AppString.date.toUpperCase(),
                widget.date,
              ),
            ),
            Expanded(
              child: _buildHeaderInfo(
                AppString.location.toUpperCase(),
                widget.location,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildHeaderInfo(
                AppString.balloon.toUpperCase(),
                widget.balloonCode,
              ),
            ),
            Expanded(
              child: _buildHeaderInfo(
                AppString.table.toUpperCase(),
                widget.tableNumber.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildHeaderInfo(
                AppString.passengers.toUpperCase(),
                widget.passengers.length.toString(),
              ),
            ),
            status == SignatureStatus.pending
                ? GestureDetector(
                    onTap: () {
                      _buildSignatureSheet(
                        manifestId: widget.manifestId,
                        assignmentId: widget.assignmentId,
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
                : Expanded(
                    child: Column(
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
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.done,
                              color: ColorConst.whiteColor,
                            ),
                            const SizedBox(width: 5),
                            ValueListenableBuilder<String>(
                              valueListenable: signatureTime,
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
                        SizedBox(height: 4),
                        ValueListenableBuilder<String>(
                          valueListenable: signatureTime,
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
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyleRegular10.copyWith(color: ColorConst.whiteColor),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: fontStyleBold14.copyWith(color: ColorConst.whiteColor),
        ),
      ],
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
          Expanded(flex: 1, child: _buildGenderBadge(passenger.gender)),

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.passengers.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final passenger = widget.passengers[index];
        return _buildMobilePassengerCard(passenger, index + 1);
      },
    );
  }

  Widget _buildMobilePassengerCard(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
    int number,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with number and name
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (passenger.isFOC == true) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FREE OF CHARGE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (passenger.quadrantPosition != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      passenger.specialRequest.isNotNullAndEmpty()
                          ? passenger.specialRequest![0]
                          : '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Details grid
            _buildMobileDetailRow(
              Icons.flag,
              'Nationality',
              passenger.country ?? '-',
              Colors.blue,
            ),
            const SizedBox(height: 10),

            _buildMobileDetailRow(
              passenger.gender?.toUpperCase() == 'M'
                  ? Icons.male
                  : Icons.female,
              'Gender',
              passenger.gender?.toUpperCase() ?? '-',
              passenger.gender?.toUpperCase() == 'M'
                  ? Colors.blue
                  : Colors.pink,
            ),
            const SizedBox(height: 10),

            _buildMobileDetailRow(
              Icons.business,
              'Tour Operator',
              passenger.bookingBy ?? '-',
              Colors.orange,
            ),
            const SizedBox(height: 10),

            _buildMobileDetailRow(
              Icons.confirmation_number,
              'Permit Code',
              passenger.permitNumber ?? '-',
              Colors.teal,
            ),
            const SizedBox(height: 10),

            _buildMobileDetailRow(
              Icons.location_on,
              'Pickup Location',
              passenger.location ?? '-',
              Colors.red,
            ),
            const SizedBox(height: 10),

            _buildMobileDetailRow(
              Icons.monitor_weight,
              'Weight',
              passenger.weight != null
                  ? '${passenger.weight!.toStringAsFixed(0)} KG'
                  : '-',
              Colors.grey,
            ),

            // Driver info if available
            if (passenger.driverName != null &&
                passenger.driverName!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildMobileDetailRow(
                Icons.person_pin_circle,
                'Driver',
                passenger.driverName!,
                Colors.purple,
              ),
            ],

            // Special notes
            if (_hasSpecialNotes(passenger)) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildSpecialNotes(passenger),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasSpecialNotes(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
  ) {
    return (passenger.dietaryRestriction != null &&
            passenger.dietaryRestriction!.isNotEmpty) ||
        (passenger.medicalCondition != null &&
            passenger.medicalCondition!.isNotEmpty) ||
        (passenger.specialRequest != null &&
            passenger.specialRequest!.isNotEmpty);
  }

  Widget _buildSpecialNotes(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
            const SizedBox(width: 6),
            Text(
              'Special Notes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (passenger.dietaryRestriction != null &&
            passenger.dietaryRestriction!.isNotEmpty)
          _buildNoteBadge(
            'Dietary',
            passenger.dietaryRestriction!,
            Colors.orange,
          ),
        if (passenger.medicalCondition != null &&
            passenger.medicalCondition!.isNotEmpty)
          _buildNoteBadge('Medical', passenger.medicalCondition!, Colors.red),
        if (passenger.specialRequest != null &&
            passenger.specialRequest!.isNotEmpty)
          _buildNoteBadge('Request', passenger.specialRequest!, Colors.purple),
      ],
    );
  }

  Widget _buildNoteBadge(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 11, color: color)),
          ),
        ],
      ),
    );
  }

  // ========== SHARED WIDGETS ==========
  Widget _buildGenderBadge(String? gender) {
    if (gender == null || gender.isEmpty) {
      return Text('-', style: passengerInfoTextStyle);
    }
    return Text(gender.toUpperCase(), style: passengerInfoTextStyle);
  }

  Widget _buildFooter() {
    final totalWeight = widget.passengers.fold<double>(
      0.0,
      (sum, pax) => sum + ((pax.weight ?? 0).toDouble()),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
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
                '${AppString.takeOffWeight.endWithColon()} ${(widget.otherWeights + totalWeight).toStringAsFixed(0)}',
                style: passengerInfoTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${AppString.total.endWithColon()}: ${totalWeight.toStringAsFixed(0)} KG',
                style: passengerInfoTextStyle.copyWith(
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

  _buildSignatureSheet({String? manifestId, int? assignmentId}) {
    final UploadSignatureCubit uploadSignatureCubit = UploadSignatureCubit();
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    return CustomBottomSheet.instance.modalBottomSheet(
      context: GlobalVariable.appContext,
      bottomButtonName: AppString.submit,
      child: BlocProvider.value(
        value: uploadSignatureCubit,
        child:
            BlocListener<
              UploadSignatureCubit,
              APIResultState<BaseResponseModelEntity>?
            >(
              listener: (context, state) {
                if (state?.resultType == APIResultType.loading) {
                  EasyLoading.show();
                } else if (state?.resultType == APIResultType.success) {
                  signatureTime.value = Const.convertDateTimeToDMYHM(
                    DateTime.now(),
                  );
                  signatureStatus.value = SignatureStatus.success;
                  EasyLoading.dismiss();
                  Navigator.pop(context); // Close bottom sheet
                } else if (state?.resultType == APIResultType.noInternet) {
                  signatureTime.value = Const.convertDateTimeToDMYHM(
                    DateTime.now(),
                  );
                  signatureStatus.value = SignatureStatus.offlinePending;
                  Navigator.pop(context); // Close bottom sheet
                  EasyLoading.dismiss();
                } else if (state?.resultType == APIResultType.failure) {
                  EasyLoading.dismiss();
                  showErrorSnackBar(
                    context,
                    state?.message ?? 'Something went wrong. Please try again.',
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Signature(
                    controller: controller,
                    height: 300,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ),
      ),
      onBottomPressed: () async {
        if (controller.isNotEmpty) {
          // Convert the signature to image bytes
          final signatureBytes = await controller.toPngBytes();

          if (signatureBytes != null) {
            // Save the bytes temporarily as a file
            final tempDir = await getTemporaryDirectory();
            final filePath = '${tempDir.path}/signature.png';
            final signatureFile = File(filePath);
            await signatureFile.writeAsBytes(signatureBytes);
            final signatureImageBase64 = base64Encode(signatureBytes);

            // Now call the upload API
            await uploadSignatureCubit.callUploadSignatureAPI(
              manifestId: manifestId ?? '0',
              assignmentId: assignmentId ?? 0,
              date: DateTime.now().toIso8601String(),
              signatureImageBase64: signatureImageBase64,
              signatureFile: signatureFile,
            );
          }
        } else {
          EasyLoading.showToast("Please add your signature before submitting.");
        }
      },
    );
  }
}
