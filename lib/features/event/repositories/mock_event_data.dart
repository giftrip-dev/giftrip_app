import 'package:myong/features/event/models/event_model.dart';

/// 목업 이벤트 데이터
final List<EventModel> mockEventList = List.generate(
  30,
  (index) => EventModel(
    thumbnailUrl: 'assets/webp/icons/event.webp',
    title: '이벤트 ${index + 1}',
    description: '이것은 이벤트 ${index + 1}의 상세 설명입니다. 다양한 혜택과 즐거운 경험을 제공합니다.',
    startDate: DateTime.now().add(Duration(days: index)),
    endDate: DateTime.now().add(Duration(days: index + 30)),
    isActive: true,
  ),
);
