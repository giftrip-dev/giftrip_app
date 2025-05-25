import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/widgets/snack_bar/custom_snack_bar.dart';
import 'package:giftrip/features/payment/widgets/payment_method_section.dart';
import 'package:giftrip/features/payment/widgets/payment_user_section.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/payment/widgets/payment_orderer_section.dart';
import 'package:giftrip/features/payment/widgets/payment_point_section.dart';
import 'package:giftrip/features/payment/widgets/payment_price_info_section.dart';
import 'package:giftrip/features/payment/widgets/payment_product_section.dart';
import 'package:giftrip/features/payment/models/payment_success_model.dart';
import 'package:giftrip/features/payment/screens/payment_success_screen.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';

class ReservationPaymentScreen extends StatefulWidget {
  const ReservationPaymentScreen({super.key});
  @override
  State<ReservationPaymentScreen> createState() =>
      _ReservationPaymentScreenState();
}

class _ReservationPaymentScreenState extends State<ReservationPaymentScreen> {
  /* ───────── selector(id) ───────── */
  static const _methodSelector = 'methods';
  static const _agreementSelector = 'agreement';

  /* ───────── text controllers ───────── */
  final _ordererNameController = TextEditingController();
  final _ordererPhoneController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _pointController = TextEditingController();

  /* ───────── local state ───────── */
  int _usedPoint = 0;
  bool _isSameAsOrderer = false;

  /* ───────── Toss 객체 ───────── */
  late final PaymentWidget _paymentWidget;
  final _methodKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _paymentWidget = PaymentWidget(
      clientKey: 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm',
      customerKey: 'CUSTOMER_KEY', // TODO: prod 에선 실제 고객 키
    );
  }

  @override
  void dispose() {
    _ordererNameController.dispose();
    _ordererPhoneController.dispose();
    _userNameController.dispose();
    _userPhoneController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  /* ───────── helpers ───────── */
  void _updateAmount() {
    final vm = context.read<PaymentViewModel>();
    (_methodKey.currentState as dynamic)
        ?.updateAmount(vm.totalProductPrice - _usedPoint);
  }

  /* ───────── handlers ───────── */
  void _handlePointChanged(String v) {
    setState(() => _usedPoint = int.tryParse(v) ?? 0);
    _updateAmount();
  }

  void _handleUseAllPoint() {
    final vm = context.read<PaymentViewModel>();
    final max = vm.availablePoint > vm.totalProductPrice
        ? vm.totalProductPrice
        : vm.availablePoint;
    setState(() {
      _usedPoint = max;
      _pointController.text = max.toString();
    });
    _updateAmount();
  }

  void _handleSameAsOrderer(bool value) {
    setState(() {
      _isSameAsOrderer = value;
      if (value) {
        // 주문자 정보를 이용자 정보로 복사
        _userNameController.text = _ordererNameController.text;
        _userPhoneController.text = _ordererPhoneController.text;
      }
    });
  }

  /* ───────── 결제 요청 ───────── */
  Future<void> _processPayment(PaymentViewModel vm) async {
    if ([
      _ordererNameController,
      _ordererPhoneController,
      _userNameController,
      _userPhoneController,
    ].any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: '주문자 정보와 이용자 정보를 모두 입력해주세요.',
          icon: LucideIcons.info,
        ),
      );
      return;
    }

    final orderId = 'reservation_${DateTime.now().millisecondsSinceEpoch}';
    final orderName = vm.items.length > 1
        ? '${vm.items.first.title} 외 ${vm.items.length - 1}건'
        : vm.items.first.title;

    try {
      logger.d('예약 결제 요청: $orderId, $orderName');
      final res = await _paymentWidget.requestPayment(
        paymentInfo: PaymentInfo(
          orderId: orderId,
          orderName: orderName,
        ),
      );
      logger.d('예약 결제 응답: ${res.success}');
      if (res.success != null) {
        // 결제 성공 데이터 구성
        final paymentSuccessData = PaymentSuccessModel(
          orderId: orderId,
          orderName: orderName,
          items: vm.items
              .map((item) => PaymentSuccessItem(
                    title: item.title,
                    optionName: item.optionName,
                    quantity: item.quantity,
                    price: item.price,
                    type: item.type,
                  ))
              .toList(),
          paymentMethod: '카드결제',
          totalAmount: vm.totalProductPrice, // 예약은 배송비 없음
          usedPoint: _usedPoint,
          shippingFee: 0, // 예약은 배송비 없음
          paymentDate: DateTime.now(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              paymentData: paymentSuccessData,
            ),
          ),
        );
      } else {
        logger.e('예약 결제 실패: ${res.fail?.errorMessage ?? ''}');
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: '결제 실패: ${res.fail?.errorMessage ?? ''}',
            icon: LucideIcons.x,
          ),
        );
      }
    } catch (e) {
      logger.e('예약 결제 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: '결제 오류: $e',
          icon: LucideIcons.x,
        ),
      );
    }
  }

  /* ───────── UI ───────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '결제하기',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (vm.hasError)
            return Center(child: Text(vm.errorMessage ?? '로드 실패'));

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              /* ─── 예약 상품 정보 ─── */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentProductSection(items: vm.items),
              ),
              const SectionDivider(),

              /* ─── 주문자 정보 ─── */
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentOrdererSection(
                      nameController: _ordererNameController,
                      phoneController: _ordererPhoneController,
                    ),
                  ],
                ),
              ),
              const SectionDivider(),

              /* ─── 이용자 정보 ─── */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentUserSection(
                  nameController: _userNameController,
                  phoneController: _userPhoneController,
                  isSameAsOrderer: _isSameAsOrderer,
                  onSameAsOrdererChanged: _handleSameAsOrderer,
                ),
              ),
              const SectionDivider(),

              /* ─── 포인트 사용 ─── */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentPointSection(
                  pointController: _pointController,
                  availablePoint: vm.availablePoint,
                  totalPrice: vm.totalProductPrice,
                  onPointChanged: _handlePointChanged,
                  onUseAllPoint: _handleUseAllPoint,
                ),
              ),
              const SectionDivider(),

              /* ─── 결제수단+약관 ─── */
              PaymentMethodSection(
                key: _methodKey,
                paymentWidget: _paymentWidget,
                methodSelector: _methodSelector,
                agreementSelector: _agreementSelector,
              ),
              const SectionDivider(),

              /* ─── 결제 금액 정보 ─── */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentPriceInfoSection(
                  items: vm.items,
                  shippingFee: 0, // 예약은 배송비 없음
                  finalPrice: vm.totalProductPrice - _usedPoint,
                ),
              ),
              const SizedBox(height: 24),

              /* ─── 결제 버튼 ─── */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CTAButton(
                  onPressed: () => _processPayment(vm),
                  type: CTAButtonType.primary,
                  size: CTAButtonSize.large,
                  text: '결제하기',
                  isEnabled: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
