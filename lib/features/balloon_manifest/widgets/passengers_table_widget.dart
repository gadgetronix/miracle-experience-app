import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

class PassengersListWidget extends StatelessWidget {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final String pilotName;
  final String balloonCode;
  final int tableNumber;
  final String location;
  final String date;
  final double otherWeights;

  const PassengersListWidget({
    super.key,
    required this.passengers,
    required this.pilotName,
    required this.balloonCode,
    required this.tableNumber,
    required this.location,
    required this.date,
    required this.otherWeights,
  });

  @override
  Widget build(BuildContext context) {
    if (passengers.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet view for width > 600px, Mobile view otherwise
        final isTablet = constraints.maxWidth > 600;
        return Column(
          children: [
            _buildHeader(isTablet),
            const Divider(height: 1, thickness: 1),
            if (isTablet) ...[
              _buildColumnHeaders(),
              _buildTabletPassengersList(),
            ],
            Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),

            _buildFooter(),
          ],
        );
        // return Card(
        //   color: ColorConst.whiteColor,
        //   elevation: 2,
        //   margin: const EdgeInsets.symmetric(vertical: 12),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       _buildHeader(isTablet),
        //       const Divider(height: 1, thickness: 1),
        //       if (isTablet) ...[
        //         _buildColumnHeaders(),
        //         _buildTabletPassengersList(),
        //       ] else ...[
        //         _buildMobilePassengersList(),
        //       ],
        //       Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),

        //       _buildFooter(),
        //     ],
        //   ),
        // );
      },
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 25 : 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(color: ColorConst.primaryColor),
      child: isTablet ? _buildTabletHeader() : _buildMobileHeader(),
    );
  }

  Widget _buildTabletHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppString.pilot.toUpperCase().endWithColon()} ${pilotName.toUpperCase()}',
                style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildHeaderInfo(AppString.date.toUpperCase(), date),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(AppString.location.toUpperCase(), location),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.balloon.toUpperCase(),
                    balloonCode,
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.table.toUpperCase(),
                    tableNumber.toString(),
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    AppString.passengers.toUpperCase(),
                    passengers.length.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: ColorConst.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(AppString.sign, style: fontStyleBold14),
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                pilotName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${passengers.length} PAX',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildHeaderInfo('BALLOON', balloonCode),
            const SizedBox(width: 20),
            _buildHeaderInfo('TABLE', tableNumber.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: fontStyleRegular10.copyWith(color: Colors.white70)),
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
      itemCount: passengers.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final passenger = passengers[index];
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
      itemCount: passengers.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final passenger = passengers[index];
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
    final totalWeight = passengers.fold<double>(
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
                '${AppString.takeOffWeight.endWithColon()} ${(otherWeights + totalWeight).toStringAsFixed(0)}',
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
}
