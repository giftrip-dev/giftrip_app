import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        type: BackButtonAppBarType.textCenter,
        title: '회원관리',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('회원 정보', style: title_S),
            const SizedBox(height: 12),
            _InfoRow(label: '이름', value: '홍길동'),
            _InfoRow(label: '이메일', value: 'daggle@naver.com'),
            _InfoRow(label: '연락처', value: '010-1234-5678'),
            Row(
              children: [
                const SizedBox(
                  width: 60,
                  child: Text('등급', style: TextStyle(color: Color(0xFF474953))),
                ),
                const SizedBox(width: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.statusClear,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '인플루언서',
                    style: subtitle_XS.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('배송 정보', style: title_S),
            const SizedBox(height: 12),
            _InfoRow(label: '이름', value: '홍길동'),
            _InfoRow(label: '연락처', value: '010-1234-5678'),
            _InfoRow(
              label: '주소',
              value: '[12345]\n서울 논현로 98길 23 (역삼동) 오피스타워',
              isAddress: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lineStrong),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '수정하기',
                      style: subtitle_XS.copyWith(color: AppColors.labelStrong),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAddress;
  final Widget? child;
  const _InfoRow({
    required this.label,
    required this.value,
    this.isAddress = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child:
                Text(label, style: body_S.copyWith(color: Color(0xFF474953))),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: child == null
                ? Text(
                    value,
                    style: body_S.copyWith(color: AppColors.labelStrong),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: body_S.copyWith(color: AppColors.labelStrong),
                      ),
                      child!,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
