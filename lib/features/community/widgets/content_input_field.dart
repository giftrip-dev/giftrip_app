import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';

class ContentInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final int? maxLen; // 최대 글자 수
  final int? minLen; // 최소 글자 수
  final String? errorText;
  final FocusNode? focusNode;

  const ContentInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.maxLen,
    this.minLen,
    this.errorText,
    this.focusNode,
  });

  @override
  _ContentInputFieldState createState() => _ContentInputFieldState();
}

class _ContentInputFieldState extends State<ContentInputField> {
  late String _currentText;
  late FocusNode _internalFocusNode; // 내부에서 사용할 FocusNode

  @override
  void initState() {
    super.initState();
    _currentText = widget.controller.text;
    widget.controller.addListener(_onTextChange);

    _internalFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);

    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }

    super.dispose();
  }

  /// 컨트롤러가 변경될 때마다 호출
  void _onTextChange() {
    setState(() {
      _currentText = widget.controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 1) 부모가 준 에러가 있을 수 있음
    final parentErrorText = widget.errorText;

    /// 2) `minLen`이 설정되어 있고, 아직 조건을 충족하지 않았다면 에러 표시
    bool isUnderMinLen = false;
    if (widget.minLen != null && _currentText.length < widget.minLen!) {
      isUnderMinLen = true;
    }

    /// 3) 최종적으로 표시할 에러 메시지를 결정
    ///    - (부모 에러 메시지가 있고) AND (아직 minLen에 못 미치면) -> 표시
    ///    - 그 외 -> null
    final displayedErrorText =
        (parentErrorText != null && isUnderMinLen) ? parentErrorText : null;

    /// 4) 보더 색상은 에러가 있으면 빨간색, 없으면 기본 라인/포커스 색
    final hasError = displayedErrorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(children: [
          Container(
            padding: EdgeInsets.zero,
            height: 200,
            child: TextField(
              controller: widget.controller,
              focusNode: _internalFocusNode,
              maxLines: 10,
              minLines: 10,
              maxLength: widget.maxLen,
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
                hintText: widget.placeholder,
                hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
                counterText: "",
              ),
              onChanged: (text) {
                // 최대 글자 수 초과 시 잘라내기
                if (widget.maxLen != null && text.length > widget.maxLen!) {
                  widget.controller.text = text.substring(0, widget.maxLen!);
                  widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.maxLen!),
                  );
                }
                setState(() {
                  _currentText = widget.controller.text;
                });
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              "${_currentText.length}/${widget.maxLen ?? '∞'}",
              style: caption.copyWith(color: AppColors.labelAssistive),
            ),
          ),
        ]),

        /// 에러 메시지 표시
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(displayedErrorText,
                style: subtitle_XS.copyWith(color: AppColors.statusError)),
          ),
      ],
    );
  }
}
