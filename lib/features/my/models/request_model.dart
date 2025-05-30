enum RequestStatus {
  cancel('예약취소'),
  refund('환불완료'),
  exchange('교환완료');

  final String label;
  const RequestStatus(this.label);
}

enum CategoryType {
  product,
  lodging,
  experience,
}

class RequestModel {
  final String id; // 예약 고유 ID
  final String name;
  final String date; // 예약일자 (예: 24.08.23)
  final int price; // 가격 (숫자형)
  final String imageUrl; // 썸네일 이미지 URL
  final RequestStatus status; // 예약상태 (예: 예약완료, 예약취소 등)
  final CategoryType category; // 카테고리

  const RequestModel({
    required this.id,
    required this.name,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.category,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      price: json['price'] as int,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as RequestStatus,
      category: json['category'] as CategoryType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'price': price,
      'imageUrl': imageUrl,
      'status': status,
      'category': category,
    };
  }

  RequestModel copyWith({
    String? id,
    String? name,
    String? date,
    int? price,
    String? imageUrl,
    RequestStatus? status,
    CategoryType? category,
  }) {
    return RequestModel(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        status: status ?? this.status,
        category: category ?? this.category);
  }
}
