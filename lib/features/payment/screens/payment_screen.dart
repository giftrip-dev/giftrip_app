import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
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
  static const String _paymentMethodSelector = '#payment-method';
  static const String _agreementSelector = '#agreement';

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

  // 주소 검색 모달이 열렸는지 여부를 추적
  bool _isAddressSearchActive = false;

  late final PaymentWidget _paymentWidget;
  bool _uiReady = false;

  @override
  void initState() {
    super.initState();

    // Toss Payments 위젯 초기화
    _paymentWidget = PaymentWidget(
      clientKey: 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm',
      customerKey: 'CUSTOMER_KEY', // TODO: 실제 고객 키로 교체
    );

    // 위젯 렌더링을 위해 WidgetsBinding 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 첫 프레임 렌더링 후 초기화
      _initTossPaymentWidgets();
    });
  }

  // 토스 결제 위젯 초기화 함수 분리
  Future<void> _initTossPaymentWidgets() async {
    if (!mounted) return;

    // 주소 검색 모달이 열려있는 경우 초기화 건너뛰기
    if (_isAddressSearchActive) {
      print('주소 검색 활성화 상태: 토스 위젯 초기화 건너뜀');
      return;
    }

    final viewModel = context.read<PaymentViewModel>();

    try {
      print('토스 결제 위젯 초기화 시작: ${DateTime.now()}');
      print('결제 금액: ${viewModel.finalPrice - _usedPoint}원');
      print('결제 방법 셀렉터: $_paymentMethodSelector');

      // UI 상태 먼저 초기화 (로딩 표시)
      setState(() => _uiReady = false);

      // 약간의 지연 후 렌더링 시도
      await Future.delayed(const Duration(milliseconds: 300));

      await _paymentWidget.renderPaymentMethods(
        selector: _paymentMethodSelector,
        amount: Amount(
          value: viewModel.finalPrice - _usedPoint,
          currency: Currency.KRW,
        ),
      );

      print('결제 방법 위젯 렌더링 완료');

      // 약간의 지연 후 약관 렌더링 시도
      await Future.delayed(const Duration(milliseconds: 300));

      await _paymentWidget.renderAgreement(
        selector: _agreementSelector,
      );

      print('동의 위젯 렌더링 완료');

      // UI 표시
      if (mounted) setState(() => _uiReady = true);
      print('토스 결제 위젯 초기화 성공: ${DateTime.now()}');
    } catch (e) {
      print('토스 위젯 초기화 오류: $e');
      print('스택 트레이스: ${StackTrace.current}');

      // UI 상태 업데이트 (에러 발생해도 로딩 표시 해제)
      if (mounted) setState(() => _uiReady = false);

      // 오류 발생 시 잠시 후 재시도
      if (mounted) {
        Future.delayed(const Duration(seconds: 3), () {
          print('토스 위젯 초기화 재시도');
          _initTossPaymentWidgets();
        });
      }
    }
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
  void _handleSameAsOrdererChanged(bool value) {
    setState(() {
      _isSameAsOrderer = value;
      if (value) {
        _shippingNameController.text = _ordererNameController.text;
        _shippingPhoneController.text = _ordererPhoneController.text;
      }
    });
  }

  void _handlePointChanged(String value) {
    setState(() {
      _usedPoint = int.tryParse(value) ?? 0;
    });

    // 포인트 금액이 변경되면 결제 위젯 업데이트
    _updatePaymentAmount();
  }

  // 결제 금액 업데이트 함수 추가
  void _updatePaymentAmount() {
    if (_uiReady) {
      final viewModel = context.read<PaymentViewModel>();

      // 위젯을 다시 렌더링 (updateAmount 메서드가 없으므로)
      _paymentWidget.renderPaymentMethods(
        selector: _paymentMethodSelector,
        amount: Amount(
          value: viewModel.finalPrice - _usedPoint,
          currency: Currency.KRW,
        ),
      );
    }
  }

  void _handleUseAllPoint() {
    final viewModel = context.read<PaymentViewModel>();
    final availablePoint = viewModel.availablePoint;
    final totalPrice = viewModel.totalProductPrice;

    setState(() {
      _usedPoint = availablePoint > totalPrice ? totalPrice : availablePoint;
      _pointController.text = _usedPoint.toString();
    });

    // 전액 사용 시 금액 업데이트
    _updatePaymentAmount();
  }

  // 주소 검색 시작 시 호출
  void _onAddressSearchStart() {
    setState(() {
      _isAddressSearchActive = true;
      _uiReady = false; // 토스 위젯 UI 숨기기
    });
  }

  // 주소 검색 완료 시 호출
  void _onAddressSearchComplete() {
    setState(() {
      _isAddressSearchActive = false;
    });

    // 주소 검색 후 토스 위젯 다시 초기화
    Future.delayed(const Duration(seconds: 1), () {
      _initTossPaymentWidgets();
    });
  }

  Future<void> _processPayment(PaymentViewModel viewModel) async {
    // 필수 입력 검증
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
    final orderName = viewModel.items.length > 1
        ? "${viewModel.items.first.title} 외 ${viewModel.items.length - 1}건"
        : viewModel.items.first.title;

    try {
      final result = await _paymentWidget.requestPayment(
        paymentInfo: PaymentInfo(
          orderId: orderId,
          orderName: orderName,
          customerName: _ordererNameController.text,
          customerEmail: '',
          customerMobilePhone: _ordererPhoneController.text,
        ),
      );

      if (result.success != null) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('결제 실패: ${result.fail?.errorMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 오류: $e')),
      );
    }
  }

  /* ───────── UI ───────── */
  @override
  Widget build(BuildContext context) {
    // 매 프레임마다 토스 위젯 초기화 시도
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_uiReady && !_isAddressSearchActive && mounted) {
        _initTossPaymentWidgets();
      }
    });

    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '결제하기',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage ?? '결제 정보를 불러오는데 실패했습니다.',
                    style: body_M.copyWith(color: AppColors.statusError),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    // onPressed: viewModel.retryFetch,
                    onPressed: () {},
                    child: const Text('다시 시도'),
                  ),
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
                child: PaymentProductSection(items: viewModel.items),
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
                  onAddressSearchStart: _onAddressSearchStart,
                  onAddressSearchComplete: _onAddressSearchComplete,
                ),
              ),
              const SectionDivider(),

              /* 포인트 사용 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentPointSection(
                  pointController: _pointController,
                  availablePoint: viewModel.availablePoint,
                  totalPrice: viewModel.totalProductPrice,
                  onPointChanged: _handlePointChanged,
                  onUseAllPoint: _handleUseAllPoint,
                ),
              ),
              const SectionDivider(),

              /* 결제 금액 정보 */
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentPriceInfoSection(
                  totalProductPrice: viewModel.totalProductPrice,
                  shippingFee: viewModel.shippingFee,
                  finalPrice: viewModel.finalPrice - _usedPoint,
                ),
              ),
              const SectionDivider(),

              /* 결제 수단 위젯 */
              Visibility(
                visible: !_isAddressSearchActive, // 주소 검색 중에는 숨김
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 180,
                    key: UniqueKey(),
                    child: Visibility(
                      visible: _uiReady,
                      child: PaymentMethodWidget(
                        paymentWidget: _paymentWidget,
                        selector: _paymentMethodSelector,
                      ),
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
              const SectionDivider(),

              /* 약관 동의 위젯 */
              Visibility(
                visible: !_isAddressSearchActive, // 주소 검색 중에는 숨김
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 120,
                    key: UniqueKey(),
                    child: Visibility(
                      visible: _uiReady,
                      child: AgreementWidget(
                        paymentWidget: _paymentWidget,
                        selector: _agreementSelector,
                      ),
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
              const SectionDivider(),

              /* 결제 버튼 */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CTAButton(
                  onPressed: () => _processPayment(viewModel),
                  type: CTAButtonType.primary,
                  size: CTAButtonSize.large,
                  text:
                      '${formatPrice(viewModel.finalPrice - _usedPoint)}원 결제하기',
                  isEnabled: _uiReady && !_isAddressSearchActive,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
