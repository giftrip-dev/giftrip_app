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
