import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';

/// 목업 쇼핑 상품 목록
final List<ShoppingModel> mockShoppingList = [
  // 특산품
  ShoppingModel(
    id: 'shop_001',
    title: '제주 감귤 선물세트',
    description: '제주도의 신선한 감귤을 담은 고급 선물세트입니다.',
    content:
        '''[{"insert":"제주 감귤 선물세트"},{"attributes":{"header":2},"insert":"\\n"},{"insert":"\\n제주도의 청정 자연에서 자란 "},{"attributes":{"bold":true},"insert":"프리미엄 감귤"},{"insert":"을 엄선하여 담은 고급 선물세트입니다.\\n\\n"},{"insert":"🍊 "},{"attributes":{"bold":true},"insert":"상품 특징"},{"insert":"\\n• 제주도 직송 신선한 감귤\\n• 당도 13브릭스 이상 보장\\n• 친환경 농법으로 재배\\n• 고급 선물 포장 제공\\n\\n"},{"insert":"📦 "},{"attributes":{"bold":true},"insert":"구성품"},{"insert":"\\n• 감귤 2kg/3kg/5kg 선택 가능\\n• 전용 선물 박스\\n• 감사 인사말 카드\\n\\n"},{"insert":"⚠️ "},{"attributes":{"bold":true},"insert":"주의사항"},{"insert":"\\n• 냉장 보관 권장\\n• 수령 후 일주일 내 드세요\\n• 알레르기 유발 가능성 확인 후 구매\\n\\n"},{"insert":{"image":"https://blog.kakaocdn.net/dn/o1KIw/btqu9mflPY6/rGk1mM3iugV1c6jj9Z3E80/img.jpg"}}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 35000,
    finalPrice: 28000,
    discountRate: 20,
    category: ShoppingCategory.speciality,
    rating: 4.8,
    averageRating: 4.8,
    reviewCount: 128,
    badges: [ProductTagType.bestSeller, ProductTagType.newArrival],
    manufacturer: '제주과일농장',
    options: [
      ShoppingOption(name: '감귤 2kg', price: 28000),
      ShoppingOption(name: '감귤 3kg', price: 38000),
      ShoppingOption(name: '감귤 5kg', price: 58000),
    ],
  ),

  // 로컬상품
  ShoppingModel(
    id: 'shop_002',
    title: '강원도 수제 감자칩',
    description: '강원도 평창의 신선한 감자로 만든 수제 감자칩',
    content:
        '''[{"insert":"강원도 수제 감자칩"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n강원도 평창의 "},{"attributes":{"bold":true},"insert":"청정 고원지대"},{"insert":"에서 자란 신선한 감자로 만든 프리미엄 수제 감자칩입니다.\\n\\n"},{"insert":"🥔 "},{"attributes":{"bold":true},"insert":"제품 특징"},{"insert":"\\n• 100% 강원도 평창산 감자 사용\\n• 무첨가, 무방부제\\n• 전통 방식 수제 제조\\n• 바삭한 식감과 고소한 맛\\n\\n"},{"insert":"🏔️ "},{"attributes":{"bold":true},"insert":"원료 정보"},{"insert":"\\n• 고원지대 청정 감자\\n• 해바라기유 100%\\n• 천일염 사용\\n\\n"},{"insert":"💝 "},{"attributes":{"bold":true},"insert":"포장 안내"},{"insert":"\\n• 개별 밀봉 포장\\n• 선물용 포장 가능\\n• 유통기한: 제조일로부터 6개월"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 12000,
    finalPrice: 12000,
    category: ShoppingCategory.local,
    rating: 4.5,
    averageRating: 4.5,
    reviewCount: 56,
    badges: [ProductTagType.newArrival],
    manufacturer: '평창푸드',
    options: [
      ShoppingOption(name: '소포장 100g', price: 12000),
      ShoppingOption(name: '대포장 300g', price: 32000),
      ShoppingOption(name: '대대포장 300g', price: 32000),
      ShoppingOption(name: '대대대포장 300g', price: 32000),
    ],
  ),

  // 기념품
  ShoppingModel(
    id: 'shop_003',
    title: '경주 여행 미니어처 세트',
    description: '경주의 유명 관광지를 담은 미니어처 세트',
    content:
        '''[{"insert":"경주 여행 미니어처 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n천년 고도 경주의 "},{"attributes":{"bold":true},"insert":"대표 문화재"},{"insert":"를 정교하게 재현한 프리미엄 미니어처 컬렉션입니다.\\n\\n"},{"insert":"🏛️ "},{"attributes":{"bold":true},"insert":"구성품"},{"insert":"\\n• 불국사 대웅전\\n• 석굴암 본존불\\n• 첨성대\\n• 안압지 (기본 세트)\\n• + 황룡사 9층 목탑 (프리미엄)\\n\\n"},{"insert":"✨ "},{"attributes":{"bold":true},"insert":"제품 특징"},{"insert":"\\n• 정밀 3D 프린팅 기술\\n• 친환경 소재 사용\\n• 컬러풀한 페인팅 마감\\n• 전용 디스플레이 받침대 포함\\n\\n"},{"insert":"🎁 "},{"attributes":{"bold":true},"insert":"선물 포장"},{"insert":"\\n• 고급 선물 상자\\n• 경주 역사 설명서 동봉\\n• 기념품 인증서 제공"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 25000,
    finalPrice: 20000,
    discountRate: 20,
    category: ShoppingCategory.souvenir,
    rating: 4.3,
    averageRating: 4.3,
    reviewCount: 32,
    badges: [ProductTagType.almostSoldOut],
    manufacturer: '한국기념품제작소',
    options: [
      ShoppingOption(name: '기본 세트 (3개)', price: 20000),
      ShoppingOption(name: '프리미엄 세트 (5개)', price: 35000),
    ],
  ),

  // 식품
  ShoppingModel(
    id: 'shop_004',
    title: '전통 한과 세트',
    description: '전통 방식으로 만든 프리미엄 한과 선물세트',
    content:
        '''[{"insert":"전통 한과 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n조선시대부터 내려오는 "},{"attributes":{"bold":true},"insert":"전통 제조법"},{"insert":"으로 정성스럽게 만든 프리미엄 한과 선물세트입니다.\\n\\n"},{"insert":"🍯 "},{"attributes":{"bold":true},"insert":"한과 구성"},{"insert":"\\n• 약과: 국산 밀가루와 꿀로 제조\\n• 유과: 찹쌀을 튀겨 만든 바삭한 과자\\n• 강정: 견과류와 조청의 조화\\n• 다식: 곱게 빻은 콩가루 압축\\n• 정과: 생강, 연근 등 자연 재료\\n\\n"},{"insert":"🌾 "},{"attributes":{"bold":true},"insert":"원료 정보"},{"insert":"\\n• 100% 국산 재료 사용\\n• 무첨가, 무방부제\\n• 전통 조청과 국산 꿀\\n• 프리미엄 견과류\\n\\n"},{"insert":"📅 "},{"attributes":{"bold":true},"insert":"보관법"},{"insert":"\\n• 직사광선 피해 서늘한 곳 보관\\n• 개봉 후 밀폐 용기 보관\\n• 유통기한: 제조일로부터 30일"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 45000,
    finalPrice: 38000,
    discountRate: 15,
    category: ShoppingCategory.food,
    rating: 4.9,
    averageRating: 4.9,
    reviewCount: 201,
    badges: [ProductTagType.bestSeller, ProductTagType.newArrival],
    manufacturer: '한과명가',
    options: [
      ShoppingOption(name: '소형 세트 (5종)', price: 38000),
      ShoppingOption(name: '중형 세트 (8종)', price: 58000),
      ShoppingOption(name: '대형 세트 (12종)', price: 88000),
    ],
  ),

  // 건강식품
  ShoppingModel(
    id: 'shop_005',
    title: '강화 순무 발효액',
    description: '강화도 특산품 순무로 만든 건강 발효액',
    content:
        '''[{"insert":"강화 순무 발효액"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n강화도의 "},{"attributes":{"bold":true},"insert":"청정 갯벌"},{"insert":"에서 자란 순무로 만든 프리미엄 건강 발효액입니다.\\n\\n"},{"insert":"🌱 "},{"attributes":{"bold":true},"insert":"제품 특징"},{"insert":"\\n• 강화도 특산 순무 100%\\n• 6개월 자연 발효\\n• 무첨가, 무방부제\\n• 풍부한 비타민과 미네랄\\n\\n"},{"insert":"💊 "},{"attributes":{"bold":true},"insert":"효능"},{"insert":"\\n• 소화 기능 개선\\n• 면역력 강화\\n• 항산화 작용\\n• 피로 회복\\n\\n"},{"insert":"🥤 "},{"attributes":{"bold":true},"insert":"섭취 방법"},{"insert":"\\n• 하루 2회, 1회 30ml\\n• 물과 희석하여 드세요\\n• 공복에 드시면 더욱 효과적"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 28000,
    finalPrice: 28000,
    category: ShoppingCategory.healthFood,
    rating: 4.7,
    averageRating: 4.7,
    reviewCount: 89,
    badges: [ProductTagType.newArrival],
    manufacturer: '강화건강식품',
    options: [
      ShoppingOption(name: '500ml', price: 28000),
      ShoppingOption(name: '1L', price: 52000),
    ],
  ),

  // 생활용품/문구
  ShoppingModel(
    id: 'shop_006',
    title: '전통 문양 노트 세트',
    description: '한국 전통 문양을 디자인에 활용한 프리미엄 노트 세트',
    content:
        '''[{"insert":"전통 문양 노트 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n한국의 "},{"attributes":{"bold":true},"insert":"아름다운 전통 문양"},{"insert":"을 현대적으로 재해석한 프리미엄 노트 컬렉션입니다.\\n\\n"},{"insert":"🎨 "},{"attributes":{"bold":true},"insert":"디자인 특징"},{"insert":"\\n• 단청 문양 노트\\n• 한글 자음 패턴 노트\\n• 전통 꽃 문양 노트\\n• 고급 양장 제본\\n\\n"},{"insert":"📝 "},{"attributes":{"bold":true},"insert":"제품 사양"},{"insert":"\\n• A5 사이즈\\n• 고급 미색지 사용\\n• 180페이지\\n• 하드커버\\n• 책갈피 리본 포함\\n\\n"},{"insert":"🎁 "},{"attributes":{"bold":true},"insert":"활용도"},{"insert":"\\n• 일기장, 스케치북\\n• 선물용으로 최적\\n• 사무용품\\n• 컬렉션 아이템"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 18000,
    finalPrice: 15000,
    discountRate: 17,
    category: ShoppingCategory.livingStationery,
    rating: 4.4,
    averageRating: 4.4,
    reviewCount: 42,
    badges: [ProductTagType.almostSoldOut],
    manufacturer: '한국문구',
    options: [
      ShoppingOption(name: '3권 세트', price: 15000),
      ShoppingOption(name: '5권 세트', price: 24000),
    ],
  ),

  // 주방용품
  ShoppingModel(
    id: 'shop_007',
    title: '전통 도자기 찻잔 세트',
    description: '전통 방식으로 제작된 고급 도자기 찻잔 세트',
    content:
        '''[{"insert":"전통 도자기 찻잔 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n이천의 "},{"attributes":{"bold":true},"insert":"전통 도자기 명장"},{"insert":"이 직접 제작한 프리미엄 찻잔 세트입니다.\\n\\n"},{"insert":"🏺 "},{"attributes":{"bold":true},"insert":"제품 특징"},{"insert":"\\n• 이천 전통 백자\\n• 수작업 성형\\n• 천연 유약 사용\\n• 1250도 고온 소성\\n\\n"},{"insert":"☕ "},{"attributes":{"bold":true},"insert":"구성품"},{"insert":"\\n• 찻잔 2개/4개 (선택)\\n• 찻잔 받침\\n• 찻주전자\\n• 고급 포장 상자\\n\\n"},{"insert":"⚠️ "},{"attributes":{"bold":true},"insert":"사용 및 관리"},{"insert":"\\n• 전자레인지 사용 가능\\n• 식기세척기 사용 가능\\n• 급격한 온도 변화 주의\\n• 부드러운 스펀지로 세척"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 65000,
    finalPrice: 65000,
    category: ShoppingCategory.kitchen,
    rating: 4.8,
    averageRating: 4.8,
    reviewCount: 37,
    badges: [ProductTagType.soldOut],
    manufacturer: '이천도자기',
    soldOut: true,
    options: [
      ShoppingOption(name: '2인용 세트', price: 65000),
      ShoppingOption(name: '4인용 세트', price: 120000),
    ],
  ),

  // 가구/가전
  ShoppingModel(
    id: 'shop_008',
    title: '전통 무늬 방석 세트',
    description: '전통 문양을 활용한 고급 방석 3종 세트',
    content:
        '''[{"insert":"전통 무늬 방석 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n한국의 "},{"attributes":{"bold":true},"insert":"전통 문양"},{"insert":"을 현대적 감각으로 재해석한 프리미엄 방석 컬렉션입니다.\\n\\n"},{"insert":"🪑 "},{"attributes":{"bold":true},"insert":"제품 구성"},{"insert":"\\n• 단청 문양 방석\\n• 조각보 패턴 방석\\n• 매화 문양 방석\\n• 40cm x 40cm 사이즈\\n\\n"},{"insert":"🧵 "},{"attributes":{"bold":true},"insert":"소재 정보"},{"insert":"\\n• 천연 면 100%\\n• 메모리폼 쿠션\\n• 항균 처리\\n• 세탁기 사용 가능\\n\\n"},{"insert":"🏠 "},{"attributes":{"bold":true},"insert":"활용법"},{"insert":"\\n• 거실, 침실 인테리어\\n• 명상, 요가용\\n• 바닥 생활 시 활용\\n• 선물용으로 인기"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 48000,
    finalPrice: 38000,
    discountRate: 21,
    category: ShoppingCategory.furnitureElectronics,
    rating: 4.6,
    averageRating: 4.6,
    reviewCount: 28,
    badges: [ProductTagType.almostSoldOut],
    manufacturer: '한국전통가구',
    options: [
      ShoppingOption(name: '3종 세트', price: 38000),
      ShoppingOption(name: '5종 세트', price: 58000),
    ],
  ),

  // 의료/뷰티
  ShoppingModel(
    id: 'shop_009',
    title: '제주 화산송이 마스크팩 세트',
    description: '제주 화산송이 성분이 함유된 프리미엄 마스크팩 10매',
    content:
        '''[{"insert":"제주 화산송이 마스크팩 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n제주도 "},{"attributes":{"bold":true},"insert":"천연 화산송이"},{"insert":"의 놀라운 흡착력으로 깨끗한 피부를 만들어보세요.\\n\\n"},{"insert":"🌋 "},{"attributes":{"bold":true},"insert":"주요 성분"},{"insert":"\\n• 제주 화산송이 추출물\\n• 히알루론산\\n• 알로에 베라\\n• 콜라겐\\n\\n"},{"insert":"✨ "},{"attributes":{"bold":true},"insert":"효과"},{"insert":"\\n• 모공 깊숙한 노폐물 제거\\n• 피부 진정 및 수분 공급\\n• 탄력 개선\\n• 피부 톤 균일화\\n\\n"},{"insert":"📋 "},{"attributes":{"bold":true},"insert":"사용법"},{"insert":"\\n• 세안 후 물기 제거\\n• 마스크 부착 (15-20분)\\n• 미지근한 물로 헹굼\\n• 주 2-3회 사용 권장"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 32000,
    finalPrice: 24000,
    discountRate: 25,
    category: ShoppingCategory.medicalBeauty,
    rating: 4.7,
    averageRating: 4.7,
    reviewCount: 152,
    badges: [ProductTagType.bestSeller, ProductTagType.newArrival],
    manufacturer: '제주코스메틱',
    options: [
      ShoppingOption(name: '10매 세트', price: 24000),
      ShoppingOption(name: '20매 세트', price: 45000),
      ShoppingOption(name: '30매 세트', price: 65000),
    ],
  ),

  // 기타
  ShoppingModel(
    id: 'shop_010',
    title: '여행용 멀티 어댑터',
    description: '해외여행에 필수! 전 세계 150개국 호환 어댑터',
    content:
        '''[{"insert":"여행용 멀티 어댑터"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n전 세계 "},{"attributes":{"bold":true},"insert":"150개국 호환"},{"insert":"! 해외여행의 필수 아이템입니다.\\n\\n"},{"insert":"🔌 "},{"attributes":{"bold":true},"insert":"호환 지역"},{"insert":"\\n• 미국, 캐나다 (A형)\\n• 유럽 전 지역 (C형)\\n• 영국, 홍콩 (G형)\\n• 호주, 중국 (I형)\\n\\n"},{"insert":"⚡ "},{"attributes":{"bold":true},"insert":"제품 사양"},{"insert":"\\n• 최대 전력: 2500W\\n• USB-A 포트 2개\\n• USB-C 포트 1개 (프리미엄)\\n• 과전류 보호 기능\\n\\n"},{"insert":"🛡️ "},{"attributes":{"bold":true},"insert":"안전 기능"},{"insert":"\\n• CE, FCC, RoHS 인증\\n• 과열 방지\\n• 쇼트 방지\\n• 휴대용 파우치 포함"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 35000,
    finalPrice: 29000,
    discountRate: 17,
    category: ShoppingCategory.others,
    rating: 4.5,
    averageRating: 4.5,
    reviewCount: 76,
    badges: [ProductTagType.newArrival],
    manufacturer: '트래블기어',
    options: [
      ShoppingOption(name: '기본형', price: 29000),
      ShoppingOption(name: '프리미엄형 (USB-C 포함)', price: 45000),
    ],
  ),

  // 특산품 2
  ShoppingModel(
    id: 'shop_011',
    title: '완도 활전복 선물세트',
    description: '남해 완도에서 직접 공수한 싱싱한 활전복 세트',
    content:
        '''[{"insert":"완도 활전복 선물세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n남해 완도의 "},{"attributes":{"bold":true},"insert":"청정 바다"},{"insert":"에서 직접 공수한 프리미엄 활전복 세트입니다.\\n\\n"},{"insert":"🐚 "},{"attributes":{"bold":true},"insert":"상품 특징"},{"insert":"\\n• 완도 직송 싱싱한 활전복\\n• 당일 어획, 당일 발송\\n• 냉장 포장 배송\\n• 프리미엄 등급만 선별\\n\\n"},{"insert":"🍽️ "},{"attributes":{"bold":true},"insert":"요리법"},{"insert":"\\n• 전복죽, 전복구이\\n• 전복회, 전복찜\\n• 전복버터구이\\n• 요리법 가이드 동봉\\n\\n"},{"insert":"📦 "},{"attributes":{"bold":true},"insert":"보관 및 배송"},{"insert":"\\n• 수령 즉시 냉장 보관\\n• 3일 내 조리 권장\\n• 전국 익일 배송\\n• 보냉 포장재 사용"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 78000,
    finalPrice: 69000,
    discountRate: 12,
    category: ShoppingCategory.speciality,
    rating: 4.9,
    averageRating: 4.9,
    reviewCount: 108,
    badges: [ProductTagType.bestSeller],
    manufacturer: '완도해산물',
    options: [
      ShoppingOption(name: '소형 (500g)', price: 69000),
      ShoppingOption(name: '중형 (1kg)', price: 120000),
      ShoppingOption(name: '대형 (2kg)', price: 220000),
    ],
  ),

  // 로컬상품 2
  ShoppingModel(
    id: 'shop_012',
    title: '담양 대나무 소품 세트',
    description: '담양 특산품 대나무로 만든 친환경 소품 세트',
    content:
        '''[{"insert":"담양 대나무 소품 세트"},{"attributes":{"header":1},"insert":"\\n"},{"insert":"\\n담양의 "},{"attributes":{"bold":true},"insert":"친환경 대나무"},{"insert":"로 만든 실용적이고 아름다운 소품 컬렉션입니다.\\n\\n"},{"insert":"🎋 "},{"attributes":{"bold":true},"insert":"제품 구성"},{"insert":"\\n• 대나무 컵 (2개)\\n• 대나무 수저 세트\\n• 대나무 도마\\n• 대나무 향꽂이\\n• 대나무 펜꽂이 (5종 세트)\\n\\n"},{"insert":"🌱 "},{"attributes":{"bold":true},"insert":"친환경 특징"},{"insert":"\\n• 100% 천연 대나무\\n• 무독성 천연 오일 마감\\n• 항균, 항곰팡이 효과\\n• 생분해 가능\\n\\n"},{"insert":"🎁 "},{"attributes":{"bold":true},"insert":"관리법"},{"insert":"\\n• 찬물 또는 미지근한 물 세척\\n• 자연 건조\\n• 직사광선 피해 보관\\n• 정기적 오일 발라주기"}]''',
    thumbnailUrl: 'assets/png/shopping.png',
    originalPrice: 42000,
    finalPrice: 38000,
    discountRate: 10,
    category: ShoppingCategory.local,
    rating: 4.6,
    averageRating: 4.6,
    reviewCount: 47,
    badges: [ProductTagType.almostSoldOut],
    manufacturer: '담양죽제품',
    options: [
      ShoppingOption(name: '소품 3종 세트', price: 38000),
      ShoppingOption(name: '소품 5종 세트', price: 58000),
    ],
  ),
];
