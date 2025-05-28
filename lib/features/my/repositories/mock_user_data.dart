import 'package:giftrip/features/my/models/user_model.dart';

/// 목업 이벤트 데이터
final UserModel mockUser = UserModel(
  id: '1',
  name: '홍길동',
  point: '10000',
  coponCount: '10',
  isInfluencer: true,
  isMarketingAgree: true,
);

/// 회원 관리 데이터
final UserModel mockUserManagement = UserModel(
  id: '1',
  name: '홍길동',
  email: 'test@test.com',
  phone: '01012345678',
  isInfluencer: true,
  zipCode: '12345',
  address: '서울시 강남구 역삼동',
  detailAddress: '오피스타워',
  deliveryEmail: 'test@test.com',
  deliveryPhone: '01012345678',
);
