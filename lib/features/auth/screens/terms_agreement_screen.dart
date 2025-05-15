import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/utils/pdf_download.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/user/models/dto/user_dto.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/features/auth/screens/influencer_check_screen.dart';
import 'package:giftrip/features/auth/models/terms_model.dart';
import 'package:giftrip/features/auth/repositories/terms_repo.dart';

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  final TermsRepository _termsRepo = TermsRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_terms_agreement_screen_view", "app_terms_agreement_screen");
  }

  /// 전체 약관 동의 상태
  bool _allAgreed = false;

  /// 개별 약관 동의 상태
  bool _required1 = false; // [필수] 회원가입 및 이용약관 동의
  bool _required2 = false; // [필수] 개인정보 수집 및 이용 동의
  bool _optional = false; // [선택] 마케팅 활용 동의 및 광고 수신 동의

  /// 전체 약관 토글
  void _toggleAll() {
    setState(() {
      _allAgreed = !_allAgreed;
      _required1 = _allAgreed;
      _required2 = _allAgreed;
      _optional = _allAgreed;
    });
  }

  /// 개별 약관 토글
  void _toggleRequired1() {
    setState(() {
      _required1 = !_required1;
      _updateAll();
    });
  }

  void _toggleRequired2() {
    setState(() {
      _required2 = !_required2;
      _updateAll();
    });
  }

  void _toggleOptional() {
    setState(() {
      _optional = !_optional;
      _updateAll();
    });
  }

  /// 개별 토글 시 전체 약관도 업데이트
  void _updateAll() {
    // 모두 true면 전체약관 동의도 true
    if (_required1 && _required2 && _optional) {
      _allAgreed = true;
    } else {
      _allAgreed = false;
    }
  }

  Future<void> _submitTermsAgreement() async {
    if (!_required1 || !_required2) return;

    setState(() {
      _isLoading = true;
    });

    final request = TermsAgreementRequest(
      isTermsOfServiceConsent: _required1,
      isPersonalInfoConsent: _required2,
      isAdvConsent: _optional,
    );

    final response = await _termsRepo.updateTermsAgreement(request);

    if (response.isSuccess) {
      AmplitudeLogger.logClickEvent("terms_agreement_cta_click",
          "terms_agreement_cta_button", "terms_agreement_screen");

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const InfluencerCheckScreen()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? '약관 동의에 실패했습니다.'),
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
                '기프트립\n서비스 이용 약관',
                style: h1_M,
              ),
              const SizedBox(height: 8),

              Text(
                '서비스 이용을 위해 약관을 동의해 주세요.',
                style: subtitle_S.copyWith(color: AppColors.labelAlternative),
              ),

              const Spacer(),
              // 전체 약관 동의 박스
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryAlternative,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _CustomRadio(
                      isChecked: _allAgreed,
                      onTap: _toggleAll,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleAll,
                        child: Text(
                          '전체 약관에 동의합니다.',
                          style: h2_R.copyWith(color: AppColors.primaryStrong),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 세부 약관들
              const SizedBox(height: 32),
              // 1) [필수] 회원가입 및 이용약관 동의
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _CustomRadio(
                      isChecked: _required1,
                      onTap: _toggleRequired1,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleRequired1,
                        child: Row(
                          children: [
                            Text(
                              '[필수] ',
                              style:
                                  h2_S.copyWith(color: AppColors.primaryStrong),
                            ),
                            Text(
                              ' 회원가입 및 이용 약관 동의',
                              style: h2_S.copyWith(color: Color(0xFF0E0E0F)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 오른쪽 끝에 아이콘
                    InkWell(
                      onTap: () {
                        PdfDownloadUtil.downloadPdf(
                          context: context,
                          assetPath: 'assets/service-terms.pdf',
                          fileName: 'service-terms.pdf',
                        );
                      },
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.component,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // 2) [필수] 개인정보 수집 및 이용 동의
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _CustomRadio(
                      isChecked: _required2,
                      onTap: _toggleRequired2,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleRequired2,
                        child: Row(
                          children: [
                            Text(
                              '[필수] ',
                              style:
                                  h2_S.copyWith(color: AppColors.primaryStrong),
                            ),
                            Text(
                              ' 개인정보 수집 및 이용 동의',
                              style: h2_S.copyWith(color: Color(0xFF0E0E0F)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 오른쪽 끝에 아이콘
                    InkWell(
                      onTap: () {
                        PdfDownloadUtil.downloadPdf(
                          context: context,
                          assetPath: 'assets/privacy-policy.pdf',
                          fileName: 'privacy-policy.pdf',
                        );
                      },
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.component,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // 3) [선택] 마케팅 활용 동의 및 광고 수신 동의
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _CustomRadio(
                      isChecked: _optional,
                      onTap: _toggleOptional,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleOptional,
                        child: Row(
                          children: [
                            Text(
                              '[선택] ',
                              style:
                                  h2_S.copyWith(color: AppColors.primaryStrong),
                            ),
                            Text(
                              ' 마케팅 활용 동의 및 광고 수신 동의',
                              style: h2_S.copyWith(color: Color(0xFF0E0E0F)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 아이콘 없음
                  ],
                ),
              ),

              // 다음 버튼
              const SizedBox(height: 44),
              CTAButton(
                isEnabled: _required1 && _required2 && !_isLoading,
                onPressed:
                    _required1 && _required2 ? _submitTermsAgreement : null,
                text: _isLoading ? '처리중...' : '다음',
              ),

              const SizedBox(height: 62),
            ],
          ),
        ),
      ),
    );
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
    // 체크 상태에 따라 내부 아이콘을 달리 표시하거나
    // 테두리를 다르게 표시할 수 있어요.
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
