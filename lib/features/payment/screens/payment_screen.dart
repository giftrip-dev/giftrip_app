// lib/features/payment/pages/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/section_divider.dart';

import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/payment/widgets/payment_orderer_section.dart';
import 'package:giftrip/features/payment/widgets/payment_point_section.dart';
import 'package:giftrip/features/payment/widgets/payment_price_info_section.dart';
import 'package:giftrip/features/payment/widgets/payment_product_section.dart';
import 'package:giftrip/features/payment/widgets/payment_shipping_section.dart';

import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  /* ───────── selector(id) ───────── */
  static const _methodSel = 'payment-method';
  static const _agreeSel = 'agreement';

  /* ───────── controllers ───────── */
  final _ordererNameController = TextEditingController();
  final _ordererPhoneController = TextEditingController();
  final _shippingNameController = TextEditingController();
  final _shippingPhoneController = TextEditingController();
  final _shippingAddressController = TextEditingController();
  final _shippingDetailAddressController = TextEditingController();
  final _pointController = TextEditingController();

  bool _isSameAsOrderer = false;
  bool _saveShippingInfo = false;
  int _usedPoint = 0;

  late final PaymentWidget _paymentWidget;

  /* ───────── 렌더링 플래그 ───────── */
  final GlobalKey _methodBoxKey = GlobalKey();
  bool _renderStarted = false; // 렌더링 “착수” 여부
  bool _renderDone = false; // 렌더링 “완료” 여부 → 로딩 스피너 제어

  @override
  void initState() {
    super.initState();
    _paymentWidget = PaymentWidget(
      clientKey: 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm',
      customerKey: 'anonymous',
    );
  }

  /* ── 컨테이너가 생긴 뒤 한 번만 SDK 렌더 ── */
  Future<void> _tryRenderWidgets() async {
    if (_renderStarted) return; // 이미 시도 중/완료
    if (_methodBoxKey.currentContext == null) return; // 컨테이너 아직 없음

    _renderStarted = true; // ★ 시도 플래그 ON
    final vm = context.read<PaymentViewModel>();

    await _paymentWidget.renderPaymentMethods(
      selector: _methodSel,
      amount: Amount(value: vm.finalPrice, currency: Currency.KRW),
    );
    await _paymentWidget.renderAgreement(selector: _agreeSel);

    if (mounted) setState(() => _renderDone = true); // 로딩 OFF
  }

  @override
  void dispose() {
    _ordererNameController.dispose();
    _ordererPhoneController.dispose();
    _shippingNameController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddressController.dispose();
    _shippingDetailAddressController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  /* ───────── UI 헬퍼 ───────── */
  void _handleSameAsOrdererChanged(bool v) {
    setState(() {
      _isSameAsOrderer = v;
      if (v) {
        _shippingNameController.text = _ordererNameController.text;
        _shippingPhoneController.text = _ordererPhoneController.text;
      }
    });
  }

  void _handlePointChanged(String v) =>
      setState(() => _usedPoint = int.tryParse(v) ?? 0);

  void _handleUseAllPoint() {
    final vm = context.read<PaymentViewModel>();
    setState(() {
      _usedPoint = vm.availablePoint > vm.totalProductPrice
          ? vm.totalProductPrice
          : vm.availablePoint;
      _pointController.text = _usedPoint.toString();
    });
  }

  Future<void> _processPayment(PaymentViewModel vm) async {
    if (_ordererNameController.text.isEmpty ||
        _ordererPhoneController.text.isEmpty ||
        _shippingNameController.text.isEmpty ||
        _shippingPhoneController.text.isEmpty ||
        _shippingAddressController.text.isEmpty ||
        _shippingDetailAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 필수 정보를 입력해주세요.'),
          backgroundColor: AppColors.statusError,
        ),
      );
      return;
    }

    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final orderName = vm.items.length > 1
        ? '${vm.items.first.title} 외 ${vm.items.length - 1}건'
        : vm.items.first.title;

    try {
      final result = await _paymentWidget.requestPayment(
        paymentInfo: PaymentInfo(orderId: orderId, orderName: orderName),
      );
      logger.i('result: $result');

      if (result.success != null) {
        Navigator.pop(context); // 결제 성공
      } else {
        logger.i('result.fail: ${result.fail}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('결제 실패: ${result.fail?.errorMessage}')),
        );
      }
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 오류: $e')),
      );
    }
  }

  /* ───────── UI ───────── */
  @override
  Widget build(BuildContext context) {
    // 매 프레임마다 한 번씩 컨테이너 존재 확인 → 첫 성공 시 렌더
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryRenderWidgets());

    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '결제하기',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (vm.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vm.errorMessage ?? '결제 정보를 불러오는데 실패했습니다.',
                    style: body_M.copyWith(color: AppColors.statusError),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: const Text('다시 시도')),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              /* 상품 정보 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentProductSection(items: vm.items),
              ),
              const SectionDivider(),

              /* 주문자 정보 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentOrdererSection(
                  nameController: _ordererNameController,
                  phoneController: _ordererPhoneController,
                ),
              ),
              const SectionDivider(),

              /* 배송지 정보 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentShippingSection(
                  nameController: _shippingNameController,
                  phoneController: _shippingPhoneController,
                  addressController: _shippingAddressController,
                  detailAddressController: _shippingDetailAddressController,
                  isSameAsOrderer: _isSameAsOrderer,
                  saveShippingInfo: _saveShippingInfo,
                  onSameAsOrdererChanged: _handleSameAsOrdererChanged,
                  onSaveShippingInfoChanged: (v) =>
                      setState(() => _saveShippingInfo = v),
                ),
              ),
              const SectionDivider(),

              /* 포인트 사용 */
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

              /* 결제 금액 정보 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentPriceInfoSection(
                  totalProductPrice: vm.totalProductPrice,
                  shippingFee: vm.shippingFee,
                  finalPrice: vm.finalPrice,
                ),
              ),
              const SectionDivider(),

              /* 결제 수단 위젯 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  key: _methodBoxKey,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PaymentMethodWidget(
                        paymentWidget: _paymentWidget,
                        selector: _methodSel,
                      ),
                      if (!_renderDone) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              const SectionDivider(),

              /* 약관 동의 위젯 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AgreementWidget(
                        paymentWidget: _paymentWidget,
                        selector: _agreeSel,
                      ),
                      if (!_renderDone) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              const SectionDivider(),

              /* 결제 버튼 */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CTAButton(
                  onPressed: () => _processPayment(vm),
                  type: CTAButtonType.primary,
                  size: CTAButtonSize.large,
                  text: '${formatPrice(vm.finalPrice)}원 결제하기',
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
