import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/payment/models/payment_success_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final PaymentSuccessModel paymentData;

  const PaymentSuccessScreen({
    super.key,
    required this.paymentData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEBF6FF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFE9EDFF),
            ],
            stops: [0.1, 0.3, 0.3, 1.5],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 140),
                child: Column(
                  children: [
                    SizedBox(height: 80),

                    // 결제 완료 헤더
                    _buildSuccessHeader(),
                    SizedBox(height: 40),

                    // 상품 정보
                    _buildProductInfo(),

                    // 결제 정보
                    _buildPaymentInfo(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: _buildBottomButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 결제 완료 헤더
  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/webp/icons/check.webp',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            paymentData.completionTitle,
            style: h1_M.copyWith(color: AppColors.label),
          ),
          const SizedBox(height: 12),
          Text(
            paymentData.completionSubtitle,
            style: body_M.copyWith(color: AppColors.label),
          ),
        ],
      ),
    );
  }

  /// 상품 정보
  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주문 상품',
            style: body_M.copyWith(color: AppColors.label),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ...paymentData.items.map((item) => Padding(
                      padding: EdgeInsets.only(
                          bottom: item != paymentData.items.last ? 12 : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: body_M.copyWith(color: AppColors.label),
                            ),
                          ),
                          Text(
                            '${item.quantity}개',
                            style: body_M.copyWith(
                                color: AppColors.labelAlternative),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 결제 정보
  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('결제 수단', paymentData.paymentMethod),
          const SizedBox(height: 14),
          _buildInfoRow('결제 금액',
              '${formatPrice(paymentData.productAmount + paymentData.shippingFee)}원',
              valueStyle: subtitle_M.copyWith(color: AppColors.label)),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  /// 정보 행 위젯
  Widget _buildInfoRow(
    String label,
    String value, {
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: body_M.copyWith(color: AppColors.label),
        ),
        Text(
          value,
          style: valueStyle ?? body_M.copyWith(color: AppColors.label),
        ),
      ],
    );
  }

  /// 하단 버튼들
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: CTAButton(
              isEnabled: true,
              onPressed: () {
                Navigator.pop(context);
              },
              type: CTAButtonType.whiteFill,
              size: CTAButtonSize.extraLarge,
              text: '홈으로 가기',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CTAButton(
              isEnabled: true,
              onPressed: () {
                // 홈으로 이동
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              type: CTAButtonType.primary,
              size: CTAButtonSize.large,
              text: '주문 상세 보기',
            ),
          ),
        ],
      ),
    );
  }
}
