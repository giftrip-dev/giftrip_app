import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'dart:math';

final random = Random();

/// 목업 구매 내역 데이터
final List<OrderBookingModel> mockOrderBookingList = () {
  final now = DateTime.now();
  final orders = <OrderBookingModel>[];

  // 쇼핑 상품들 가져오기
  final shoppingProducts =
      mockProducts.where((p) => p.productType == ProductType.product).toList();

  // 체험/체험단/숙소 상품들 가져오기 (mockProducts에서)
  final experienceProducts = mockProducts
      .where((p) => p.productType == ProductType.experience)
      .take(3)
      .toList();
  final lodgingProducts = mockProducts
      .where((p) => p.productType == ProductType.lodging)
      .take(3)
      .toList();
  final testerProducts = mockProducts
      .where((p) => p.productType == ProductType.experienceGroup)
      .take(2)
      .toList();

  // 1. 단일 상품 주문들
  // 쇼핑 상품 단일 주문 2개
  for (int i = 0; i < 2; i++) {
    final product = shoppingProducts[i];
    final item = OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_1',
      productId: product.id,
      title: product.title,
      thumbnailUrl: product.thumbnailUrl,
      originalPrice: product.originalPrice,
      finalPrice: product.finalPrice,
      discountRate: product.discountRate,
      category: ProductItemType.product,
      quantity: i + 1,
    );

    orders.add(OrderBookingModel(
      id: 'order_${orders.length + 1}',
      orderName: product.title,
      items: [item],
      totalAmount: item.totalPrice,
      progress: OrderBookingProgress.values[i % 3],
      paidAt: now.subtract(Duration(days: i + 1)),
    ));
  }

  // 체험 상품 단일 주문 2개
  for (int i = 0; i < 2; i++) {
    final product = experienceProducts[i];
    final item = OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_1',
      productId: product.id,
      title: product.title,
      thumbnailUrl: product.thumbnailUrl,
      originalPrice: product.originalPrice,
      finalPrice: product.finalPrice,
      discountRate: product.discountRate,
      category: ProductItemType.experience,
      quantity: 1,
    );

    orders.add(OrderBookingModel(
      id: 'order_${orders.length + 1}',
      orderName: product.title,
      items: [item],
      totalAmount: item.totalPrice,
      progress: OrderBookingProgress.values[i % 3],
      paidAt: now.subtract(Duration(days: i + 3)),
    ));
  }

  // 숙소 상품 단일 주문 1개
  final lodgingProduct = lodgingProducts[0];
  final lodgingItem = OrderHistoryItemModel(
    id: 'item_${orders.length + 1}_1',
    productId: lodgingProduct.id,
    title: lodgingProduct.title,
    thumbnailUrl: lodgingProduct.thumbnailUrl,
    originalPrice: lodgingProduct.originalPrice,
    finalPrice: lodgingProduct.finalPrice,
    discountRate: lodgingProduct.discountRate,
    category: ProductItemType.lodging,
    quantity: 1,
  );

  orders.add(OrderBookingModel(
    id: 'order_${orders.length + 1}',
    orderName: lodgingProduct.title,
    items: [lodgingItem],
    totalAmount: lodgingItem.totalPrice,
    progress: OrderBookingProgress.confirmed,
    paidAt: now.subtract(Duration(days: 5)),
  ));

  // 2. 공동구매 주문들 (숙소+체험)
  final mixedItems1 = [
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_1',
      productId: lodgingProducts[1].id,
      title: lodgingProducts[1].title,
      thumbnailUrl: lodgingProducts[1].thumbnailUrl,
      originalPrice: lodgingProducts[1].originalPrice,
      finalPrice: lodgingProducts[1].finalPrice,
      discountRate: lodgingProducts[1].discountRate,
      category: ProductItemType.lodging,
      quantity: 1,
    ),
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_2',
      productId: experienceProducts[2].id,
      title: experienceProducts[2].title,
      thumbnailUrl: experienceProducts[2].thumbnailUrl,
      originalPrice: experienceProducts[2].originalPrice,
      finalPrice: experienceProducts[2].finalPrice,
      discountRate: experienceProducts[2].discountRate,
      category: ProductItemType.experience,
      quantity: 2,
    ),
  ];

  orders.add(OrderBookingModel(
    id: 'order_${orders.length + 1}',
    orderName: '${mixedItems1[0].title} 외 1개',
    items: mixedItems1,
    totalAmount: mixedItems1.fold(0, (sum, item) => sum + item.totalPrice),
    progress: OrderBookingProgress.completed,
    paidAt: now.subtract(Duration(days: 7)),
  ));

  // 3. 쇼핑 상품 다중 주문
  final shoppingItems = [
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_1',
      productId: shoppingProducts[2].id,
      title: shoppingProducts[2].title,
      thumbnailUrl: shoppingProducts[2].thumbnailUrl,
      originalPrice: shoppingProducts[2].originalPrice,
      finalPrice: shoppingProducts[2].finalPrice,
      discountRate: shoppingProducts[2].discountRate,
      category: ProductItemType.product,
      quantity: 1,
    ),
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_2',
      productId: shoppingProducts[3].id,
      title: shoppingProducts[3].title,
      thumbnailUrl: shoppingProducts[3].thumbnailUrl,
      originalPrice: shoppingProducts[3].originalPrice,
      finalPrice: shoppingProducts[3].finalPrice,
      discountRate: shoppingProducts[3].discountRate,
      category: ProductItemType.product,
      quantity: 2,
    ),
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_3',
      productId: shoppingProducts[4].id,
      title: shoppingProducts[4].title,
      thumbnailUrl: shoppingProducts[4].thumbnailUrl,
      originalPrice: shoppingProducts[4].originalPrice,
      finalPrice: shoppingProducts[4].finalPrice,
      discountRate: shoppingProducts[4].discountRate,
      category: ProductItemType.product,
      quantity: 1,
    ),
  ];

  orders.add(OrderBookingModel(
    id: 'order_${orders.length + 1}',
    orderName: '${shoppingItems[0].title} 외 2개',
    items: shoppingItems,
    totalAmount: shoppingItems.fold(0, (sum, item) => sum + item.totalPrice),
    progress: OrderBookingProgress.confirmed,
    paidAt: now.subtract(Duration(days: 10)),
  ));

  // 4. 체험단 + 체험 공동구매
  final testerMixItems = [
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_1',
      productId: testerProducts[0].id,
      title: testerProducts[0].title,
      thumbnailUrl: testerProducts[0].thumbnailUrl,
      originalPrice: testerProducts[0].originalPrice,
      finalPrice: testerProducts[0].finalPrice,
      discountRate: testerProducts[0].discountRate,
      category: ProductItemType.experienceGroup,
      quantity: 1,
    ),
    OrderHistoryItemModel(
      id: 'item_${orders.length + 1}_2',
      productId: experienceProducts[1].id,
      title: experienceProducts[1].title,
      thumbnailUrl: experienceProducts[1].thumbnailUrl,
      originalPrice: experienceProducts[1].originalPrice,
      finalPrice: experienceProducts[1].finalPrice,
      discountRate: experienceProducts[1].discountRate,
      category: ProductItemType.experience,
      quantity: 1,
    ),
  ];

  orders.add(OrderBookingModel(
    id: 'order_${orders.length + 1}',
    orderName: '${testerMixItems[0].title} 외 1개',
    items: testerMixItems,
    totalAmount: testerMixItems.fold(0, (sum, item) => sum + item.totalPrice),
    progress: OrderBookingProgress.canceled,
    paidAt: now.subtract(Duration(days: 15)),
  ));

  // 5. 체험단 단일 주문
  final testerItem = OrderHistoryItemModel(
    id: 'item_${orders.length + 1}_1',
    productId: testerProducts[1].id,
    title: testerProducts[1].title,
    thumbnailUrl: testerProducts[1].thumbnailUrl,
    originalPrice: testerProducts[1].originalPrice,
    finalPrice: testerProducts[1].finalPrice,
    discountRate: testerProducts[1].discountRate,
    category: ProductItemType.experienceGroup,
    quantity: 1,
  );

  orders.add(OrderBookingModel(
    id: 'order_${orders.length + 1}',
    orderName: testerItem.title,
    items: [testerItem],
    totalAmount: testerItem.totalPrice,
    progress: OrderBookingProgress.completed,
    paidAt: now.subtract(Duration(days: 20)),
  ));

  return orders;
}();
