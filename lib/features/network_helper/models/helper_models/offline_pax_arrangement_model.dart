import 'pax_arrangement_model.dart';

class OfflinePaxArrangementModel {
  final List<int?> unassigned;
  final List<PaxArrangementModel?> assigned; // quadrant 0..3

  OfflinePaxArrangementModel({
    required this.unassigned,
    required this.assigned,
  });

  /// Convert to JSON for SharedPrefs
  Map<String, dynamic> toJson() {
    return {
      'unassigned': unassigned,
      'assigned': assigned.map((e) => e?.toJson()).toList(),
    };
  }

  /// Restore from JSON
  factory OfflinePaxArrangementModel.fromJson(Map<String, dynamic> json) {
    return OfflinePaxArrangementModel(
      unassigned: (json['unassigned'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      assigned: (json['assigned'] as List<dynamic>? ?? [])
          .map(
            (e) => PaxArrangementModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }
}
