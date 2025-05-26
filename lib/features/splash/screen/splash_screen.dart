import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/auth/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/widgets/modal/permission_guide_modal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final storage = GlobalStorage();
    final isFirstLaunch = await storage.getIsFirstLaunch() ?? true;

    if (isFirstLaunch) {
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PermissionGuideModal(
          onConfirm: () {
            Navigator.of(context).pop();
            _navigateToNextScreen();
          },
        ),
      );
      await storage.setIsFirstLaunch(false);
    } else {
      _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // 1초간 대기 (로딩 시간)
    if (!mounted) return; // 위젯이 존재하는지 확인

    final nextScreen = await context.read<AuthViewModel>().checkAutoLogin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.white,
        child: Center(
            child: CustomImage(
          imageUrl: 'assets/webp/splash.webp',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
