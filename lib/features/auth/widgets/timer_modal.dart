import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';

Future<void> timerModal({
  required BuildContext context,
  required String title,
  String? message,
  required String? btnText,
  required VoidCallback? onClick,
  required int timerSeconds,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return TimerModalDialog(
        title: title,
        message: message,
        btnText: btnText,
        onClick: onClick,
        initialTimerSeconds: timerSeconds,
      );
    },
  );
}

class TimerModalDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String? btnText;
  final VoidCallback? onClick;
  final int initialTimerSeconds;

  const TimerModalDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.btnText,
    required this.onClick,
    required this.initialTimerSeconds,
  }) : super(key: key);

  @override
  _TimerModalDialogState createState() => _TimerModalDialogState();
}

class _TimerModalDialogState extends State<TimerModalDialog> {
  late int _timerSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timerSeconds = widget.initialTimerSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Center(
        child: Text(widget.title, style: h2_S),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text.rich(
              TextSpan(
                style: body_M.copyWith(color: AppColors.label),
                children: [
                  TextSpan(text: '원활한 인증번호 발송을 위해\n60초 이후 다시 시도해주세요.'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              '남은 시간: ${_formatTime(_timerSeconds)}',
              style: body_M.copyWith(color: AppColors.statusError),
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onClick != null) {
                widget.onClick!();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width, 51)),
            child: Text(
              widget.btnText ?? "확인",
              style: h2_S.copyWith(color: AppColors.label),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsRemaining';
  }
}
