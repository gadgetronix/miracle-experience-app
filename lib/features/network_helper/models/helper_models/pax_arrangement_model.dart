class PaxArrangementModel {
  final int passengerId;
  final int quadrantPosition; // 0..3

  PaxArrangementModel({
    required this.passengerId,
    required this.quadrantPosition,
  });

  Map<String, dynamic> toJson() => {
    'passengerId': passengerId,
    'quadrantPosition': quadrantPosition,
  };

  factory PaxArrangementModel.fromJson(Map<String, dynamic> json) {
    return PaxArrangementModel(
      passengerId: json['passengerId'],
      quadrantPosition: json['quadrantPosition'],
    );
  }
}
