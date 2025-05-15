import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/utils/logger.dart';

class TitleInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const TitleInputField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  _TitleInputFieldState createState() => _TitleInputFieldState();
}

class _TitleInputFieldState extends State<TitleInputField> {
  String? _localErrorText;

  @override
  void initState() {
    super.initState();
    _localErrorText = widget.errorText;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      if (widget.controller.text.trim().isNotEmpty) {
        logger.d('hhhhh');
        _localErrorText = null; // 최소 글자 수 조건 만족 시 에러 제거
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _currentText = widget.controller.text;

    /// 1) 부모가 준 에러
    final parentErrorText = widget.errorText;

    /// 2) 아직 조건을 충족하지 않았다면 에러 표시
    bool isUnderMinLen = false;
    if (_currentText.isEmpty) {
      isUnderMinLen = true;
    }

    /// 3) 부모 에러 메시지가 있고 minLen에 만족 X -> 에러 표시
    final displayedErrorText =
        (parentErrorText != null && isUnderMinLen) ? parentErrorText : null;
    final hasError = displayedErrorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          style: body_M,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.statusError : AppColors.line,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.statusError : AppColors.line,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.statusError : AppColors.line,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            hintText: "제목을 입력해주세요.",
            hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
          ),
          onChanged: (text) {
            setState(() {
              if (text.trim().isNotEmpty) {
                _localErrorText = null;
              }
            });
          },
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              widget.errorText ?? _localErrorText!,
              style: subtitle_XS.copyWith(color: AppColors.statusError),
            ),
          ),
      ],
    );
  }
}
