import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text("회원가입", style: title_M.copyWith(color: AppColors.labelStrong)),
        titleSpacing: 0,
      ),
      body: Container(),
    );
  }
}
