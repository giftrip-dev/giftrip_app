// 자격증 업데이트
class CertificatesUpdateRequestDto {
  final String? category;
  final String? type;
  final String? name;
  final String? birthDate;
  final String? designerName;
  final String? storeName;
  final String? instagramId;
  final String? fileUrl;

  CertificatesUpdateRequestDto({
    this.category,
    this.type,
    this.name,
    this.birthDate,
    this.designerName,
    this.storeName,
    this.instagramId,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (category != null) "category": category,
      if (type != null) "type": type,
      if (name != null) "name": name,
      if (birthDate != null) "birthDate": birthDate,
      if (designerName != null) "designerName": designerName,
      if (storeName != null) "storeName": storeName,
      if (instagramId != null) "instagramId": instagramId,
      if (fileUrl != null) "fileUrl": fileUrl,
    };
  }
}
