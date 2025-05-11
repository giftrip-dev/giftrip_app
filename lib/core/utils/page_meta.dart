class PageMeta {
  final int totalItems;
  final int currentPage;
  final int itemsPerPage;
  final int totalPages;

  PageMeta({
    required this.totalItems,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      itemsPerPage: json['itemsPerPage'],
      totalPages: json['totalPages'],
    );
  }
}
