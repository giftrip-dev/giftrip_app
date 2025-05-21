import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';

class ShippingAddressInput extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController detailAddressController;

  const ShippingAddressInput({
    super.key,
    required this.addressController,
    required this.detailAddressController,
  });

  @override
  State<ShippingAddressInput> createState() => _ShippingAddressInputState();
}

class _ShippingAddressInputState extends State<ShippingAddressInput> {
  bool _isError = false;
  String? _errorMessage;

  Future<void> _searchAddress() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: BackButtonAppBar(
              type: BackButtonAppBarType.textCenter,
              title: '주소 검색',
            ),
            body: Column(
              children: [
                Expanded(
                  child: DaumPostcodeSearch(
                    onConsoleMessage: (_, message) => print(message),
                    onReceivedError: (controller, uri, errorCode) {
                      setState(() {
                        _isError = true;
                        _errorMessage = '주소 검색 중 오류가 발생했습니다.';
                      });
                    },
                  ),
                ),
                if (_isError)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(_errorMessage ?? ''),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isError = false;
                            _errorMessage = null;
                          });
                        },
                        child: const Text('새로고침'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );

      if (result != null && result is DataModel) {
        // 주소 검색 결과를 컨트롤러에 설정
        widget.addressController.text = result.address;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('주소 검색 중 오류가 발생했습니다.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주소 검색 버튼
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                controller: widget.addressController,
                placeholder: '기본 주소',
                enabled: false,
                style: CustomInputFieldStyle.bottomBorder,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: CTAButton(
                onPressed: _searchAddress,
                type: CTAButtonType.outline,
                size: CTAButtonSize.large,
                text: '주소 찾기',
                isEnabled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 상세 주소 입력 필드
        CustomInputField(
          controller: widget.detailAddressController,
          placeholder: '상세 주소',
          style: CustomInputFieldStyle.bottomBorder,
        ),
      ],
    );
  }
}
