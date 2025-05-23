import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';

class PaymentOrdererSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const PaymentOrdererSection({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

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
          '주문자 정보',
          style: title_M,
        ),
        const SizedBox(height: 20),

        // 이름 필드
        Text(
          '이름',
          style: title_S,
        ),
        const SizedBox(height: 12),
        CustomInputField(
          controller: nameController,
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
          controller: phoneController,
          placeholder: '연락처',
          keyboardType: TextInputType.phone,
          style: CustomInputFieldStyle.bottomBorder,
          onChanged: (value) {
            final formattedValue = _formatPhoneNumber(value);
            if (value != formattedValue) {
              phoneController.value = TextEditingValue(
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
