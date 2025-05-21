import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/payment/widgets/payment_product_section.dart';
import 'package:giftrip/features/payment/widgets/payment_orderer_section.dart';
import 'package:giftrip/features/payment/widgets/payment_shipping_section.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _ordererNameController = TextEditingController();
  final _ordererPhoneController = TextEditingController();
  final _shippingNameController = TextEditingController();
  final _shippingPhoneController = TextEditingController();
  final _shippingAddressController = TextEditingController();
  bool _isSameAsOrderer = false;
  bool _saveShippingInfo = false;

  @override
  void dispose() {
    _ordererNameController.dispose();
    _ordererPhoneController.dispose();
    _shippingNameController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  void _handleSameAsOrdererChanged(bool value) {
    setState(() {
      _isSameAsOrderer = value;
      if (value) {
        _shippingNameController.text = _ordererNameController.text;
        _shippingPhoneController.text = _ordererPhoneController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '결제하기',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, viewModel, child) {
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
                    onPressed: () {
                      // TODO: 재시도 로직 구현
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              // 상품 정보 섹션
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentProductSection(items: viewModel.items),
              ),
              const SectionDivider(),

              // 주문자 정보 섹션
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentOrdererSection(
                  nameController: _ordererNameController,
                  phoneController: _ordererPhoneController,
                ),
              ),
              const SectionDivider(),

              // 배송지 정보 섹션
              Padding(
                padding: const EdgeInsets.all(16),
                child: PaymentShippingSection(
                  nameController: _shippingNameController,
                  phoneController: _shippingPhoneController,
                  addressController: _shippingAddressController,
                  isSameAsOrderer: _isSameAsOrderer,
                  saveShippingInfo: _saveShippingInfo,
                  onSameAsOrdererChanged: _handleSameAsOrdererChanged,
                  onSaveShippingInfoChanged: (value) {
                    setState(() {
                      _saveShippingInfo = value;
                    });
                  },
                ),
              ),
              const SectionDivider(),

              // 결제 금액 정보
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPriceInfo(viewModel),
              ),
              const SectionDivider(),

              // 결제 버튼
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 결제 처리 로직 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '${formatPrice(viewModel.finalPrice)}원 결제하기',
                    style: title_S.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceInfo(PaymentViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          // 총 상품 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 상품 금액', style: body_M),
              Text(
                '${formatPrice(viewModel.totalProductPrice)}원',
                style: body_M.copyWith(color: AppColors.labelStrong),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 배송비
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('배송비', style: body_M),
              Text(
                '${formatPrice(viewModel.shippingFee)}원',
                style: body_M.copyWith(color: AppColors.labelStrong),
              ),
            ],
          ),
          const Divider(height: 24),
          // 최종 결제 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('최종 결제 금액', style: title_S),
              Text(
                '${formatPrice(viewModel.finalPrice)}원',
                style: title_S.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
