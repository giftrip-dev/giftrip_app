import 'package:giftrip/features/lodging/view_models/room_view_model.dart';

final List<RoomViewModel> mockRoomList = [
  RoomViewModel(
    id: '1',
    roomName: '슈퍼 트윈룸',
    baseOccupancy: 2,
    maxOccupancy: 2,
    bedType: '싱글 침대 2개',
    viewType: '도시 전망, 바다 전망',
    checkInTime: '15:00',
    checkOutTime: '11:00',
    originalPrice: 40000,
    discountRate: 12,
    finalPrice: 32900,
    imageUrls: [
      'assets/png/room_1.png',
      'assets/png/room_2.jpeg',
    ],
  ),
  RoomViewModel(
    id: '2',
    roomName: '디럭스 더블룸',
    baseOccupancy: 2,
    maxOccupancy: 3,
    bedType: '더블 침대 1개',
    viewType: '시티뷰',
    checkInTime: '15:00',
    checkOutTime: '11:00',
    originalPrice: 50000,
    discountRate: 10,
    finalPrice: 45000,
    imageUrls: [
      'assets/png/room_2.jpeg',
      'assets/png/room_1.png',
    ],
  ),
];
