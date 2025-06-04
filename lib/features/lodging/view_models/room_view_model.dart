import 'package:flutter/foundation.dart';
import 'package:giftrip/features/lodging/models/lodging_room_model.dart';
import 'package:giftrip/features/lodging/repositories/lodging_repo.dart';

class RoomViewModel extends ChangeNotifier {
  final LodgingRepo _repo = LodgingRepo();

  List<LodgingRoomModel> _roomList = [];
  int _total = 0;
  int _page = 1;
  int _limit = 10;
  bool _isLoading = false;
  bool _hasError = false;
  String? _accommodationId;
  DateTime? _startDate;
  DateTime? _endDate;

  // 외부 접근용 Getter
  List<LodgingRoomModel> get roomList => _roomList;
  int get total => _total;
  int get page => _page;
  int get limit => _limit;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get accommodationId => _accommodationId;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // 객실 리스트 조회
  Future<void> fetchRoomList({
    required String accommodationId,
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      final response = await _repo.getAvailableRoomsForAccommodation(
        accommodationId: accommodationId,
        startDate: startDate.toIso8601String().split('T').first,
        endDate: endDate.toIso8601String().split('T').first,
        page: page,
        limit: limit,
      );
      _roomList = response.items;
      _total = response.total;
      _page = response.page;
      _limit = response.limit;
      _accommodationId = accommodationId;
      _startDate = startDate;
      _endDate = endDate;
      _hasError = false;
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearRooms() {
    _roomList = [];
    _total = 0;
    _page = 1;
    _limit = 10;
    _accommodationId = null;
    _startDate = null;
    _endDate = null;
    _hasError = false;
    notifyListeners();
  }
}
