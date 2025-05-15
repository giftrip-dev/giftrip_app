import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/features/user/models/certificate_model.dart';
import 'package:giftrip/features/user/screens/initial_certificate_screen.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class Certificate {
  final String title;
  final String? pendingImagePath;
  final String? acceptImagePath;
  String? status;
  Certificate(
      {required this.title,
      this.pendingImagePath,
      this.acceptImagePath,
      this.status});
}

class CertificateBoard extends StatelessWidget {
  final List<CertificateModel>? certificates;
  late final List<Certificate> certificate;

  CertificateBoard({super.key, required this.certificates}) {
    certificate = [
      Certificate(
          title: '헤어',
          pendingImagePath: 'assets/images/icon/hair_black.png',
          acceptImagePath: 'assets/images/icon/hair.png',
          status: getCertificateStatus('HAIR') ?? 'NOT_REQUESTED'),
      Certificate(
          title: '메이크업',
          pendingImagePath: 'assets/images/icon/makeup_black.png',
          acceptImagePath: 'assets/images/icon/makeup.png',
          status: getCertificateStatus('MAKEUP') ?? 'NOT_REQUESTED'),
      Certificate(
          title: '네일',
          pendingImagePath: 'assets/images/icon/nail_black.png',
          acceptImagePath: 'assets/images/icon/nail.png',
          status: getCertificateStatus('NAIL') ?? 'NOT_REQUESTED'),
      Certificate(
          title: '피부',
          pendingImagePath: 'assets/images/icon/aesthetic_black.png',
          acceptImagePath: 'assets/images/icon/aesthetic.png',
          status: getCertificateStatus('SKIN_ESTHETIC') ?? 'NOT_REQUESTED'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF141313),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '나의 자격증',
                style: title_S.copyWith(color: AppColors.labelWhite),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: certificate
                  .map((cert) => _buildCertificate(cert, context))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificate(Certificate cert, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          cert.status == 'PENDING'
              ? Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Image.asset(cert.pendingImagePath!,
                      width: 32, height: 32),
                )
              : cert.status == 'ACCEPTED'
                  ? Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Image.asset(cert.acceptImagePath!,
                          width: 32, height: 32),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InitialCertificateScreen(
                              category:
                                  BeautyCategory.toEnglishString(cert.title),
                              previousPage: 'my_page',
                            ),
                          ),
                        );
                        AmplitudeLogger.logClickEvent(
                          'certificate_request_click',
                          'certificate_request_button',
                          '${cert.title == "헤어" ? "hair" : cert.title == "메이크업" ? "makeup" : cert.title == "네일" ? "nail" : cert.title == "피부" ? "skin_esthetic" : ""}_certificate_board',
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Center(
                          child: Icon(LucideIcons.plus,
                              color: AppColors.componentStrong),
                        ),
                      ),
                    ),
          SizedBox(height: 8),
          Text(cert.title,
              style: title_XS.copyWith(color: AppColors.labelWhite)),
        ],
      ),
    );
  }

  String? getCertificateStatus(String category) {
    final filteredCertificates =
        certificates?.where((cert) => cert.category == category).toList();
    return filteredCertificates?.isNotEmpty == true
        ? filteredCertificates!.first.status
        : null;
  }
}
