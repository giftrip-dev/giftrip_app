import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/checkbox/custom_checkbox.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/features/payment/widgets/shipping_address_input.dart';

class PaymentShippingSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController detailAddressController;
  final bool isSameAsOrderer;
  final bool saveShippingInfo;
  final Function(bool) onSameAsOrdererChanged;
  final Function(bool) onSaveShippingInfoChanged;
  final VoidCallback? onAddressSearchStart;
  final VoidCallback? onAddressSearchComplete;

  const PaymentShippingSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.detailAddressController,
    required this.isSameAsOrderer,
    required this.saveShippingInfo,
    required this.onSameAsOrdererChanged,
    required this.onSaveShippingInfoChanged,
    this.onAddressSearchStart,
    this.onAddressSearchComplete,
  });

  @override
  State<PaymentShippingSection> createState() => _PaymentShippingSectionState();
}

class _PaymentShippingSectionState extends State<PaymentShippingSection> {
  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(_checkIfDifferentFromOrderer);
    widget.phoneController.addListener(_checkIfDifferentFromOrderer);
    widget.addressController.addListener(_checkIfDifferentFromOrderer);
    widget.detailAddressController.addListener(_checkIfDifferentFromOrderer);
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_checkIfDifferentFromOrderer);
    widget.phoneController.removeListener(_checkIfDifferentFromOrderer);
    widget.addressController.removeListener(_checkIfDifferentFromOrderer);
    widget.detailAddressController.removeListener(_checkIfDifferentFromOrderer);
    super.dispose();
  }

  void _checkIfDifferentFromOrderer() {
    if (widget.isSameAsOrderer) {
      // 주문자와 동일이 체크되어 있는 상태에서 배송지 정보가 변경되면
      // 체크박스를 해제
      widget.onSameAsOrdererChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '배송지 정보',
          style: title_M,
        ),
        const SizedBox(height: 20),

        // 체크박스 영역
        Row(
          children: [
            // 주문자와 동일 체크박스
            CustomCheckbox(
              value: widget.isSameAsOrderer,
              onChanged: widget.onSameAsOrdererChanged,
              label: '주문자와 동일',
            ),
            const SizedBox(width: 24),
            // 배송지 정보 저장 체크박스
            CustomCheckbox(
              value: widget.saveShippingInfo,
              onChanged: widget.onSaveShippingInfoChanged,
              label: '배송지 정보 저장',
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 이름 필드
        Text(
          '이름',
          style: title_S,
        ),
        const SizedBox(height: 12),
        CustomInputField(
          controller: widget.nameController,
          placeholder: '이름',
          style: CustomInputFieldStyle.bottomBorder,
        ),
        const SizedBox(height: 16),

        // 연락처 필드
        Text(
          '연락처',
          style: title_S,
        ),
        const SizedBox(height: 12),
        CustomInputField(
          controller: widget.phoneController,
          placeholder: '연락처',
          keyboardType: TextInputType.phone,
          style: CustomInputFieldStyle.bottomBorder,
        ),
        const SizedBox(height: 16),

        // 배송지 필드
        Text(
          '배송지',
          style: title_S,
        ),
        const SizedBox(height: 12),
        ShippingAddressInput(
          addressController: widget.addressController,
          detailAddressController: widget.detailAddressController,
          onAddressSearchStart: widget.onAddressSearchStart,
          onAddressSearchComplete: widget.onAddressSearchComplete,
        ),
      ],
    );
  }
}
