import 'package:flutter/material.dart';
import 'package:giftrip/features/point/models/point_model.dart';
import 'package:giftrip/features/point/repositories/point_repository.dart';

class PointViewModel extends ChangeNotifier {
  final PointRepository _repository;

  PointModel? _point;
  bool _isLoading = false;
  String? _error;

  PointViewModel(this._repository);

  PointModel? get point => _point;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPoint() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _point = await _repository.getPoint();
    } catch (e) {
      _error = '포인트 정보를 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
