import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum CustomInputFieldStyle {
  outline, // 기존 스타일
  bottomBorder, // 바텀 보더만 있는 스타일
}

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool enabled; // 활성화 여부
  final bool isPassword; // 비밀번호 인풋 여부
  final String? errorText; // 에러 메세지
  final bool? isValid; // 유효성 검사 결과 (null: 검사 안함, true: 통과, false: 실패)
  final Widget? suffixIcon; // 우측 아이콘
  final Function(String)? onChanged; // 값 변경 콜백
  final bool? isError; // 에러 여부
  final Color? eyeIconColor; // 눈 아이콘 색상
  final TextInputType? keyboardType; // 키보드 타입
  final CustomInputFieldStyle style; // 인풋 필드 스타일

  const CustomInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.enabled = true,
    this.isPassword = false,
    this.errorText,
    this.isValid,
    this.suffixIcon,
    this.onChanged,
    this.isError,
    this.eyeIconColor,
    this.keyboardType,
    this.style = CustomInputFieldStyle.outline,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscure = true;

  String _formatPhoneNumber(String text) {
    // 숫자만 추출
    final numbers = text.replaceAll(RegExp(r'[^\d]'), '');

    // 11자리 제한
    if (numbers.length > 11) {
      return numbers.substring(0, 11);
    }

    // 포맷팅
    if (numbers.length <= 3) {
      return numbers;
    } else if (numbers.length <= 7) {
      return '${numbers.substring(0, 3)}-${numbers.substring(3)}';
    } else {
      return '${numbers.substring(0, 3)}-${numbers.substring(3, 7)}-${numbers.substring(7)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final showObscureToggle = widget.isPassword;
    final isPhoneInput = widget.keyboardType == TextInputType.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: showObscureToggle ? _obscure : false,
          keyboardType: widget.keyboardType,
          inputFormatters: isPhoneInput
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final formatted = _formatPhoneNumber(newValue.text);
                    return TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ]
              : null,
          style: body_M.copyWith(
            color: widget.enabled
                ? AppColors.labelStrong
                : AppColors.labelAlternative,
          ),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal:
                  widget.style == CustomInputFieldStyle.bottomBorder ? 8 : 16,
            ),
            filled: true,
            fillColor: widget.style == CustomInputFieldStyle.outline
                ? AppColors.white
                : Colors.transparent,
            enabledBorder: widget.style == CustomInputFieldStyle.outline
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          (widget.errorText != null || widget.isError == true)
                              ? AppColors.statusError
                              : AppColors.line,
                      width:
                          (widget.errorText != null || widget.isError == true)
                              ? 2
                              : 1,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          (widget.errorText != null || widget.isError == true)
                              ? AppColors.statusError
                              : AppColors.line,
                      width:
                          (widget.errorText != null || widget.isError == true)
                              ? 2
                              : 1,
                    ),
                  ),
            focusedBorder: widget.style == CustomInputFieldStyle.outline
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          (widget.errorText != null || widget.isError == true)
                              ? AppColors.statusError
                              : (widget.isValid == true
                                  ? AppColors.statusClear
                                  : AppColors.labelStrong),
                      width: 2,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          (widget.errorText != null || widget.isError == true)
                              ? AppColors.statusError
                              : (widget.isValid == true
                                  ? AppColors.statusClear
                                  : AppColors.labelStrong),
                      width: 2,
                    ),
                  ),
            disabledBorder: widget.style == CustomInputFieldStyle.outline
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.line, width: 1),
                  )
                : UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.line, width: 1),
                  ),
            suffixIcon: widget.suffixIcon ??
                (showObscureToggle
                    ? IconButton(
                        icon: Icon(
                          _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                          color: widget.eyeIconColor ?? AppColors.labelStrong,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      )
                    : widget.isValid == true
                        ? const Icon(LucideIcons.check,
                            color: AppColors.statusClear)
                        : null),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(widget.errorText!,
                style: subtitle_S.copyWith(color: AppColors.statusError)),
          ),
      ],
    );
  }
}
