class UserModel {
  final String id;
  final String name;
  final String? point;
  final String? coponCount;
  final bool? isInfluencer;
  final bool? isMarketingAgree;
  final String? email;
  final String? phone;
  //우편번호
  final String? zipCode;
  final String? address;
  final String? detailAddress;
  final String? deliveryEmail;
  final String? deliveryPhone;

  const UserModel({
    required this.id,
    required this.name,
    this.point,
    this.coponCount,
    this.isInfluencer,
    this.isMarketingAgree,
    this.email,
    this.phone,
    this.zipCode,
    this.address,
    this.detailAddress,
    this.deliveryEmail,
    this.deliveryPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      point: json['point'] as String,
      coponCount: json['coponCount'] as String,
      isInfluencer: json['isInfluencer'] as bool,
      isMarketingAgree: json['isMarketingAgree'] as bool,
      email: json['email'] as String,
      phone: json['phone'] as String,
      zipCode: json['zipCode'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      deliveryEmail: json['deliveryEmail'] as String,
      deliveryPhone: json['deliveryPhone'] as String,
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
      'email': email,
      'phone': phone,
      'zipCode': zipCode,
      'address': address,
      'detailAddress': detailAddress,
      'deliveryEmail': deliveryEmail,
      'deliveryPhone': deliveryPhone,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? point,
    String? coponCount,
    bool? isInfluencer,
    bool? isMarketingAgree,
    String? email,
    String? phone,
    String? zipCode,
    String? address,
    String? detailAddress,
    String? deliveryEmail,
    String? deliveryPhone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      point: point ?? this.point,
      coponCount: coponCount ?? this.coponCount,
      isInfluencer: isInfluencer ?? this.isInfluencer,
      isMarketingAgree: isMarketingAgree ?? this.isMarketingAgree,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      zipCode: zipCode ?? this.zipCode,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      deliveryEmail: deliveryEmail ?? this.deliveryEmail,
      deliveryPhone: deliveryPhone ?? this.deliveryPhone,
    );
  }
}
