import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  bool _obscurePw = true;
  bool _obscurePwConfirm = true;

  @override
  void dispose() {
    _pwController.dispose();
    _pwConfirmController.dispose();
    super.dispose();
  }

  bool get _isPasswordValid {
    final pw = _pwController.text;
    // 6~20자, 영문 대소문자, 숫자, 특수문자 중 2가지 이상 조합
    if (pw.length < 6 || pw.length > 20) return false;
    int count = 0;
    if (RegExp(r'[A-Z]').hasMatch(pw)) count++;
    if (RegExp(r'[a-z]').hasMatch(pw)) count++;
    if (RegExp(r'[0-9]').hasMatch(pw)) count++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>\[\]~_\-]').hasMatch(pw)) count++;
    return count >= 2;
  }

  bool get _isFormValid =>
      _isPasswordValid &&
      _pwController.text.isNotEmpty &&
      _pwController.text == _pwConfirmController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '비밀번호 변경',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '새로운 비밀번호',
              style: subtitle_S.copyWith(color: AppColors.labelStrong),
            ),
            const SizedBox(height: 8),
            CustomInputField(
              controller: _pwController,
              placeholder: '새로운 비밀번호를 입력해주세요.',
              enabled: true,
              isPassword: true,
              eyeIconColor: AppColors.labelAssistive,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                '6~20자/영어 대,소문자,숫자,특수기호 중 2가지 이상 조합',
                style: body_S.copyWith(color: AppColors.labelNatural),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '새로운 비밀번호 확인',
              style: subtitle_S.copyWith(color: AppColors.labelStrong),
            ),
            const SizedBox(height: 8),
            CustomInputField(
              controller: _pwConfirmController,
              placeholder: '새로운 비밀번호를 한번 더 입력해주세요.',
              enabled: true,
              isPassword: true,
              eyeIconColor: AppColors.labelAssistive,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 59,
              child: CTAButton(
                text: '비밀번호 변경하기',
                onPressed: _isFormValid ? () {} : null,
                isEnabled: _isFormValid,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
