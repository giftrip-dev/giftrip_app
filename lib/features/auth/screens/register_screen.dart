import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/text_field/custom_input_field.dart';
import 'package:myong/core/widgets/dropdown/custom_dropdown.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';
import 'package:myong/features/auth/widgets/bottom_cta_button.dart';
import 'package:myong/features/auth/widgets/phone_number_verification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  String? selectedEmailDomain;
  final List<String> emailDomains = [
    'kakao.com',
    'hanmail.net',
  ];

  bool isButtonEnabled = false;
  bool isPhoneVerified = false;

  void _onVerificationSuccess() {
    setState(() {
      isPhoneVerified = true;
      _updateButtonState();
    });
  }

  void _onVerificationFailure() {
    setState(() {
      isPhoneVerified = false;
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          passwordConfirmController.text.isNotEmpty &&
          isPhoneVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('회원가입', style: title_M.copyWith(color: AppColors.labelStrong)),
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('이름', style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 4),
              CustomInputField(
                controller: nameController,
                placeholder: '아이디',
              ),
              const SizedBox(height: 24),
              Text('이메일', style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInputField(
                      controller: emailController,
                      placeholder: '이메일',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('@',
                      style: body_S.copyWith(color: AppColors.labelStrong)),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: CustomDropdown(
                      items: emailDomains,
                      value: selectedEmailDomain,
                      onChanged: (val) {
                        setState(() {
                          selectedEmailDomain = val;
                        });
                      },
                      hintText: '선택',
                      height: 96,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('비밀번호', style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 8),
              CustomInputField(
                controller: passwordController,
                placeholder: '비밀번호',
                isPassword: true,
                eyeIconColor: AppColors.componentNatural,
              ),
              const SizedBox(height: 8),
              CustomInputField(
                controller: passwordConfirmController,
                placeholder: '비밀번호 확인',
                isPassword: true,
                eyeIconColor: AppColors.componentNatural,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '6~20자/영어 대,소문자,숫자,특수기호 중 2가지 이상 조합',
                  style: caption.copyWith(color: AppColors.labelNatural),
                ),
              ),
              const SizedBox(height: 24),
              Text('휴대폰 번호 인증',
                  style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 4),
              PhoneNumberVerification(
                phoneNumberController: phoneController,
                verificationCodeController: verificationCodeController,
                focusScopeNode: focusScopeNode,
                onVerificationSuccess: _onVerificationSuccess,
                onVerificationFailure: _onVerificationFailure,
                type: 'SIGNUP',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomCTAButton(
        isEnabled: isButtonEnabled,
        onPressed: isButtonEnabled ? () {} : null,
        text: '가입하기',
      ),
    );
  }
}
