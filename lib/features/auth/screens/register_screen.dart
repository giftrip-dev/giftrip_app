import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/core/widgets/dropdown/custom_dropdown.dart';
import 'package:giftrip/features/auth/widgets/bottom_cta_button.dart';
import 'package:giftrip/features/auth/widgets/phone_number_verification.dart';
import 'package:giftrip/features/auth/screens/influencer_check_screen.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/features/auth/view_models/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  final bool isTermsAgreed;
  final bool isPrivacyAgreed;
  final bool isMarketingAgreed;

  const RegisterScreen({
    super.key,
    required this.isTermsAgreed,
    required this.isPrivacyAgreed,
    required this.isMarketingAgreed,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final AuthRepository _authRepo = AuthRepository();
  final AuthViewModel _authViewModel = AuthViewModel();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  bool isButtonEnabled = true;
  bool isPhoneVerified = false;
  bool isLoading = false;

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
      nameError = nameController.text.isEmpty ? '이름을 입력해주세요.' : null;

      if (emailController.text.isEmpty) {
        emailError = '이메일을 입력해주세요.';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(emailController.text)) {
        emailError = '올바른 이메일 형식이 아닙니다.';
      } else {
        emailError = null;
      }

      if (passwordController.text.isEmpty) {
        passwordError = '비밀번호를 입력해주세요.';
      } else if (passwordController.text.length < 6 ||
          passwordController.text.length > 20) {
        passwordError = '6~20자/영어,대,소문자,숫자,특수기호 중 2가지 이상 조합해주세요.';
      } else {
        int complexity = 0;
        if (RegExp(r'[A-Z]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[a-z]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[0-9]').hasMatch(passwordController.text)) complexity++;
        if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text))
          complexity++;

        passwordError =
            complexity < 2 ? '6~20자/영어,대,소문자,숫자,특수기호 중 2가지 이상 조합해주세요.' : null;
      }

      if (passwordConfirmController.text.isEmpty) {
        passwordConfirmError = '비밀번호 확인을 입력해주세요.';
      } else if (passwordConfirmController.text != passwordController.text) {
        passwordConfirmError = '비밀번호가 일치하지 않습니다.';
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

  Future<void> _submitForm() async {
    setState(() {
      isFormSubmitted = true;
      isLoading = true;
    });

    _validateForm();

    if (nameError == null &&
        emailError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        isPhoneVerified) {
      final request = RegisterRequest(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: phoneController.text,
        isMarketingAgreed: widget.isMarketingAgreed,
        isTermsAgreed: widget.isTermsAgreed,
        isPrivacyAgreed: widget.isPrivacyAgreed,
        passwordConfirm: passwordConfirmController.text,
      );

      final response = await _authViewModel.signUp(request);

      if (response) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const InfluencerCheckScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('회원가입에 실패했습니다.'),
              backgroundColor: AppColors.statusError,
            ),
          );
        }
      }
    }

    setState(() {
      isLoading = false;
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
        centerTitle: true,
        toolbarHeight: 56,
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
                placeholder: '이름',
                errorText: nameError,
                isError: nameError != null,
              ),
              const SizedBox(height: 24),
              Text('이메일', style: h2_S.copyWith(color: AppColors.labelStrong)),
              const SizedBox(height: 4),
              CustomInputField(
                controller: emailController,
                placeholder: '이메일',
                errorText: emailError,
                isError: emailError != null,
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
                isFormSubmitted: isFormSubmitted,
              ),
              // if (isFormSubmitted && !isPhoneVerified)
              //   Padding(
              //     padding: const EdgeInsets.only(
              //       left: 8,
              //     ),
              //     child: Text(
              //       '휴대폰 인증을 완료해주세요',
              //       style: subtitle_S.copyWith(color: AppColors.statusError),
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
