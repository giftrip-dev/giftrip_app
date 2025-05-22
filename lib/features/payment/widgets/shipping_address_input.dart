import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';

class ShippingAddressInput extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController detailAddressController;
  final VoidCallback? onAddressSearchStart;
  final VoidCallback? onAddressSearchComplete;

  const ShippingAddressInput({
    super.key,
    required this.addressController,
    required this.detailAddressController,
    this.onAddressSearchStart,
    this.onAddressSearchComplete,
  });

  @override
  State<ShippingAddressInput> createState() => _ShippingAddressInputState();
}

class _ShippingAddressInputState extends State<ShippingAddressInput> {
  bool _isError = false;
  String? _errorMessage;

  void _searchAddress(BuildContext context) async {
    // 주소 검색 시작 콜백 호출
    widget.onAddressSearchStart?.call();

    try {
      // Daum 주소 검색 모달 열기
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: const BackButtonAppBar(
              type: BackButtonAppBarType.textCenter,
              title: '주소 검색',
            ),
            body: Column(
              children: [
                Expanded(
                  child: DaumPostcodeSearch(
                    onConsoleMessage: (controller, message) {
                      debugPrint('Console: $message');
                    },
                  ),
                ),
                if (_isError)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(_errorMessage ?? ''),
                        const SizedBox(height: 8),
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
                  ),
              ],
            ),
          ),
        ),
      );

      // 사용자가 주소를 선택한 경우
      if (result != null && result is DataModel) {
        final address = '${result.zonecode} ${result.address}';
        widget.addressController.text = address;
      }
    } catch (e) {
      debugPrint('주소 검색 오류: $e');
    } finally {
      // 주소 검색 완료 콜백 호출
      widget.onAddressSearchComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _searchAddress(context),
                child: AbsorbPointer(
                  child: CustomInputField(
                    controller: widget.addressController,
                    placeholder: '기본 주소',
                    enabled: false,
                    style: CustomInputFieldStyle.bottomBorder,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 주소 검색 버튼
            SizedBox(
              width: 100,
              child: CTAButton(
                onPressed: () => _searchAddress(context),
                type: CTAButtonType.outline,
                size: CTAButtonSize.large,
                text: '주소 검색',
                isEnabled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
