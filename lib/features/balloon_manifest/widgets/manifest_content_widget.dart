import 'package:flutter/material.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Manifest header
          // _buildManifestHeader(),

          // const SizedBox(height: 24),

          // Pilot assignments section with passengers
          _buildPilotAssignmentsSectionWithPassengers(),

          const SizedBox(height: 24),

          // Manifest details section
          // _buildManifestDetailsSection(),
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
        // _buildSectionHeader('Flight Assignments', Icons.flight_takeoff),
        // const SizedBox(height: 16),
        ...manifest.assignments!.asMap().entries.map((entry) {
          final index = entry.key;
          final assignment = entry.value;
          return Column(
            children: [
              // Pilot card
              // _buildPilotCard(assignment, index + 1),
              // const SizedBox(height: 12),

              // Passengers table for this pilot
              if (assignment.paxes != null && assignment.paxes!.isNotEmpty)
                PassengersListWidget(
                  passengers: assignment.paxes!,
                  manifestId: manifest.uniqueId ?? '',
                  assignmentId: assignment.id ?? 0,
                  pilotName: assignment.pilotName ?? 'Unknown',
                  balloonCode: assignment.shortCode ?? 'N/A',
                  tableNumber: assignment.tableNumber ?? 0,
                  location: manifest.location ?? 'N/A',
                  date: manifest.manifestDate ?? 'N/A',
                  otherWeights:
                      (assignment.pilotWeight ?? 0) +
                      (assignment.defaultWeight ?? 0),
                ),

              const SizedBox(height: 24),
            ],
          );
        }),
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
}
