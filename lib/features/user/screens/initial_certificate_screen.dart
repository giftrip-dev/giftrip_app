import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/widgets/app_bar/global_app_bar.dart';
import 'package:myong/core/widgets/bottom_sheet/image_select_bottom_sheet.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';
import 'package:myong/features/user/view_models/certificate_view_model.dart';
import 'package:myong/core/widgets/tooltip/tooltip.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:myong/features/user/screens/employment_form_screen.dart';
import 'package:myong/core/utils/check_permission.dart';
import 'package:myong/features/user/screens/certification_complete_no_alarm_screen.dart';
import 'package:myong/features/user/screens/certification_complete_screen.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/core/widgets/modal/two_button_modal.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class InitialCertificateScreen extends StatefulWidget {
  final BeautyCategory category;
  final String? previousPage;
  const InitialCertificateScreen(
      {super.key, required this.category, this.previousPage});

  @override
  State<InitialCertificateScreen> createState() =>
      _InitialCertificateScreenState();
}

class _InitialCertificateScreenState extends State<InitialCertificateScreen> {
  @override
  void initState() {
    super.initState();
    // view 로그 기록
    AmplitudeLogger.logViewEvent("app_initial_certificate_screen_view",
        "app_initial_certificate_screen");

    // 이미지 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CertificateViewModel>().setSelectedImage(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CertificateViewModel>();
    // 알림 권한 상태 확인
    checkNotificationPermission(context);

    return Scaffold(
      appBar: widget.previousPage == 'my_page'
          ? BackButtonAppBar(
              type: BackButtonAppBarType.textLeft,
              title: '자격증 등록',
              onBack: () {
                showDialog(
                  context: context,
                  builder: (context) => TwoButtonModal(
                    title: '자격증 등록을 그만하시나요?',
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    cancelText: '계속하기',
                    confirmText: '그만하기',
                  ),
                );
              },
            )
          : const GlobalAppBar(
              noAlarm: true,
            ),
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '미용인임을 인증할 수 있는\n자격증을 등록해주세요',
              style: h1_M,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTooltip(
              text: '🌟 자격증 내용이 식별 가능하도록 자세히 찍어주세요 🌟',
              isDark: true,
            ),
            const SizedBox(height: 8),
            // 이미지 업로드 컨테이너
            Center(
              child: GestureDetector(
                onTap: () => _showImagePicker(context),
                child: Container(
                  width: double.infinity,
                  height: 333,
                  margin: const EdgeInsets.symmetric(horizontal: 37.5),
                  decoration: BoxDecoration(
                    color: AppColors.componentAlternative,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: viewModel.selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            viewModel.selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icon/plus.png',
                              width: 64,
                              height: 64,
                            ),
                            Text(
                              '사진 업로드하기',
                              style: subtitle_S.copyWith(
                                  color: AppColors.labelStrong),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24), // 버튼과 이미지 업로드 컨테이너 사이의 간격
            GestureDetector(
              onTap: () {
                AmplitudeLogger.logClickEvent("no_certificate_click",
                    "no_certificate_button", "initial_certificate_screen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmploymentFormScreen(
                            category: widget.category,
                          )),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lineStrong),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '자격증이 없으신가요?',
                  style: title_S.copyWith(color: AppColors.labelStrong),
                ),
              ),
            ),
            const SizedBox(height: 20), // 버튼과 bottomSheet 사이의 간격
          ],
        ),
      ),

      // 자격증 업로드 버튼
      bottomSheet: OneButtonBottomSheet(
        isEnabled: viewModel.selectedImage != null && !viewModel.isUploading,
        buttonText: "등록하기",
        onButtonPressed: () async {
          AmplitudeLogger.logClickEvent(
              "certificate_picture_register_click",
              "certificate_picture_register_button",
              "initial_certificate_screen");
          // 알림 권한 상태 확인
          final permissionStatus =
              await GlobalStorage().getNotificationPermission();
          final storageService = GlobalStorage();
          // 업로드 처리
          final uploadSuccess = await viewModel.handleUploadCertificate(
              category: widget.category);

          if (uploadSuccess) {
            await storageService.setCertificateComplete();
            // 업로드 성공 시에만 네비게이션
            if (permissionStatus == "denied") {
              // 알림 권한이 거부된 경우
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CertificationCompleteNoAlarmScreen(
                    previousPage: widget.previousPage,
                  ),
                ),
                (route) => false,
              );
            } else {
              // 알림 권한이 허용된 경우
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CertificationCompleteScreen(
                    previousPage: widget.previousPage,
                  ),
                ),
                (route) => false,
              );
            }
          }
        },
      ),
    );
  }

  /// 이미지 선택 모달
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ImagePickerBottomSheet(
          onPickImage: (source) async {
            await _handleImagePick(context, source);
          },
        );
      },
    );
  }

  /// 이미지 선택 후 크기 검사
  Future<void> _handleImagePick(
      BuildContext context, ImageSource source) async {
    final viewModel = context.read<CertificateViewModel>();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);
      int fileSize = await imageFile.length(); // 파일 크기 가져오기 (bytes)

      if (fileSize > 25 * 1024 * 1024) {
        // 25MB로 변경
        logger.d('이미지 크기가 너무 큼: ${fileSize / 1024} KB');

        // ✅ 현재 화면을 닫지 않고, 모달만 닫기
        Navigator.maybePop(context);

        // ✅ 화면이 다시 그려진 후 모달이 뜨도록 0초 딜레이 추가
        Future.delayed(Duration.zero, () {
          _showSizeWarningModal(context);
        });
      } else {
        viewModel.setSelectedImage(imageFile);
      }
    }
  }

  /// 25MB 초과 시 경고 모달 띄우기
  void _showSizeWarningModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return OneButtonModal(
          title: "크기가 25MB 이하인 이미지를\n등록해주세요.",
          onConfirm: () {
            Navigator.of(context).pop(); // ✅ 모달 닫기
          },
        );
      },
    );
  }
}
