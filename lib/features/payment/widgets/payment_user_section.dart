import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/checkbox/custom_checkbox.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';

class PaymentUserSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isSameAsOrderer;
  final Function(bool) onSameAsOrdererChanged;

  const PaymentUserSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.isSameAsOrderer,
    required this.onSameAsOrdererChanged,
  });

  @override
  State<PaymentUserSection> createState() => _PaymentUserSectionState();
}

class _PaymentUserSectionState extends State<PaymentUserSection> {
  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(_checkIfDifferentFromOrderer);
    widget.phoneController.addListener(_checkIfDifferentFromOrderer);
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_checkIfDifferentFromOrderer);
    widget.phoneController.removeListener(_checkIfDifferentFromOrderer);
    super.dispose();
  }

  void _checkIfDifferentFromOrderer() {
    if (widget.isSameAsOrderer) {
      // 주문자와 동일이 체크되어 있는 상태에서 이용자 정보가 변경되면
      // 체크박스를 해제
      widget.onSameAsOrdererChanged(false);
    }
  }

  String _formatPhoneNumber(String value) {
    value = value.replaceAll('-', '');
    if (value.length > 11) return value.substring(0, 11);

    if (value.length >= 8) {
      return '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7)}';
    } else if (value.length >= 4) {
      return '${value.substring(0, 3)}-${value.substring(3)}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '이용자 정보',
          style: title_M,
        ),
        const SizedBox(height: 20),

        // 체크박스 영역
        CustomCheckbox(
          value: widget.isSameAsOrderer,
          onChanged: widget.onSameAsOrdererChanged,
          label: '주문자와 동일',
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
          onChanged: (value) {
            final formattedValue = _formatPhoneNumber(value);
            if (value != formattedValue) {
              widget.phoneController.value = TextEditingValue(
                text: formattedValue,
                selection:
                    TextSelection.collapsed(offset: formattedValue.length),
              );
            }
          },
        ),
      ],
    );
  }
}
