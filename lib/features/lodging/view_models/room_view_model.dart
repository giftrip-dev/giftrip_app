class RoomViewModel {
  final String roomName;
  final String id;
  final int baseOccupancy;
  final int maxOccupancy;
  final String bedType;
  final String viewType;
  final String checkInTime;
  final String checkOutTime;
  final int originalPrice;
  final int discountRate;
  final int finalPrice;
  final List<String> imageUrls;
  final String? etc;

  RoomViewModel({
    required this.roomName,
    required this.id,
    required this.baseOccupancy,
    required this.maxOccupancy,
    required this.bedType,
    required this.viewType,
    required this.checkInTime,
    required this.checkOutTime,
    required this.originalPrice,
    required this.discountRate,
    required this.finalPrice,
    required this.imageUrls,
    this.etc,
  });
}
