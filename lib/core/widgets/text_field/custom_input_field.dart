import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool enabled; // 활성화 여부
  final bool isPassword; // 비밀번호 인풋 여부
  final String? errorText; // 에러 메세지
  final bool? isValid; // 유효성 검사 결과 (null: 검사 안함, true: 통과, false: 실패)

  const CustomInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.enabled = true,
    this.isPassword = false,
    this.errorText,
    this.isValid,
  });
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final showObscureToggle = widget.isPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: showObscureToggle ? _obscure : false,
          style: body_M.copyWith(
            color: widget.enabled
                ? AppColors.labelStrong
                : AppColors.labelAlternative,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            filled: true,
            fillColor: AppColors.white,
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
                    : (widget.isValid == true
                        ? AppColors.statusClear
                        : AppColors.labelStrong),
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.line, width: 1),
            ),
            suffixIcon: showObscureToggle
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.componentDimmer,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : widget.isValid == true
                    ? const Icon(Icons.check, color: AppColors.statusClear)
                    : null,
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
