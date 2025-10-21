import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

/// Beautiful, scrollable passenger table
/// Features:
/// - Horizontal and vertical scrolling
/// - Color-coded rows
/// - Responsive design
/// - Touch-friendly on mobile
class PassengersTableWidget extends StatelessWidget {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final String pilotName;
  final String balloonCode;

  const PassengersTableWidget({
    super.key,
    required this.passengers,
    required this.pilotName,
    required this.balloonCode,
  });

  @override
  Widget build(BuildContext context) {
    if (passengers.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), const Divider(height: 1), _buildTable()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.teal.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passengers (${passengers.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilot: $pilotName • Balloon: $balloonCode',
                  style: TextStyle(fontSize: 12, color: Colors.teal.shade700),
                ),
              ],
            ),
          ),
          _buildPassengerStats(),
        ],
      ),
    );
  }

  Widget _buildPassengerStats() {
    final totalWeight = passengers.fold<double>(
      0,
      (sum, pax) => sum + (pax.weight ?? 0),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          Text(
            '${totalWeight.toStringAsFixed(0)} kg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),
          Text(
            'Total',
            style: TextStyle(fontSize: 10, color: Colors.teal.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 48,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 80,
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
            columnSpacing: 24,
            horizontalMargin: 16,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildColumn('#', 50),
      _buildColumn('Name', 180),
      _buildColumn('Age', 60),
      _buildColumn('Gender', 80),
      _buildColumn('Weight', 80),
      _buildColumn('Position', 80),
      _buildColumn('Country', 150),
      _buildColumn('Location', 180),
      _buildColumn('Booking By', 180),
      _buildColumn('Driver', 140),
      _buildColumn('Permit', 120),
      _buildColumn('Dietary', 140),
      _buildColumn('Medical', 140),
      _buildColumn('Special Request', 180),
    ];
  }

  DataColumn _buildColumn(String label, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  List<DataRow> _buildRows() {
    return passengers.asMap().entries.map((entry) {
      final index = entry.key;
      final passenger = entry.value;
      final isEven = index % 2 == 0;

      return DataRow(
        color: MaterialStateProperty.all(
          isEven ? Colors.white : Colors.grey.shade50,
        ),
        cells: [
          _buildCell(_buildIndexCell(index + 1)),
          _buildCell(_buildNameCell(passenger)),
          _buildCell(_buildAgeCell(passenger.age)),
          _buildCell(_buildGenderCell(passenger.gender)),
          _buildCell(_buildWeightCell(passenger.weight)),
          _buildCell(_buildPositionCell(passenger.quadrantPosition)),
          _buildCell(
            _buildTextWithIcon(
              passenger.country ?? '-',
              Icons.flag,
              Colors.blue.shade700,
            ),
          ),
          _buildCell(
            _buildTextWithIcon(
              passenger.location ?? '-',
              Icons.location_on,
              Colors.red.shade700,
            ),
          ),
          _buildCell(
            Text(
              passenger.bookingBy ?? '-',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildCell(
            Text(
              passenger.driverName ?? '-',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildCell(_buildPermitCell(passenger.permitNumber)),
          _buildCell(
            _buildBadgeCell(passenger.dietaryRestriction, Colors.orange),
          ),
          _buildCell(_buildBadgeCell(passenger.medicalCondition, Colors.red)),
          _buildCell(_buildBadgeCell(passenger.specialRequest, Colors.purple)),
        ],
      );
    }).toList();
  }

  DataCell _buildCell(Widget child) {
    return DataCell(child);
  }

  Widget _buildIndexCell(int index) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.teal.shade700,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildNameCell(
    ModelResponseBalloonManifestAssignmentsPaxes passenger,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          passenger.name ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (passenger.isFOC == true) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'FOC',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAgeCell(int? age) {
    if (age == null) return const Text('-', style: TextStyle(fontSize: 12));

    Color color;
    if (age < 18) {
      color = Colors.blue.shade700;
    } else if (age >= 65) {
      color = Colors.orange.shade700;
    } else {
      color = Colors.grey.shade700;
    }

    return Text(
      '$age',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
    );
  }

  Widget _buildGenderCell(String? gender) {
    if (gender == null || gender.isEmpty) {
      return const Text('-', style: TextStyle(fontSize: 12));
    }

    final isMale = gender.toUpperCase() == 'M';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMale ? Icons.male : Icons.female,
          size: 16,
          color: isMale ? Colors.blue.shade700 : Colors.pink.shade700,
        ),
        const SizedBox(width: 4),
        Text(
          gender.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isMale ? Colors.blue.shade700 : Colors.pink.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightCell(int? weight) {
    if (weight == null) return const Text('-', style: TextStyle(fontSize: 12));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.monitor_weight, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          '${weight.toStringAsFixed(0)} kg',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPositionCell(int? position) {
    if (position == null)
      return const Text('-', style: TextStyle(fontSize: 12));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.indigo.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_searching,
            size: 14,
            color: Colors.indigo.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            'Q$position',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermitCell(String? permitNumber) {
    if (permitNumber == null || permitNumber.isEmpty) {
      return const Text('-', style: TextStyle(fontSize: 12));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        permitNumber,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.teal.shade900,
        ),
      ),
    );
  }

  Widget _buildTextWithIcon(String text, IconData icon, Color color) {
    if (text.isEmpty || text == '-') {
      return const Text('-', style: TextStyle(fontSize: 12));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCell(String? value, Color color) {
    if (value == null || value.isEmpty || value == '-') {
      return const Text(
        '-',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: color,
            // color: color.shade700,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                // color: color.shade900,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
