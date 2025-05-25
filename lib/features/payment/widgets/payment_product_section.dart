import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentProductSection extends StatelessWidget {
  final List<PaymentItem> items;

  const PaymentProductSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '예약 상품 (${items.length})',
          style: title_M,
        ),
        const SizedBox(height: 12),

        // 상품 목록 컨테이너
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...items.map((item) => _buildProductItem(item)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(PaymentItem item) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: item == items.last ? 0 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상품 썸네일
              CustomImage(
                imageUrl: item.thumbnailUrl,
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 12),
              // 상품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type == ProductItemType.product
                          ? '${item.title}, ${item.quantity}개'
                          : item.title,
                      style: body_S,
                    ),
                    const SizedBox(height: 4),
                    PriceText(
                      price: item.price,
                      color: AppColors.labelStrong,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 체험 상품일 때 날짜 정보 표시
          if (item.type == ProductItemType.experience) ...[
            const SizedBox(height: 12),
            _buildExperienceDateInfo(item),
          ],
        ],
      ),
    );
  }

  Widget _buildExperienceDateInfo(PaymentItem item) {
    // PaymentItem의 startDate와 endDate를 직접 사용
    final dateFormat = DateFormat('yyyy.MM.dd (E)', 'ko_KR');
    final startDateText =
        item.startDate != null ? dateFormat.format(item.startDate!) : '';
    final endDateText =
        item.endDate != null ? dateFormat.format(item.endDate!) : '';

    return Row(
      children: [
        // 이용 시작일
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundAlternative,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이용 시작일',
                  style: caption.copyWith(
                    color: AppColors.primaryStrong,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  startDateText,
                  style: subtitle_M.copyWith(
                    color: AppColors.labelStrong,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      LucideIcons.user,
                      size: 16,
                      color: AppColors.labelAlternative,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.quantity}명',
                      style: caption.copyWith(
                        color: AppColors.labelAlternative,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 이용 종료일
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundAlternative,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이용 종료일',
                  style: caption.copyWith(
                    color: AppColors.primaryStrong,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  endDateText,
                  style: subtitle_M.copyWith(
                    color: AppColors.labelStrong,
                  ),
                ),
                const SizedBox(height: 12),
                // 높이 맞추기 위한 빈 공간 (시작일 박스의 아이콘+텍스트 높이와 동일)
                SizedBox(
                  height: 16, // 아이콘 높이와 동일
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
