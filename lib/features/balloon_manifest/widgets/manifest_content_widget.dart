import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/passengers_table_widget.dart';

/// Widget to display balloon manifest content
/// Shows pilot assignments, passenger tables, and manifest details
class ManifestContentWidget extends StatelessWidget {
  final ModelResponseBalloonManifestEntity manifest;
  final bool isOfflineMode;

  const ManifestContentWidget({
    super.key,
    required this.manifest,
    required this.isOfflineMode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.commonPaddingForScreen,
          vertical: Dimensions.h20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Manifest header
            _buildManifestHeader(),

            const SizedBox(height: 24),

            // Pilot assignments section with passengers
            _buildPilotAssignmentsSectionWithPassengers(),

            const SizedBox(height: 24),

            // Manifest details section
            _buildManifestDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildManifestHeader() {
    timber('Manifest date: ${manifest.manifestDate}');
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.indigo.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manifest Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          manifest.manifestDate ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(Icons.location_on, manifest.location ?? 'N/A'),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    Icons.confirmation_number,
                    manifest.uniqueId ?? 'N/A',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPilotAssignmentsSectionWithPassengers() {
    if (manifest.assignments == null || manifest.assignments!.isEmpty) {
      return _buildEmptyAssignments();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Flight Assignments', Icons.flight_takeoff),
        const SizedBox(height: 16),
        ...manifest.assignments!.asMap().entries.map((entry) {
          final index = entry.key;
          final assignment = entry.value;
          return Column(
            children: [
              // Pilot card
              _buildPilotCard(assignment, index + 1),
              const SizedBox(height: 12),

              // Passengers table for this pilot
              if (assignment.paxes != null && assignment.paxes!.isNotEmpty)
                PassengersTableWidget(
                  passengers: assignment.paxes!,
                  pilotName: assignment.pilotName ?? 'Unknown',
                  balloonCode: assignment.shortCode ?? 'N/A',
                ),

              const SizedBox(height: 24),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPilotCard(
    ModelResponseBalloonManifestAssignments assignment,
    int flightNumber,
  ) {
    final totalPaxWeight =
        assignment.paxes?.fold<double>(
          0,
          (sum, pax) => sum + (pax.weight ?? 0),
        ) ??
        0;

    final totalWeight =
        totalPaxWeight +
        (assignment.pilotWeight ?? 0) +
        (assignment.defaultWeight ?? 0);
    final maxWeight = assignment.maxWeightWithPax ?? 0;
    final weightPercentage = maxWeight > 0 ? (totalWeight / maxWeight) : 0;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Flight number badge
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '#$flightNumber',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Pilot details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.pilotName ?? 'Unknown Pilot',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            _buildPilotInfoItem(
                              Icons.flight,
                              assignment.shortCode ?? 'N/A',
                            ),
                            _buildPilotInfoItem(
                              Icons.people,
                              '${assignment.paxes?.length ?? 0}/${assignment.capacity ?? 0}',
                            ),
                            _buildPilotInfoItem(
                              Icons.table_restaurant,
                              'Table ${assignment.tableNumber ?? 'N/A'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Weight information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight Distribution',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${totalWeight.toStringAsFixed(0)} / ${maxWeight.toStringAsFixed(0)} kg',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: weightPercentage.toDouble(),
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          weightPercentage > 0.9
                              ? Colors.red.shade300
                              : weightPercentage > 0.75
                              ? Colors.orange.shade300
                              : Colors.green.shade300,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeightDetail(
                          'Pilot',
                          assignment.pilotWeight ?? 0,
                        ),
                        _buildWeightDetail(
                          'Equipment',
                          assignment.defaultWeight ?? 0,
                        ),
                        _buildWeightDetail('Passengers', totalPaxWeight),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPilotInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildWeightDetail(String label, double weight) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7)),
        ),
        const SizedBox(height: 2),
        Text(
          '${weight.toStringAsFixed(0)} kg',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyAssignments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No flight assignments available',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManifestDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Manifest Summary', Icons.summarize),
            const SizedBox(height: 16),
            _buildSummaryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid() {
    final totalAssignments = manifest.assignments?.length ?? 0;
    final totalPassengers =
        manifest.assignments?.fold<int>(
          0,
          (sum, assignment) => sum + (assignment.paxes?.length ?? 0),
        ) ??
        0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Flights',
                totalAssignments.toString(),
                Icons.flight,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Passengers',
                totalPassengers.toString(),
                Icons.people,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Location',
                manifest.location ?? 'N/A',
                Icons.location_on,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Date',
                manifest.manifestDate ?? 'N/A',
                Icons.calendar_today,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
