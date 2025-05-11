import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/features/user/screens/nickname_form_screen.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class AccountBoxWidget extends StatelessWidget {
  final String nickname;
  final String email;

  const AccountBoxWidget({
    Key? key,
    required this.nickname,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정',
            style: subtitle_L,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '닉네임',
                  style: body_2.copyWith(color: AppColors.label),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NicknameFormScreen(
                                    previousPage: 'my_page',
                                    nickname: nickname,
                                  )),
                        );
                        AmplitudeLogger.logClickEvent(
                          'nickname_change_click',
                          'nickname_change_button',
                          'my_page',
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            nickname,
                            style: body_3.copyWith(color: AppColors.label),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            LucideIcons.chevronRight,
                            color: AppColors.labelAlternative,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이메일',
                  style: body_2.copyWith(color: AppColors.label),
                ),
                Text(
                  email,
                  style: body_3.copyWith(color: AppColors.labelAlternative),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
