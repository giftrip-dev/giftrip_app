import 'package:flutter/material.dart';
import 'package:giftrip/features/leave/repositories/leave_repo.dart';

class FeedbackViewModel extends ChangeNotifier {
  final LeaveRepo _leaveRepo = LeaveRepo();

  final List<int> _selectedFeedbacks = [];
  final Map<int, TextEditingController> _detailControllers = {};
  bool _isButtonEnabled = false;

  List<int> get selectedFeedbacks => List.unmodifiable(_selectedFeedbacks);
  bool get isButtonEnabled => _isButtonEnabled;
  TextEditingController? getDetailController(int feedbackType) =>
      _detailControllers[feedbackType];

  void toggleFeedback(int feedbackType) {
    if (_selectedFeedbacks.contains(feedbackType)) {
      _selectedFeedbacks.remove(feedbackType);
      _detailControllers[feedbackType]?.dispose();
      _detailControllers.remove(feedbackType);
    } else {
      _selectedFeedbacks.add(feedbackType);
      if (_requiresDetailInput(feedbackType)) {
        _detailControllers[feedbackType] = TextEditingController()
          ..addListener(_updateButtonState);
      }
    }
    _updateButtonState();
  }

  bool _requiresDetailInput(int feedbackType) =>
      [1, 2, 3, 6].contains(feedbackType);

  void _updateButtonState() {
    _isButtonEnabled = _selectedFeedbacks.isNotEmpty &&
        _selectedFeedbacks.every((feedback) {
          return !_requiresDetailInput(feedback) ||
              (_detailControllers[feedback]?.text.isNotEmpty ?? false);
        });
    notifyListeners();
  }

  Future<bool> submitFeedback() async {
    if (!_isButtonEnabled) return false;

    final feedbacks = _selectedFeedbacks.map((type) {
      return FeedbackDto(
        feedbackType: type.toString(),
        detail: _detailControllers[type]?.text ?? '',
      );
    }).toList();

    final result = await _leaveRepo.postFeedback(feedbacks);

    // 제출 성공 시 기존 선택 및 입력값 초기화
    if (result) {
      _clearFeedback();
    }

    return result;
  }

  // 피드백 상태 초기화 핸들러
  void _clearFeedback() {
    _selectedFeedbacks.clear();
    for (var controller in _detailControllers.values) {
      controller.dispose();
    }
    _detailControllers.clear();
    _updateButtonState(); // 버튼 상태도 초기화
  }

  @override
  void dispose() {
    for (var controller in _detailControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
