import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/features/terms/screens/terms_agreement_screen.dart';
import 'package:myong/core/widgets/text_field/custom_input_field.dart';

class LoginInputFields extends StatefulWidget {
  const LoginInputFields({super.key});

  @override
  State<LoginInputFields> createState() => _LoginInputFieldsState();
}

class _LoginInputFieldsState extends State<LoginInputFields> {
  bool _obscureText = true;

  // 컨트롤러 추가
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: _idController,
          placeholder: '아이디를 입력해주세요',
        ),
        const SizedBox(height: 8),
        CustomInputField(
          controller: _pwController,
          placeholder: '비밀번호를 입력해주세요',
          isPassword: true,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.labelStrong,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13.5),
            ),
            onPressed: () {},
            child: const Text('로그인', style: title_S),
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAgreementScreen(),
                    ),
                  );
                },
                child: Text(
                  '회원가입',
                  style:
                      subtitle_XS.copyWith(color: AppColors.labelAlternative),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () {},
                child: Text(
                  '아이디 / 비밀번호 찾기',
                  style:
                      subtitle_XS.copyWith(color: AppColors.labelAlternative),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
