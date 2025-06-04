import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/features/auth/widgets/phone_number_verification.dart';
import 'package:giftrip/features/auth/screens/change_password_screen.dart';

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  int _selectedTab = 1; // 0: 아이디 찾기, 1: 비밀번호 찾기

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool _isPhoneVerified = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final isNameFilled = _nameController.text.trim().isNotEmpty;
    final isEmailFilled =
        _selectedTab == 1 ? _emailController.text.trim().isNotEmpty : true;
    return _isPhoneVerified && isNameFilled && isEmailFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '아이디/비밀번호 찾기',
        type: BackButtonAppBarType.textCenter,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 탭 (Padding 밖)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        '아이디 찾기',
                        style: subtitle_M.copyWith(
                          color: _selectedTab == 0
                              ? AppColors.labelStrong
                              : AppColors.labelAssistive,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: _selectedTab == 0
                            ? AppColors.labelStrong
                            : AppColors.labelAssistive,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        '비밀번호 찾기',
                        style: subtitle_M.copyWith(
                          color: _selectedTab == 1
                              ? AppColors.labelStrong
                              : AppColors.labelAssistive,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: _selectedTab == 1
                            ? AppColors.labelStrong
                            : AppColors.labelAssistive,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 입력/버튼 영역만 Padding 적용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 입력
                  Text(
                    '이름',
                    style: subtitle_S.copyWith(
                      color: AppColors.labelStrong,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomInputField(
                    controller: _nameController,
                    placeholder: '홍길동',
                    enabled: true,
                  ),
                  // 비밀번호 찾기 탭일 때만 이메일 입력
                  if (_selectedTab == 1) ...[
                    const SizedBox(height: 24),
                    Text(
                      '이메일',
                      style: subtitle_S.copyWith(
                        color: AppColors.labelStrong,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomInputField(
                      controller: _emailController,
                      placeholder: '이메일',
                      enabled: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                  const SizedBox(height: 24),
                  // 휴대폰 번호 인증 (PhoneNumberVerification 위젯 사용)
                  Text(
                    '휴대폰 번호 인증',
                    style: subtitle_S.copyWith(
                      color: AppColors.labelStrong,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PhoneNumberVerification(
                    phoneNumberController: _phoneController,
                    verificationCodeController: _codeController,
                    focusScopeNode: _focusScopeNode,
                    onVerificationSuccess: () {
                      setState(() {
                        _isPhoneVerified = true;
                      });
                    },
                    onVerificationFailure: () {
                      setState(() {
                        _isPhoneVerified = false;
                      });
                    },
                    type: 'find_account',
                    isFormSubmitted: false,
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 59,
                    child: CTAButton(
                      text: '확인',
                      onPressed: () {
                        if (_selectedTab == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          );
                        } else {
                          // 아이디 찾기 탭일 때의 동작 (필요시 구현)
                        }
                      },
                      isEnabled: _isFormValid,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
