class UserModel {
  final String id;
  final String name;
  final int point;
  final int coponCount;
  final bool isInfluencer;
  final bool isMarketingAgree;

  const UserModel({
    required this.id,
    required this.name,
    required this.point,
    required this.coponCount,
    required this.isInfluencer,
    required this.isMarketingAgree,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      point: json['point'] as int,
      coponCount: json['coponCount'] as int,
      isInfluencer: json['isInfluencer'] as bool,
      isMarketingAgree: json['isMarketingAgree'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'point': point,
      'coponCount': coponCount,
      'isInfluencer': isInfluencer,
      'isMarketingAgree': isMarketingAgree,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    int? point,
    int? coponCount,
    bool? isInfluencer,
    bool? isMarketingAgree,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      point: point ?? this.point,
      coponCount: coponCount ?? this.coponCount,
      isInfluencer: isInfluencer ?? this.isInfluencer,
      isMarketingAgree: isMarketingAgree ?? this.isMarketingAgree,
    );
  }
}
