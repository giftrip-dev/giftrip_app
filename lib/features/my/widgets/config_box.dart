import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/core/widgets/modal/two_button_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myong/core/utils/check_permission.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class ConfigBox extends StatefulWidget {
  const ConfigBox({
    super.key,
  });

  @override
  State<ConfigBox> createState() => _ConfigBoxState();
}

class _ConfigBoxState extends State<ConfigBox> with WidgetsBindingObserver {
  bool status = false;
  bool isToggleEnabled = true;
  final GlobalStorage _storage = GlobalStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotificationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeNotificationStatus();
    }
  }

  Future<void> _initializeNotificationStatus() async {
    await checkNotificationPermission(context);
    final permission = await _storage.getNotificationPermission();
    print('app permission : $permission');

    setState(() {
      status = permission == "granted"; // 권한이 부여된 경우 true
    });
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

      // 일정 시간 후에 권한 상태를 확인
      // Future.delayed(Duration(seconds: 2), () async {
      //   await _initializeNotificationStatus(); // 권한 상태 확인
      // });
    }
  }

  void _showNotificationDialog(bool newStatus) {
    String title;
    String desc;
    String confirmText;

    if (!newStatus) {
      title = '알림을 해제하시나요?';
      desc = '알림을 해제하면 내 게시글과\n 새로운 오늘묭해 소식을 받을 수 없어요';
      confirmText = '알림 해제하기';
    } else {
      title = '알림을 허용해 주세요';
      desc = '알림을 허용하면 내 게시글과\n 새로운 오늘묭해 소식을 알려드려요';
      confirmText = '알림 설정하기';
    }

    showDialog(
      context: context,
      builder: (context) {
        return TwoButtonModal(
          title: title,
          desc: desc,
          onConfirm: () {
            _openAppSettings(); // 앱 설정 열기
            setState(() {
              status = newStatus;
            });
            Navigator.of(context).pop();
          },
          cancelText: '취소',
          confirmText: confirmText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '앱설정',
            style: subtitle_L,
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '다크모드',
                    style: body_2.copyWith(color: AppColors.label),
                  ),
                  const Spacer(),
                  Text(
                    '시스템설정',
                    style: body_2.copyWith(color: AppColors.labelAlternative),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    '알림설정',
                    style: body_2.copyWith(color: AppColors.label),
                  ),
                  const Spacer(),
                  FlutterSwitch(
                    width: 51,
                    height: 31,
                    toggleSize: 27,
                    value: status,
                    borderRadius: 30,
                    padding: 2,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.componentNatural,
                    onToggle: (val) {
                      if (!isToggleEnabled) return; // 이미 비활성화된 경우
                      _showNotificationDialog(val); // 모달 표시
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
