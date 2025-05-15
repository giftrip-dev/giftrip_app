import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/global_app_bar.dart';
import 'package:giftrip/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:giftrip/features/user/screens/startup_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class NicknameFormScreen extends StatefulWidget {
  final bool? isAppSettingsRequired;
  final String? previousPage;
  final String? nickname;
  const NicknameFormScreen({
    super.key,
    this.isAppSettingsRequired,
    this.previousPage,
    this.nickname,
  });

  @override
  _NicknameFormScreenState createState() => _NicknameFormScreenState();
}

class _NicknameFormScreenState extends State<NicknameFormScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_nickname_form_screen_view", "app_nickname_form_screen");
    // 닉네임 필드에 기본값 설정
    if (widget.nickname != null) {
      _nicknameController.text = widget.nickname!;
    }
    // isAppSettingsRequired가 true일 때 앱 설정 열기
    if (widget.isAppSettingsRequired == true) {
      _openAppSettings();
    }
  }

  void _openAppSettings() async {
    if (Platform.isIOS) {
      // iOS에서는 URL 스키마 사용
      const url = 'app-settings:';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw '앱 설정을 열 수 없습니다.';
      }
    } else if (Platform.isAndroid) {
      // Android에서는 Intent 사용
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.daggle.myong', // 앱 패키지명으로 변경
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면 바깥을 누르면 키보드 닫기
      },
      child: Scaffold(
        appBar: widget.previousPage == 'my_page'
            ? BackButtonAppBar(
                type: BackButtonAppBarType.complete,
                title: '닉네임 변경',
                onBack: () {
                  // 기존 닉네임과 현재 입력된 닉네임 비교
                  if (_nicknameController.text.trim() != widget.nickname) {
                    showDialog(
                      context: context,
                      builder: (context) => TwoButtonModal(
                        title: '변경사항을 삭제하시나요?',
                        onConfirm: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        cancelText: '수정 계속하기',
                        confirmText: '변경 내용 삭제',
                      ),
                    );
                  } else {
                    Navigator.pop(context); // 변경사항이 없으면 그냥 뒤로가기
                  }
                },
                onComplete: () {
                  _handleUpdateNickname();
                },
              )
            : GlobalAppBar(
                noAlarm: true,
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.previousPage == 'my_page'
                    ? const SizedBox()
                    : Text(
                        '오늘묭해에서\n활동하실 이름을 알려주세요',
                        style: h1_M.copyWith(color: AppColors.labelStrong),
                      ),
                widget.previousPage == 'my_page'
                    ? const SizedBox()
                    : const SizedBox(height: 32),
                _buildTextField(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: widget.previousPage == 'my_page'
            ? null
            : OneButtonBottomSheet(
                isEnabled: _nicknameController.text.isNotEmpty,
                buttonText: '다음',
                onButtonPressed: () {
                  _handleCreateNickname();
                },
              ),
      ),
    );
  }

  void _handleCreateNickname() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.length < 2 || nickname.length > 15) {
      setState(() {
        _errorText = '공백 포함 최소 2자 이상 15자 이하로 입력해주세요.';
      });
    } else if (nickname.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText = '특수문자는 사용할 수 없습니다.';
      });
    } else if (nickname.contains(RegExp(r'\s{2,}'))) {
      setState(() {
        _errorText = '공백은 연속으로 사용할 수 없습니다.';
      });
    } else {
      setState(() {
        _errorText = null; // 에러 메시지 초기화
      });

      final userViewModel = UserViewModel();
      final storageService = GlobalStorage();

      String? errorMessage = await userViewModel.updateUserNickname(nickname);
      if (errorMessage == null) {
        await storageService.setNicknameComplete();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartupScreen()),
          (route) => false,
        );
        AmplitudeLogger.logClickEvent("nickname_create_click",
            "nickname_create_button", "nickname_form_screen");
      } else {
        setState(() {
          _errorText = errorMessage; // 에러 메시지 설정
        });
      }
    }
  }

  void _handleUpdateNickname() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.length < 2 || nickname.length > 15) {
      setState(() {
        _errorText = '공백 포함 최소 2자 이상 15자 이하로 입력해주세요.';
      });
    } else if (nickname == widget.nickname) {
      setState(() {
        _errorText = '기존 닉네임과 동일합니다.';
      });
    } else if (nickname.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorText = '특수문자는 사용할 수 없습니다.';
      });
    } else if (nickname.contains(RegExp(r'\s{2,}'))) {
      setState(() {
        _errorText = '공백은 연속으로 사용할 수 없습니다.';
      });
    } else {
      setState(() {
        _errorText = null; // 에러 메시지 초기화
      });

      final userViewModel = UserViewModel();
      final storageService = GlobalStorage();

      String? errorMessage = await userViewModel.updateUserNickname(nickname);
      if (errorMessage == null) {
        await storageService.setNicknameComplete();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const RootScreen(selectedIndex: 4)),
          (route) => false,
        );
        AmplitudeLogger.logClickEvent("nickname_update_click",
            "nickname_update_button", "nickname_form_screen");
      } else {
        setState(() {
          _errorText = errorMessage; // 에러 메시지 설정
        });
      }
    }
  }

  /// 라벨과 텍스트 입력 필드
  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.previousPage == 'my_page'
            ? Text(
                '닉네임',
                style: title_M.copyWith(color: AppColors.labelStrong),
              )
            : const SizedBox(),
        const SizedBox(height: 7),
        TextFormField(
          controller: _nicknameController,
          style: body_M.copyWith(color: AppColors.label),
          decoration: InputDecoration(
            hintText: '닉네임을 입력해주세요.',
            hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
            enabledBorder: OutlineInputBorder(
              borderSide: _errorText != null
                  ? BorderSide(color: AppColors.statusError)
                  : BorderSide(color: AppColors.line),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: _errorText != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.statusError),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.line),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _errorText = null; // 입력값이 변경될 때 에러 메시지 초기화
            });
          },
        ),
        const SizedBox(height: 8),
        if (_errorText != null)
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              _errorText!,
              style: subtitle_S.copyWith(color: AppColors.statusError),
            ),
          ),
        if (_errorText == null)
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '공백 포함 최소 2자 이상 15자 이하로 입력해주세요.',
              style: subtitle_S.copyWith(color: AppColors.labelAlternative),
            ),
          ),
      ],
    );
  }
}
