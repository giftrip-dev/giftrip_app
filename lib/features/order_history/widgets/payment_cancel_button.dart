import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/order_history/view_models/order_history_view_model.dart';

class PaymentCancelButton extends StatelessWidget {
  final OrderHistoryModel orderBooking;
  final CTAButtonSize size;

  const PaymentCancelButton({
    super.key,
    required this.orderBooking,
    this.size = CTAButtonSize.medium,
  });

  bool get isProduct =>
      orderBooking.items.first.category == ProductItemType.product;

  String get cancelType => isProduct ? '구매' : '예약';

  @override
  Widget build(BuildContext context) {
    return CTAButton(
      isEnabled: true,
      onPressed: () {
        bool isLoading = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => TwoButtonModal(
              title: '${cancelType}${cancelType == '구매' ? '를' : '을'} 취소하시나요?',
              desc: '취소 후에는 복구할 수 없습니다.',
              cancelText: '닫기',
              confirmText: '$cancelType 취소',
              isLoading: isLoading,
              onConfirm: () async {
                setState(() {
                  isLoading = true;
                });
                await context
                    .read<OrderHistoryViewModel>()
                    .handleCancel(context, orderBooking);
              },
            ),
          ),
        );
      },
      type: CTAButtonType.outline,
      size: size,
      text: '$cancelType 취소',
      textStyle: title_S.copyWith(color: AppColors.labelStrong),
    );
  }
}
