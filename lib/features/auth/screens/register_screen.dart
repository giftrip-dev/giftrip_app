import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/text_field/custom_input_field.dart';
import 'package:myong/core/widgets/dropdown/custom_dropdown.dart';
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

  bool isButtonEnabled = true;
  bool isPhoneVerified = false;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? passwordConfirmError;
  bool isFormSubmitted = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    passwordConfirmController.addListener(_validateForm);
  }

  @override
  void dispose() {
    nameController.removeListener(_validateForm);
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    passwordConfirmController.removeListener(_validateForm);
    super.dispose();
  }

  void _validateForm() {
    if (!isFormSubmitted) return;

    setState(() {
      nameError = nameController.text.isEmpty ? '이름을 입력해주세요' : null;

      if (emailController.text.isEmpty) {
        emailError = '이메일을 입력해주세요';
      } else if (selectedEmailDomain == null) {
        emailError = '이메일 도메인을 선택해주세요';
      } else {
        emailError = null;
      }

      if (passwordController.text.isEmpty) {
        passwordError = '비밀번호를 입력해주세요';
      } else if (passwordController.text.length < 6 ||
          passwordController.text.length > 20) {
        passwordError = '비밀번호는 6~20자 사이여야 합니다';
      } else {
        int complexity = 0;
        if (RegExp(r'[A-Z]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[a-z]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[0-9]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text))
          complexity++;

        passwordError =
            complexity < 2 ? '영어 대,소문자,숫자,특수기호 중 2가지 이상 조합해주세요' : null;
      }

      if (passwordConfirmController.text.isEmpty) {
        passwordConfirmError = '비밀번호 확인을 입력해주세요';
      } else if (passwordConfirmController.text != passwordController.text) {
        passwordConfirmError = '비밀번호가 일치하지 않습니다';
      } else {
        passwordConfirmError = null;
      }
    });
  }

  void _onVerificationSuccess() {
    setState(() {
      isPhoneVerified = true;
    });
  }

  void _onVerificationFailure() {
    setState(() {
      isPhoneVerified = false;
    });
  }

  void _submitForm() {
    setState(() {
      isFormSubmitted = true;
    });

    _validateForm();

    if (nameError == null &&
        emailError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        isPhoneVerified) {
      print('회원가입 성공!');
    } else {
      print('회원가입 실패!');
    }
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
                errorText: nameError,
                isError: nameError != null,
              ),
              const SizedBox(height: 24),
              Text('이메일', style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48, // TextField 고정 높이
                          child: CustomInputField(
                            controller: emailController,
                            placeholder: '이메일',
                            isError: emailError != null,
                            errorText: null, // 에러 텍스트를 별도로 표시
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48, // TextField와 같은 높이
                        child: Center(
                          child: Text('@',
                              style: body_S.copyWith(
                                  color: AppColors.labelStrong)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48, // TextField 고정 높이
                          child: CustomDropdown(
                            items: emailDomains,
                            value: selectedEmailDomain,
                            onChanged: (val) {
                              setState(() {
                                selectedEmailDomain = val;
                                _validateForm();
                              });
                            },
                            hintText: '선택',
                            height: 96,
                            isError: emailError != null &&
                                selectedEmailDomain == null,
                            errorText: null, // 에러 텍스트를 별도로 표시
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        emailError!,
                        style:
                            subtitle_S.copyWith(color: AppColors.statusError),
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
                errorText: passwordError,
                isError: passwordError != null,
              ),
              const SizedBox(height: 8),
              CustomInputField(
                controller: passwordConfirmController,
                placeholder: '비밀번호 확인',
                isPassword: true,
                eyeIconColor: AppColors.componentNatural,
                errorText: passwordConfirmError,
                isError: passwordConfirmError != null,
              ),
              if (passwordConfirmError == null) const SizedBox(height: 8),
              if (passwordConfirmError == null)
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
              // if (isFormSubmitted && !isPhoneVerified)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8, top: 4),
              //     child: Text(
              //       '휴대폰 인증을 완료해주세요',
              //       style:
              //           TextStyle(color: AppColors.statusError, fontSize: 13),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomCTAButton(
        isEnabled: true,
        onPressed: _submitForm,
        text: '가입하기',
      ),
    );
  }
}
