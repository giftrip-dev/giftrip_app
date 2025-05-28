import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/widgets/modal/outline_two_button_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:giftrip/core/utils/check_permission.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class SwitchBox extends StatefulWidget {
  const SwitchBox({
    super.key,
  });

  @override
  State<SwitchBox> createState() => _SwitchBoxState();
}

class _SwitchBoxState extends State<SwitchBox> with WidgetsBindingObserver {
  bool status = false;
  bool isToggleEnabled = true;
  bool marketingAgree = false;
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
        data: 'package:kr.co.giftrip.app', // 앱 패키지명으로 변경
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
    showDialog(
      context: context,
      builder: (context) {
        return OutlineTwoButtonModal(
          title: '앱 내 푸시 알림 설정을\n 해제하시나요?',
          desc: '원할한 주문/예약/배송을 위해 앱 푸시 알림을\n 켜놓는 것을 권장해드려요.',
          onCancel: () {
            _openAppSettings(); // 앱 설정 열기
            setState(() {
              status = newStatus;
            });
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
          },
          cancelText: '해제하기',
          confirmText: '알림 받기',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '알림 설정',
            style: title_S.copyWith(color: AppColors.labelStrong),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '앱 내 푸시 알림 설정',
                    style: body_M.copyWith(color: AppColors.label),
                  ),
                  const Spacer(),
                  FlutterSwitch(
                    width: 51,
                    height: 31,
                    toggleSize: 27,
                    value: status,
                    borderRadius: 30,
                    padding: 2,
                    activeColor: AppColors.primaryStrong,
                    inactiveColor: AppColors.componentNatural,
                    onToggle: (val) {
                      if (!isToggleEnabled) return;
                      if (val) {
                        _openAppSettings();
                      } else {
                        _showNotificationDialog(val);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    '마케팅 수신 동의',
                    style: body_M.copyWith(color: AppColors.label),
                  ),
                  const Spacer(),
                  FlutterSwitch(
                    width: 51,
                    height: 31,
                    toggleSize: 27,
                    value: marketingAgree,
                    borderRadius: 30,
                    padding: 2,
                    activeColor: AppColors.primaryStrong,
                    inactiveColor: AppColors.componentNatural,
                    onToggle: (val) {
                      if (!val) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return OutlineTwoButtonModal(
                              title: '기프트립의 새로운 소식을\n 더이상 받지 않으시나요?',
                              desc: '알림을 해제하시면 특가 가격의 상품들을\n 놓칠 수 있는데 괜찮으신가요?',
                              onCancel: () {
                                setState(() {
                                  marketingAgree = val;
                                });
                                Navigator.of(context).pop();
                              },
                              onConfirm: () {
                                Navigator.of(context).pop();
                              },
                              cancelText: '해제하기',
                              confirmText: '알림 받기',
                            );
                          },
                        );
                      } else {
                        setState(() {
                          marketingAgree = val;
                        });
                      }
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
