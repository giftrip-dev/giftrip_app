import 'dart:async';
import 'package:flutter/material.dart';

import 'package:myong/features/auth/widgets/common_modal.dart';
import 'package:myong/features/auth/widgets/timer_modal.dart';
import 'package:myong/features/auth/widgets/signup_modal.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/text_field/custom_input_field.dart';

class Code {
  String? phoneNumber;
  String? type;
  String? code;

  Code({
    this.phoneNumber,
    this.type,
    this.code,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'type': type,
      'code': code,
    };
  }

  // 인증 코드 검증 요청 메서드
  Future<bool> verify(Code code) async {
    bool isVerified = false;

    try {
      if (code.code == '123456') {
        isVerified = true;
      }
    } catch (e) {
      isVerified = false;
    }

    return isVerified;
  }
}

class PhoneNumberVerification extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController verificationCodeController;
  final FocusScopeNode focusScopeNode;
  final VoidCallback onVerificationSuccess;
  final VoidCallback onVerificationFailure;
  final String type;

  const PhoneNumberVerification({
    Key? key,
    required this.phoneNumberController,
    required this.verificationCodeController,
    required this.focusScopeNode,
    required this.onVerificationSuccess,
    required this.onVerificationFailure,
    required this.type,
  }) : super(key: key);

  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  bool _isPhoneNumberSent = false;
  bool _isResend = false;
  bool _isCodeFilled = false;
  int _timerSeconds = 60;
  Timer? _timer;
  // bool _isMessageSendLoading = false;
  bool _isVerificationSuccessful = false;
  bool _isVerificationAttempted = false;
  String? _phoneNumberErrorText;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerSeconds = 60;
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
            _isPhoneNumberSent = false;
            _isCodeFilled = false;
            _isVerificationAttempted = false;
          }
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 60;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsRemaining';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 휴대폰 번호 입력 필드
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
                    errorText: null, // 에러 메시지는 아래에서 처리
                    isError: _phoneNumberErrorText != null,
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
                        : () async {
                            if (_isVerificationSuccessful) return;

                            if (widget.phoneNumberController.text.length < 11) {
                              setState(() {
                                _phoneNumberErrorText = '휴대폰 번호를 정확히 입력해주세요';
                              });
                              return;
                            }

                            if (!_isCodeFilled &&
                                widget.verificationCodeController.text
                                    .isNotEmpty) return;

                            if (_timerSeconds > 0 && _isPhoneNumberSent) {
                              timerModal(
                                context: context,
                                title: "인증번호 발송 대기",
                                btnText: "확인",
                                onClick: () {},
                                timerSeconds: _timerSeconds,
                              );
                              return;
                            }

                            if (_isCodeFilled) {
                              String phoneNumber =
                                  widget.phoneNumberController.text;

                              _isVerificationSuccessful = await Code().verify(
                                  Code(
                                      phoneNumber: phoneNumber,
                                      type: widget.type,
                                      code: widget
                                          .verificationCodeController.text));

                              if (_isVerificationSuccessful &&
                                  context.mounted) {
                                _isPhoneNumberSent = false;
                                widget.onVerificationSuccess();
                                commonModal(context: context, title: "인증 성공");
                              } else {
                                if (!context.mounted) return;
                                widget.onVerificationFailure();
                                commonModal(
                                    context: context,
                                    title: "인증 실패",
                                    desc: "인증번호를 확인해주세요");
                              }
                            } else if (widget
                                .phoneNumberController.text.isNotEmpty) {
                              String phoneNumber =
                                  widget.phoneNumberController.text;

                              // 임시로 인증번호 발송 성공으로 처리
                              setState(() {
                                _isPhoneNumberSent = true;
                                _isCodeFilled = false;
                                _isVerificationAttempted = false;
                                _isResend = true;
                              });

                              if (context.mounted) {
                                signupModal(
                                    context: context,
                                    titleText: "인증번호 발송 완료",
                                    description: "문자로 발송된 인증번호를 확인해주세요.",
                                    confirmButtonText: "확인",
                                    onConfirm: () {
                                      Navigator.pop(context);
                                    });
                                _startTimer();
                              }
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      backgroundColor:
                          widget.phoneNumberController.text.isEmpty ||
                                  _isVerificationSuccessful
                              ? AppColors.line
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
                            ? (_isResend ? AppColors.line : Colors.transparent)
                            : const Color(0xFF0E0E0F),
                        width: 1,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 60),
                      child: _isResend
                          ? Text(
                              "재전송",
                              style: title_S.copyWith(
                                color: _isVerificationSuccessful
                                    ? AppColors.line
                                    : AppColors.label,
                              ),
                            )
                          : Text(
                              "인증번호 받기",
                              style: title_S.copyWith(
                                color: AppColors.label,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (_phoneNumberErrorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(
                  _phoneNumberErrorText!,
                  style: TextStyle(color: AppColors.statusError, fontSize: 13),
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
                      enabled: _isPhoneNumberSent && !_isVerificationSuccessful,
                      isValid: _isVerificationSuccessful,
                      errorText: null, // 에러 메시지는 아래에서 처리
                      suffixIcon: _isPhoneNumberSent
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_isVerificationSuccessful)
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
                                    color: AppColors.primary,
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
                                !_isVerificationSuccessful
                            ? () async {
                                setState(() {
                                  _isVerificationAttempted = true;
                                });

                                if (widget
                                    .verificationCodeController.text.isEmpty) {
                                  setState(() {
                                    widget.verificationCodeController.text = '';
                                  });
                                  return;
                                }

                                String phoneNumber =
                                    widget.phoneNumberController.text;
                                bool isVerified = await Code().verify(Code(
                                    phoneNumber: phoneNumber,
                                    type: widget.type,
                                    code: widget
                                        .verificationCodeController.text));

                                if (isVerified) {
                                  setState(() {
                                    _isVerificationSuccessful = true;
                                  });
                                  widget.onVerificationSuccess();
                                } else {
                                  widget.onVerificationFailure();
                                }
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          backgroundColor: AppColors.primaryStrong,
                          foregroundColor: _isVerificationSuccessful
                              ? AppColors.line
                              : AppColors.labelWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          side: BorderSide(
                            color: _isVerificationSuccessful
                                ? AppColors.line
                                : AppColors.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _isPhoneNumberSent
                              ? (_isVerificationSuccessful ? "인증완료" : "인증확인")
                              : "인증확인",
                          style: title_S.copyWith(
                            color: AppColors.labelWhite,
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
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: Text(
                    '인증번호가 일치하지 않습니다.',
                    style:
                        TextStyle(color: AppColors.statusError, fontSize: 13),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
