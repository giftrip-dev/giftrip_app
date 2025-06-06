import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

/// 버튼 타입 정의
enum CTAButtonType {
  primary, // 기본 프라이머리 버튼
  outline, // 아웃라인 버튼
  whiteFill, // 화이트 채운 버튼
  fillOutline, // 채운 아웃라인 버튼
}

/// 아웃라인 버튼 크기 정의
enum CTAButtonSize {
  extraLarge, // 아웃라인 엑스트라 라지 버튼
  large, // 아웃라인 라지 버튼
  medium, // 아웃라인 미디엄 버튼
}

class CTAButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final CTAButtonType type;
  final CTAButtonSize? size; // 아웃라인 버튼일 때만 사용됨
  final Color? fillColor;

  const CTAButton({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.type = CTAButtonType.primary, // 기본값은 프라이머리 버튼
    this.size, // 아웃라인 버튼일 때만 필요
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: _getButtonStyle(),
        child: Text(
          text,
          style: _getTextStyle().copyWith(
            height: 1,
          ),
        ),
      ),
    );
  }

  /// 버튼 높이 계산
  double _getButtonHeight() {
    switch (size) {
      case CTAButtonSize.extraLarge:
        return 59;
      case CTAButtonSize.large:
        return 48;
      case CTAButtonSize.medium:
        return 37;
      case null:
        return 48;
    }
  }

  /// 버튼 스타일 계산
  ButtonStyle _getButtonStyle() {
    switch (type) {
      case CTAButtonType.primary:
        return ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: AppColors.componentNatural,
          backgroundColor: AppColors.primaryStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case CTAButtonType.whiteFill:
        return ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      case CTAButtonType.outline:
        final verticalPadding = size == CTAButtonSize.medium ? 8.0 : 13.5;
        return ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: size == CTAButtonSize.medium
                ? BorderRadius.circular(6)
                : BorderRadius.circular(12),
            side: BorderSide(
              color:
                  isEnabled ? AppColors.lineStrong : AppColors.componentNatural,
              width: 1,
            ),
          ),
        );
      case CTAButtonType.fillOutline:
        return ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 0),
          backgroundColor: fillColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: size == CTAButtonSize.medium
                ? BorderRadius.circular(6)
                : BorderRadius.circular(12),
            side: BorderSide(
              color:
                  isEnabled ? AppColors.lineStrong : AppColors.componentNatural,
              width: 1,
            ),
          ),
        );
    }
  }

  /// 텍스트 스타일 계산
  TextStyle _getTextStyle() {
    if (textStyle != null) {
      return textStyle!;
    }

    switch (type) {
      case CTAButtonType.primary:
        return isEnabled
            ? title_L.copyWith(color: AppColors.labelWhite)
            : title_L.copyWith(color: AppColors.labelAlternative);
      case CTAButtonType.outline:
        if (size == CTAButtonSize.extraLarge) {
          return isEnabled
              ? subtitle_L.copyWith(color: AppColors.labelStrong)
              : subtitle_L.copyWith(color: AppColors.labelAlternative);
        }
        return isEnabled
            ? title_S.copyWith(color: AppColors.labelStrong)
            : title_S.copyWith(color: AppColors.labelAlternative);
      case CTAButtonType.whiteFill:
        if (size == CTAButtonSize.extraLarge) {
          return isEnabled
              ? subtitle_L.copyWith(color: AppColors.labelStrong)
              : subtitle_L.copyWith(color: AppColors.labelAlternative);
        }
        return isEnabled
            ? title_S.copyWith(color: AppColors.labelStrong)
            : title_S.copyWith(color: AppColors.labelAlternative);
      case CTAButtonType.fillOutline:
        return isEnabled
            ? title_S.copyWith(color: AppColors.labelStrong)
            : title_S.copyWith(color: AppColors.labelAlternative);
    }
  }
}
