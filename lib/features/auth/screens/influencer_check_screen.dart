import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/core/widgets/dropdown/custom_dropdown.dart';
import 'package:giftrip/features/auth/widgets/bottom_cta_button.dart';
import 'package:giftrip/features/auth/screens/register_success_screen.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
import 'dart:developer' as developer;

class InfluencerCheckScreen extends StatefulWidget {
  final bool fromSocialLogin; // 소셜 로그인에서 왔는지 구분
  final bool isMarketingAgreed;
  final bool isTermsAgreed;
  final bool isPrivacyAgreed;

  const InfluencerCheckScreen({
    super.key,
    this.fromSocialLogin = false,
    this.isMarketingAgreed = false,
    this.isTermsAgreed = false,
    this.isPrivacyAgreed = false,
  });

  @override
  State<InfluencerCheckScreen> createState() => _InfluencerCheckScreenState();
}

class _InfluencerCheckScreenState extends State<InfluencerCheckScreen> {
  final AuthRepository _authRepo = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_updateAccountName);
    _customDomainController.addListener(_updateCustomDomain);
  }

  /// 인플루언서 활활 상태
  bool _yes = false;
  bool _no = false;

  // 도메인 선택 및 계정 이름 상태 변수 추가
  final List<String> _domains = ['유튜브', '인스타그램', 'X (구 트위터)', '네이버 블로그', '기타'];

  final Map<String, String> _domainMap = {
    '유튜브': 'youtube',
    '인스타그램': 'instagram',
    'X (구 트위터)': 'x',
    '네이버 블로그': 'naver_blog',
  };
  String? _selectedDomain;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _customDomainController = TextEditingController();

  String _accountName = '';
  String _customDomain = '';

  void _updateAccountName() {
    setState(() {
      _accountName = _accountController.text;
    });
    developer.log(
      '계정 이름 업데이트: ${_accountName} (유효성: ${_accountName.isNotEmpty})',
      name: 'InfluencerCheckScreen',
    );
  }

  void _updateCustomDomain() {
    setState(() {
      _customDomain = _customDomainController.text;
    });
    developer.log(
      '커스텀 도메인 업데이트: ${_customDomain} (유효성: ${_customDomain.isNotEmpty})',
      name: 'InfluencerCheckScreen',
    );
  }

  /// 인플루언서 활활 활활 토글
  void _toggleYes() {
    setState(() {
      _yes = true;
      _no = false;
    });
    developer.log(
      '''인플루언서 활동 여부: 예
      - 선택된 도메인: ${_selectedDomain ?? '없음'}
      - 계정 이름: ${_accountName.isEmpty ? '없음' : _accountName}
      - 커스텀 도메인: ${_customDomain.isEmpty ? '없음' : _customDomain}
      - 유효성: ${_selectedDomain != null && _accountName.isNotEmpty && (_selectedDomain != '기타' || (_selectedDomain == '기타' && _customDomain.isNotEmpty))}''',
      name: 'InfluencerCheckScreen',
    );
  }

  void _toggleNo() {
    setState(() {
      _yes = false;
      _no = true;
    });
    developer.log(
      '인플루언서 활동 여부: 아니오',
      name: 'InfluencerCheckScreen',
    );
  }

  Future<void> _submitInfluencerInfo() async {
    developer.log(
      '''인플루언서 정보 제출 시작:
      - 플로우: ${widget.fromSocialLogin ? '소셜 로그인' : '회원가입'}
      - 인플루언서 여부: ${_yes ? '예' : '아니오'}
      - 선택된 도메인: ${_selectedDomain ?? '없음'}
      - 커스텀 도메인: ${_customDomain.isEmpty ? '없음' : _customDomain}
      - 계정 이름: ${_accountName.isEmpty ? '없음' : _accountName}''',
      name: 'InfluencerCheckScreen',
    );

    setState(() {
      _isLoading = true;
    });

    final CompleteSignUpRequest request;

    if (_no) {
      // "아니요" 선택 시: isInfluencer = false, influencerInfo 없음
      request = CompleteSignUpRequest(
        isInfluencer: false,
        // 소셜 로그인에서 온 경우 약관 동의 정보 포함
        isMarketingAgreed:
            widget.fromSocialLogin ? widget.isMarketingAgreed : null,
        isTermsAgreed: widget.fromSocialLogin ? widget.isTermsAgreed : null,
        isPrivacyAgreed: widget.fromSocialLogin ? widget.isPrivacyAgreed : null,
      );
      developer.log(
          '아니요 선택 - ${widget.fromSocialLogin ? '약관 동의 정보 포함' : '약관 동의 정보 제외'}하여 전송',
          name: 'InfluencerCheckScreen');
    } else {
      // "예" 선택 시: isInfluencer = true, influencerInfo 포함
      final String platform = _selectedDomain == '기타'
          ? 'others'
          : (_domainMap[_selectedDomain!] ?? _selectedDomain!);
      final String platformId = _accountName;
      final String? platformName =
          _selectedDomain == '기타' ? _customDomain : null;

      request = CompleteSignUpRequest(
        isInfluencer: true,
        influencerInfo: InfluencerInfo(
          platform: platform,
          platformId: platformId,
          platformName: platformName,
        ),
        // 소셜 로그인에서 온 경우 약관 동의 정보 포함
        isMarketingAgreed:
            widget.fromSocialLogin ? widget.isMarketingAgreed : null,
        isTermsAgreed: widget.fromSocialLogin ? widget.isTermsAgreed : null,
        isPrivacyAgreed: widget.fromSocialLogin ? widget.isPrivacyAgreed : null,
      );
      developer.log(
          '예 선택 - ${widget.fromSocialLogin ? '약관 동의 정보 포함' : '약관 동의 정보 제외'}, influencerInfo: platform=$platform, platformId=$platformId',
          name: 'InfluencerCheckScreen');
    }

    final response = await _authRepo.completeSignUp(request);

    if (response) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterSuccessScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('잠시후 다시 시도해주세요.'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("회원가입",
              style: title_M.copyWith(color: AppColors.labelStrong)),
          titleSpacing: 0,
          centerTitle: true,
          toolbarHeight: 56,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  'assets/png/logo.png',
                  width: 85,
                  height: 23,
                ),
                const SizedBox(height: 16),
                const Text(
                  '현재 인플루언서로\n활동하고 있으신가요?',
                  style: h1_M,
                ),
                const SizedBox(height: 8),

                // 인플루언서 활활 박스
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color:
                        _yes ? AppColors.primaryAlternative : AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CustomRadio(
                            isChecked: _yes,
                            onTap: _toggleYes,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: _toggleYes,
                              child: Text(
                                '예',
                                style:
                                    h2_R.copyWith(color: AppColors.labelStrong),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_yes) ...[
                        const SizedBox(height: 16),
                        Text('선택',
                            style: h2_S.copyWith(color: AppColors.labelStrong)),
                        const SizedBox(height: 8),
                        CustomDropdown(
                          width: 150,
                          items: _domains,
                          value: _selectedDomain,
                          onChanged: (value) {
                            setState(() {
                              _selectedDomain = value;
                            });
                            developer.log(
                              '''도메인 선택:
                              - 선택된 도메인: ${value ?? '없음'}
                              - 커스텀 도메인 여부: ${value == '기타'}
                              - 유효성: ${value != null}''',
                              name: 'InfluencerCheckScreen',
                            );
                          },
                          hintText: '도메인 선택',
                        ),
                        if (_selectedDomain == '기타')
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: CustomInputField(
                              controller: _customDomainController,
                              placeholder: '도메인 입력',
                              onChanged: (value) {
                                developer.log(
                                  '커스텀 도메인 입력: ${value} (유효성: ${value.isNotEmpty})',
                                  name: 'InfluencerCheckScreen',
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text('계정 이름',
                            style: h2_S.copyWith(color: AppColors.labelStrong)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          controller: _accountController,
                          placeholder: '계정 이름',
                          onChanged: (value) {
                            developer.log(
                              '계정 이름 입력: ${value} (유효성: ${value.isNotEmpty})',
                              name: 'InfluencerCheckScreen',
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color:
                        _no ? AppColors.primaryAlternative : AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _CustomRadio(
                        isChecked: _no,
                        onTap: _toggleNo,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: _toggleNo,
                          child: Text(
                            '아니요',
                            style: h2_R.copyWith(color: AppColors.labelStrong),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 다음 버튼
                // const Spacer(),

                const SizedBox(height: 62),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomCTAButton(
          isEnabled: _no ||
              (_yes &&
                      _selectedDomain != null &&
                      _accountName.isNotEmpty &&
                      (_selectedDomain != '기타' ||
                          (_selectedDomain == '기타' &&
                              _customDomain.isNotEmpty))) &&
                  !_isLoading,
          onPressed: _no ||
                  (_yes &&
                      _selectedDomain != null &&
                      _accountName.isNotEmpty &&
                      (_selectedDomain != '기타' ||
                          (_selectedDomain == '기타' &&
                              _customDomain.isNotEmpty)))
              ? _submitInfluencerInfo
              : null,
          text: '다음',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.removeListener(_updateAccountName);
    _customDomainController.removeListener(_updateCustomDomain);
    _accountController.dispose();
    _customDomainController.dispose();
    super.dispose();
  }
}

///
/// 20x20 라디오 버튼 대용 커스텀 위젯
///
class _CustomRadio extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;

  const _CustomRadio({
    Key? key,
    required this.isChecked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked ? AppColors.primaryStrong : AppColors.lineStrong,
            width: 1,
          ),
          color: isChecked ? AppColors.primaryStrong : AppColors.white,
        ),
        child: isChecked
            ? const Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  weight: 2,
                  color: AppColors.white,
                ),
              )
            : null,
      ),
    );
  }
}
