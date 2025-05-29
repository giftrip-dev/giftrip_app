import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/logger.dart';

import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/text_field/custom_input_field.dart';
import 'package:giftrip/core/widgets/modal/one_button_modal.dart';
import 'package:giftrip/features/auth/models/verification_code_model.dart';
import 'package:giftrip/features/auth/repositories/verification_repo.dart';

class PhoneNumberVerification extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController verificationCodeController;
  final FocusScopeNode focusScopeNode;
  final VoidCallback onVerificationSuccess;
  final VoidCallback onVerificationFailure;
  final String type;
  final bool isFormSubmitted;

  const PhoneNumberVerification({
    super.key,
    required this.phoneNumberController,
    required this.verificationCodeController,
    required this.focusScopeNode,
    required this.onVerificationSuccess,
    required this.onVerificationFailure,
    required this.type,
    this.isFormSubmitted = false,
  });

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final VerificationRepository _verificationRepo = VerificationRepository();
  bool _isPhoneNumberSent = false;
  bool _isResend = false;
  bool _hasEverSentCode = false;
  bool _isTimerExpired = false;
  bool _isCodeFilled = false;
  int _timerSeconds = 180;
  Timer? _timer;
  bool _isVerificationSuccessful = false;
  bool _isVerificationAttempted = false;
  String? _phoneNumberErrorText;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerSeconds = 180;
    _isTimerExpired = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          if (!_isVerificationSuccessful) {
            widget.verificationCodeController.text = '';
            _isCodeFilled = false;
            _isVerificationAttempted = false;
            _isTimerExpired = true;
          }
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 180;
      _isTimerExpired = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsRemaining';
  }

  Future<void> _sendVerificationCode() async {
    if (_isVerificationSuccessful) return;

    if (widget.phoneNumberController.text.length < 11) {
      setState(() {
        _phoneNumberErrorText = '휴대폰 번호를 정확히 입력해주세요';
      });
      return;
    }

    if (!_isCodeFilled && widget.verificationCodeController.text.isNotEmpty)
      return;

    if (_timerSeconds > 0 && _isPhoneNumberSent) {
      showDialog(
        context: context,
        builder: (context) => OneButtonModal(
          title: "인증번호 재전송 대기",
          desc: "원활한 인증을 위해 1분 후 다시 시도해주세요.",
          onConfirm: () {
            Navigator.pop(context);
          },
        ),
      );
      return;
    }

    final success = await _verificationRepo.sendVerificationCode(
      widget.phoneNumberController.text,
    );
    // 휴대폰 인증 조건 (문자 메시지 기능 활성화 시 && success.isSended! 로 변경)
    if (success.isSended != null) {
      setState(() {
        _isResend = _isPhoneNumberSent;
        _hasEverSentCode = true;
        _isPhoneNumberSent = true;
        _isCodeFilled = false;
        _isVerificationAttempted = false;
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => OneButtonModal(
            title: _isResend ? "인증번호를 재전송하였습니다." : "인증번호를 전송했습니다.",
            desc: "해당 번호의 메신저함을 확인해주세요.",
            onConfirm: () => Navigator.pop(context),
          ),
        );
        _startTimer();
      }
    } else {
      logger.e(success.error?.message);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => OneButtonModal(
            title: "인증번호 전송 실패",
            desc: "잠시 후 다시 시도해주세요.",
            onConfirm: () => Navigator.pop(context),
          ),
        );
      }
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isVerificationAttempted = true;
    });

    if (widget.verificationCodeController.text.isEmpty) {
      setState(() {
        widget.verificationCodeController.text = '';
      });
      return;
    }

    final result = await _verificationRepo.verifyCode(
      VerificationCode(
        phone: widget.phoneNumberController.text,
        code: widget.verificationCodeController.text,
      ),
    );

    if (result.isVerified != null && result.isVerified!) {
      setState(() {
        _isVerificationSuccessful = true;
      });
      widget.onVerificationSuccess();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => OneButtonModal(
            title: "인증이 완료되었습니다",
            onConfirm: () => Navigator.pop(context),
          ),
        );
      }
    } else {
      widget.onVerificationFailure();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => OneButtonModal(
            title: "인증 실패",
            desc: result.error?.message ?? "인증번호를 확인해주세요",
            onConfirm: () => Navigator.pop(context),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CustomInputField(
                    controller: widget.phoneNumberController,
                    placeholder: "휴대폰 번호 '-'없이 입력",
                    enabled: !_isVerificationSuccessful &&
                        (!_isPhoneNumberSent || _timerSeconds == 0),
                    errorText: null,
                    isError: _phoneNumberErrorText != null ||
                        (widget.isFormSubmitted &&
                            !_isPhoneNumberSent &&
                            !_isVerificationSuccessful),
                    onChanged: (value) {
                      if (value.length > 11) {
                        widget.phoneNumberController.text =
                            value.substring(0, 11);
                        widget.phoneNumberController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: widget.phoneNumberController.text.length),
                        );
                        return;
                      }
                      _stopTimer();
                      setState(() {
                        _isPhoneNumberSent = false;
                        _isVerificationSuccessful = false;
                        _isCodeFilled = false;
                        widget.verificationCodeController.text = '';
                        _phoneNumberErrorText = null;
                        if (value.isEmpty) {
                          widget.phoneNumberController.text = '';
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: widget.phoneNumberController.text.isEmpty ||
                            _isVerificationSuccessful
                        ? null
                        : _sendVerificationCode,
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      backgroundColor:
                          widget.phoneNumberController.text.isEmpty ||
                                  _isVerificationSuccessful
                              ? AppColors.componentNatural
                              : Colors.white,
                      foregroundColor: _isVerificationSuccessful
                          ? const Color(0xFFDADCE3)
                          : AppColors.labelStrong,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.5,
                      ),
                      side: BorderSide(
                        color: widget.phoneNumberController.text.isEmpty ||
                                _isVerificationSuccessful
                            ? (_isResend
                                ? AppColors.componentNatural
                                : Colors.transparent)
                            : const Color(0xFF0E0E0F),
                        width: 1,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 5),
                      child: _hasEverSentCode
                          ? Text(
                              "재전송",
                              style: title_S.copyWith(
                                color: _isVerificationSuccessful
                                    ? AppColors.labelAlternative
                                    : AppColors.labelStrong,
                              ),
                            )
                          : Text(
                              "인증번호 받기",
                              style: title_S.copyWith(
                                color: widget.phoneNumberController.text.isEmpty
                                    ? AppColors.labelAlternative
                                    : AppColors.labelStrong,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (_phoneNumberErrorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Text(
                  _phoneNumberErrorText!,
                  style: subtitle_S.copyWith(color: AppColors.statusError),
                ),
              ),
            if (widget.isFormSubmitted &&
                !_isPhoneNumberSent &&
                !_isVerificationSuccessful &&
                _phoneNumberErrorText == null)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Text(
                  '휴대폰 번호 인증을 완료해주세요',
                  style: subtitle_S.copyWith(color: AppColors.statusError),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isPhoneNumberSent)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: CustomInputField(
                      controller: widget.verificationCodeController,
                      placeholder: "인증번호 6자리",
                      enabled: _isPhoneNumberSent &&
                          !_isVerificationSuccessful &&
                          !_isTimerExpired,
                      isValid: _isVerificationSuccessful,
                      errorText: null,
                      isError: (_isVerificationAttempted &&
                              !_isVerificationSuccessful &&
                              widget.verificationCodeController.text
                                  .isNotEmpty) ||
                          (widget.isFormSubmitted &&
                              _isPhoneNumberSent &&
                              !_isVerificationSuccessful),
                      suffixIcon: _isPhoneNumberSent
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_isVerificationSuccessful &&
                                    !_isTimerExpired)
                                  Text(
                                    _formatTime(_timerSeconds),
                                    style: body_S.copyWith(
                                      color: _timerSeconds <= 10
                                          ? AppColors.statusError
                                          : AppColors.labelAssistive,
                                    ),
                                  ),
                                if (_isVerificationSuccessful)
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.primaryStrong,
                                  ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _isPhoneNumberSent &&
                                !_isVerificationSuccessful &&
                                !_isTimerExpired
                            ? _verifyCode
                            : null,
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          backgroundColor: _isTimerExpired
                              ? AppColors.componentNatural
                              : AppColors.primaryStrong,
                          foregroundColor: _isVerificationSuccessful
                              ? AppColors.line
                              : _isTimerExpired
                                  ? AppColors.labelAlternative
                                  : AppColors.labelWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          side: BorderSide(
                            color: _isVerificationSuccessful
                                ? AppColors.line
                                : _isTimerExpired
                                    ? Colors.transparent
                                    : AppColors.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _isPhoneNumberSent
                              ? (_isVerificationSuccessful
                                  ? "인증완료"
                                  : _isTimerExpired
                                      ? "인증시간 만료"
                                      : "인증확인")
                              : "인증확인",
                          style: title_S.copyWith(
                            color: _isTimerExpired
                                ? AppColors.labelAlternative
                                : AppColors.labelWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isVerificationAttempted &&
                  !_isVerificationSuccessful &&
                  widget.verificationCodeController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    '인증번호가 일치하지 않습니다.',
                    style: subtitle_S.copyWith(color: AppColors.statusError),
                  ),
                ),
              if (widget.isFormSubmitted &&
                  _isPhoneNumberSent &&
                  !_isVerificationSuccessful &&
                  !_isVerificationAttempted)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    '휴대폰 번호 인증을 완료해주세요',
                    style: subtitle_S.copyWith(color: AppColors.statusError),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
