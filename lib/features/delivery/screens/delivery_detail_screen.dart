import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/delivery/models/delivery_detail_model.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/repositories/delivery_repo.dart';
import 'package:giftrip/features/delivery/widgets/delivery_info_container.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:intl/intl.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final String deliveryId;

  const DeliveryDetailScreen({
    super.key,
    required this.deliveryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '배송 상세'),
      body: FutureBuilder<DeliveryDetailModel>(
        future: DeliveryRepo().getDeliveryDetail(deliveryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('데이터를 불러오는데 실패했습니다.'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('데이터가 없습니다.'),
            );
          }

          final delivery = snapshot.data!;
          final formatter = NumberFormat('#,###');

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeliveryInfoContainer(
                    title: '배송 정보',
                    items: [
                      DeliveryInfoItem(
                        label: '배송 번호',
                        value: delivery.deliveryNumber,
                      ),
                      DeliveryInfoItem(
                        label: '배송 상태',
                        value: delivery.deliveryStatus.label,
                      ),
                      DeliveryInfoItem(
                        label: '상품',
                        value: delivery.product,
                      ),
                      DeliveryInfoItem(
                        label: '배송비',
                        value: '${formatter.format(delivery.shippingFee)}원',
                      ),
                      DeliveryInfoItem(
                        label: '송장 번호',
                        value: delivery.invoiceNumber,
                      ),
                    ],
                    onTextTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TwoButtonModal(
                          title: '배송에 문제가 있으신가요?',
                          desc: '카카오톡 플러스 친구를 통해\n관리자에게 문의해주세요.',
                          cancelText: '닫기',
                          confirmText: '1:1 문의하기',
                          onConfirm: () => Navigator.of(context).pop(),
                        ),
                      );
                    },
                    tapText: '배송에 문제가 있으신가요?',
                  ),
                  const SizedBox(height: 24),
                  // 주문자 정보
                  DeliveryInfoContainer(
                    title: '주문자 정보',
                    items: [
                      DeliveryInfoItem(
                        label: '이름',
                        value: delivery.ordererName,
                      ),
                      DeliveryInfoItem(
                        label: '연락처',
                        value: delivery.deliveryStatus.label,
                      ),
                      DeliveryInfoItem(
                        label: '이메일',
                        value: delivery.ordererEmail,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DeliveryInfoContainer(
                    title: '배송지 정보',
                    items: [
                      DeliveryInfoItem(
                        label: '이름',
                        value: delivery.recipientName,
                      ),
                      DeliveryInfoItem(
                        label: '연락처',
                        value: delivery.recipientPhone,
                      ),
                      DeliveryInfoItem(
                        label: '이메일',
                        value: delivery.address,
                      ),
                    ],
                    bottomButton: delivery.deliveryStatus ==
                            DeliveryStatus.preparing
                        ? CTAButton(
                            text: '배송지 수정하기',
                            onPressed: () {},
                            isEnabled: true,
                            type: CTAButtonType.outline,
                            size: CTAButtonSize.medium,
                            textStyle:
                                title_S.copyWith(color: AppColors.labelStrong),
                          )
                        : null,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
