import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/core/utils/pdf_download.dart';
import 'package:myong/features/user/screens/select_category_screen.dart';
import 'package:myong/core/widgets/button/cta_button.dart';
import 'package:myong/features/user/models/dto/user_dto.dart';
import 'package:myong/features/user/view_models/user_view_model.dart';
import 'package:myong/core/utils/amplitude_logger.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:myong/core/widgets/text_field/custom_input_field.dart';
import 'package:myong/core/widgets/dropdown/custom_dropdown.dart';
import 'package:myong/features/auth/widgets/bottom_cta_button.dart';

class InfluencerCheckScreen extends StatefulWidget {
  const InfluencerCheckScreen({super.key});

  @override
  State<InfluencerCheckScreen> createState() => _InfluencerCheckScreenState();
}

class _InfluencerCheckScreenState extends State<InfluencerCheckScreen> {
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
  String? _selectedDomain;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _customDomainController = TextEditingController();

  String _accountName = '';
  String _customDomain = '';

  void _updateAccountName() {
    setState(() {
      _accountName = _accountController.text;
    });
  }

  void _updateCustomDomain() {
    setState(() {
      _customDomain = _customDomainController.text;
    });
  }

  /// 인플루언서루활활 활활 토글
  void _toggleYes() {
    setState(() {
      _yes = true;
      _no = false;
    });
  }

  void _toggleNo() {
    setState(() {
      _yes = false;
      _no = true;
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
                          },
                          hintText: '도메인 선택',
                        ),
                        if (_selectedDomain == '기타')
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: CustomInputField(
                              controller: _customDomainController,
                              placeholder: '도메인 입력',
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text('계정 이름',
                            style: h2_S.copyWith(color: AppColors.labelStrong)),
                        const SizedBox(height: 8),
                        CustomInputField(
                          controller: _accountController,
                          placeholder: '계정 이름',
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
                      (_selectedDomain == '기타' && _customDomain.isNotEmpty))),
          onPressed: _no ||
                  (_yes &&
                      _selectedDomain != null &&
                      _accountName.isNotEmpty &&
                      (_selectedDomain != '기타' ||
                          (_selectedDomain == '기타' &&
                              _customDomain.isNotEmpty)))
              ? () async {
                  final userViewModel = UserViewModel();
                  final storageService = GlobalStorage();

                  bool success =
                      await userViewModel.updateUser(UserUpdateRequestDto(
                    isTermsOfServiceConsent: _yes,
                    isPersonalInfoConsent: _yes,
                    isAdvConsent: _yes,
                  ));
                  if (success) {
                    await storageService.setServiceTermsComplete();
                    AmplitudeLogger.logClickEvent("terms_agreement_cta_click",
                        "terms_agreement_cta_button", "terms_agreement_screen");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCategoryScreen()),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('유저 정보 업데이트에 실패했습니다.')),
                    );
                  }
                }
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
