// 직군 업데이트
class CertificateModel {
  final String id;
  final String? certificateNumber;
  final String? issuedDate;
  final String? category;
  final String? designerName;
  final String? storeName;
  final String? verificationType;
  final String status;
  final String? rejectionReason;
  final String? expiryDate;
  final String? createdAt;
  final String? userName;
  final String? userEmail;

  CertificateModel({
    required this.id,
    this.certificateNumber,
    this.issuedDate,
    this.category,
    this.designerName,
    this.storeName,
    this.verificationType,
    required this.status,
    this.rejectionReason,
    this.expiryDate,
    this.createdAt,
    this.userName,
    this.userEmail,
  });

  CertificateModel copyWith({
    String? id,
    String? certificateNumber,
    String? issuedDate,
    String? category,
    String? designerName,
    String? storeName,
    String? verificationType,
    String? status,
    String? rejectionReason,
    String? expiryDate,
    String? createdAt,
    String? userName,
    String? userEmail,
  }) {
    return CertificateModel(
      id: id ?? this.id,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      issuedDate: issuedDate ?? this.issuedDate,
      category: category ?? this.category,
      designerName: designerName ?? this.designerName,
      storeName: storeName ?? this.storeName,
      verificationType: verificationType ?? this.verificationType,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'],
      certificateNumber: json['certificateNumber'],
      issuedDate: json['issuedDate'],
      category: json['category'],
      designerName: json['designerName'],
      storeName: json['storeName'],
      verificationType: json['verificationType'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      expiryDate: json['expiryDate'],
      createdAt: json['createdAt'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificateNumber': certificateNumber,
      'issuedDate': issuedDate,
      'category': category,
      'designerName': designerName,
      'storeName': storeName,
      'verificationType': verificationType,
      'status': status,
      'rejectionReason': rejectionReason,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  @override
  String toString() {
    return 'CertificateModel{id: $id, certificateNumber: $certificateNumber, issuedDate: $issuedDate, category: $category, designerName: $designerName, storeName: $storeName, verificationType: $verificationType, status: $status, rejectionReason: $rejectionReason, expiryDate: $expiryDate, createdAt: $createdAt, userName: $userName, userEmail: $userEmail}';
  }
}
