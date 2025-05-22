class PointModel {
  final int availablePoint;
  final int totalEarnedPoint;
  final int totalUsedPoint;

  PointModel({
    required this.availablePoint,
    required this.totalEarnedPoint,
    required this.totalUsedPoint,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      availablePoint: json['availablePoint'] as int,
      totalEarnedPoint: json['totalEarnedPoint'] as int,
      totalUsedPoint: json['totalUsedPoint'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availablePoint': availablePoint,
      'totalEarnedPoint': totalEarnedPoint,
      'totalUsedPoint': totalUsedPoint,
    };
  }
}
