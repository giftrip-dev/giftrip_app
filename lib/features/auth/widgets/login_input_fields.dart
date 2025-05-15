import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/auth/screens/terms_agreement_screen.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/features/auth/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:giftrip/features/root/screens/root_screen.dart';

class LoginInputFields extends StatefulWidget {
  const LoginInputFields({super.key});

  @override
  State<LoginInputFields> createState() => _LoginInputFieldsState();
}

class _LoginInputFieldsState extends State<LoginInputFields> {
  // 컨트롤러 추가
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // 에러 메시지 상태 추가
  String? _idError;
  String? _pwError;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    setState(() {
      _idError = _idController.text.isEmpty ? '아이디를 입력해주세요' : null;
      _pwError = _pwController.text.isEmpty ? '비밀번호를 입력해주세요' : null;
    });

    if (_idError != null || _pwError != null) {
      developer.log(
        '''로그인 유효성 검사 실패:
        - 아이디 에러: ${_idError ?? '없음'}
        - 비밀번호 에러: ${_pwError ?? '없음'}''',
        name: 'LoginInputFields',
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.login(
      _idController.text,
      _pwController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? '로그인에 실패했습니다.'),
          backgroundColor: AppColors.statusError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Column(
      children: [
        CustomInputField(
          controller: _idController,
          placeholder: '아이디를 입력해주세요',
          errorText: _idError,
        ),
        const SizedBox(height: 8),
        CustomInputField(
          controller: _pwController,
          placeholder: '비밀번호를 입력해주세요',
          isPassword: true,
          errorText: _pwError,
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
            onPressed: authViewModel.isLoading ? null : _onLoginPressed,
            child: Text(
              authViewModel.isLoading ? '로그인 중...' : '로그인',
              style: title_S,
            ),
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
