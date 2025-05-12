import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/pdf_download.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

Widget termsBox({
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          PdfDownloadUtil.downloadPdf(
            context: context,
            assetPath: 'assets/privacy-policy.pdf',
            fileName: 'privacy-policy.pdf',
          );
          AmplitudeLogger.logClickEvent(
              "privacy_policy_click", "privacy_policy_button", "login_screen");
        },
        child: Text('개인정보 처리방침',
            style: title_XS.copyWith(color: AppColors.labelAlternative)),
      ),
      const SizedBox(width: 24),
      Text('|', style: title_XS.copyWith(color: AppColors.line)),
      const SizedBox(width: 24),
      GestureDetector(
        onTap: () {
          PdfDownloadUtil.downloadPdf(
            context: context,
            assetPath: 'assets/service-terms.pdf',
            fileName: 'service-terms.pdf',
          );
          AmplitudeLogger.logClickEvent(
              "service_terms_click", "service_terms_button", "login_screen");
        },
        child: Text('서비스 이용 약관',
            style: title_XS.copyWith(color: AppColors.labelAlternative)),
      ),
    ],
  );
}
