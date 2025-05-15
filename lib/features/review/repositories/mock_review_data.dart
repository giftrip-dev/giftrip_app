import 'package:myong/features/review/models/review_model.dart';

/// 리뷰 목업 데이터
final List<ReviewModel> mockReviewList = [
  ReviewModel(
    id: 'review1',
    content:
        '친구들과 함께 참여했는데 모두 만족했습니다. 특히 강사님의 설명이 친절하고 이해하기 쉬웠어요. 다음에도 꼭 또 참여하고 싶네요.',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    userId: 'user1',
    userNickname: '여행좋아',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review2',
    content:
        '전반적으로 만족스러웠지만, 소요 시간이 안내된 것보다 길어서 약간 계획에 차질이 생겼어요. 그래도 체험 자체는 매우 유익했습니다.',
    rating: 4.0,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    userId: 'user2',
    userNickname: '맛집탐방러',
    thumbnailUrl: null,
  ),
  ReviewModel(
    id: 'review3',
    content:
        '아이들과 함께 했는데 너무 재미있어 했어요. 특히 만드는 과정이 간단해서 아이들도 쉽게 따라할 수 있었습니다. 다음에 다른 체험도 해보고 싶어요!',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    userId: 'user3',
    userNickname: '행복한맘',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review4',
    content: '체험 내용은 좋았는데 장소가 찾기 어려웠고 주차도 불편했어요. 가는 길에 표지판이 더 있었으면 좋겠습니다.',
    rating: 3.0,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    userId: 'user4',
    userNickname: '솔직리뷰',
    thumbnailUrl: null,
  ),
  ReviewModel(
    id: 'review5',
    content:
        '대학교 동기들과 함께 했는데 너무 재밌었어요! 사진도 많이 찍고 좋은 추억 만들었습니다. 진행하시는 분들도 너무 친절하셨어요.',
    rating: 4.0,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    userId: 'user5',
    userNickname: '사진사랑',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review6',
    content: '전에 해본 적 없는 체험이라 걱정했는데, 차근차근 알려주셔서 잘 따라할 수 있었습니다. 결과물도 마음에 들어요!',
    rating: 4.0,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    userId: 'user6',
    userNickname: '호기심많은',
    thumbnailUrl: null,
  ),
  ReviewModel(
    id: 'review7',
    content: '사용하는 재료가 상당히 고급스러워서 결과물의 퀄리티가 좋았습니다. 강사님도 전문적인 지식이 많으셔서 많이 배웠어요.',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 18)),
    userId: 'user7',
    userNickname: '품질중시',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review8',
    content:
        '남자친구와 함께 갔는데 둘 다 너무 즐거운 시간이었습니다. 서로 도와가며 만드니 더 재미있었어요. 커플끼리 가면 좋을 것 같아요!',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    userId: 'user8',
    userNickname: '데이트퀸',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review9',
    content:
        '내용은 좋았는데 체험 시간이 생각보다 짧아서 조금 더 여유롭게 즐기지 못한 점이 아쉬웠습니다. 시간이 좀 더 길었으면 좋겠어요.',
    rating: 3.0,
    createdAt: DateTime.now().subtract(const Duration(days: 22)),
    userId: 'user9',
    userNickname: '천천히즐김',
    thumbnailUrl: null,
  ),
  ReviewModel(
    id: 'review10',
    content:
        '가격 대비 체험의 퀄리티가 정말 좋았습니다. 재료도 넉넉하게 주시고 강사님의 꼼꼼한 지도로 만족스러운 결과물을 가져갈 수 있었어요.',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    userId: 'user10',
    userNickname: '알뜰살뜰',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review11',
    content: '체험 내용은 좋았는데 장소가 찾기 어려웠고 주차도 불편했어요. 가는 길에 표지판이 더 있었으면 좋겠습니다.',
    rating: 3.0,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    userId: 'user11',
    userNickname: '화난 고양이',
    thumbnailUrl: 'assets/png/banner.png',
  ),
  ReviewModel(
    id: 'review12',
    content: '뭔가 재밌는데 안 재밋음',
    rating: 5.0,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    userId: 'user12',
    userNickname: '촉촉한소보루',
    thumbnailUrl: 'assets/png/banner.png',
  ),
];

// final List<ReviewModel> mockReviewList = [];
