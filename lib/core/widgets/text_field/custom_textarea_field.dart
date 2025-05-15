import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CustomTextArea extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool enabled;
  final String? errorText; // ✅ 에러 메시지 추가

  const CustomTextArea({
    super.key,
    required this.controller,
    required this.placeholder,
    this.enabled = true,
    this.errorText,
  });

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  static const int maxLength = 300;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 160),
              child: TextField(
                controller: widget.controller,
                enabled: widget.enabled,
                maxLength: maxLength,
                maxLines: null,
                minLines: 6,
                style: body_M.copyWith(
                  color: widget.enabled
                      ? AppColors.labelStrong
                      : AppColors.labelAlternative,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: body_M.copyWith(
                    color: AppColors.labelAssistive,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  filled: !widget.enabled,
                  fillColor: AppColors.backgroundAlternative,
                  counterText: "", // 글자 수는 직접 표시
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.statusError
                          : AppColors.line,
                      width: widget.errorText != null ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.statusError
                          : AppColors.labelStrong,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              child: Text(
                '${widget.controller.text.length}/$maxLength',
                style: caption.copyWith(color: AppColors.labelNatural),
              ),
            ),
          ],
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              widget.errorText!,
              style: subtitle_S.copyWith(color: AppColors.statusError),
            ),
          ),
      ],
    );
  }
}
