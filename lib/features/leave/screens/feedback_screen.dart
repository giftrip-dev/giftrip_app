import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/features/leave/view_models/leave_view_model.dart';
import 'package:myong/features/leave/screens/feedback_complete_screen.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // 불편 사항 데이터
  static const List<String> feedbackOptions = [
    '자주 이용하는 다른 커뮤니티가 있어요.',
    '새로운 콘텐츠가 부족해요.',
    '서비스 이용 중 기술적인 오류 발생이 잦아요.',
    '서비스를 이용할 시간이 없어요.',
    '서비스가 활성화 되어있지 않아요.',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_feedback_screen_view", "app_feedback_screen");
  }

  // 힌트 텍스트를 동적으로 반환하는 함수
  String getHintText(int feedbackNumber) {
    switch (feedbackNumber) {
      case 1:
        return '어떤 커뮤니티를 이용하시나요?';
      case 2:
        return '원하시는 콘텐츠 또는 서비스가 있으신가요?';
      case 3:
        return '어느 부분에서 가장 불편함을 크게 느끼셨나요?';
      case 6:
        return '서비스 이용 중 어떤 불편함을 느끼셨나요?';
      default:
        return '상세 내용 입력';
    }
  }

  void handleSubmit(BuildContext context) async {
    final viewModel = Provider.of<FeedbackViewModel>(context, listen: false);

    bool isSuccess = await viewModel.submitFeedback();

    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FeedbackCompleteScreen()),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => RequestFailModal(
          onConfirm: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FeedbackViewModel>(context, listen: true);

    return Scaffold(
      appBar: BackButtonAppBar(type: BackButtonAppBarType.none),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '오늘묭해 피드백',
              style: title_S.copyWith(color: AppColors.statusClear),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              '오늘묭해 서비스 이용 중\n어떤 불편함을 느끼셨나요?',
              style: h1_M,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  ...List.generate(feedbackOptions.length, (index) {
                    final feedbackNumber = index + 1;
                    final feedbackText = feedbackOptions[index];
                    final isSelected =
                        viewModel.selectedFeedbacks.contains(feedbackNumber);
                    final requiresDetail =
                        [1, 2, 3, 6].contains(feedbackNumber);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => viewModel.toggleFeedback(feedbackNumber),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.lineStrong,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                        weight: 10,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feedbackText,
                                  style: body_2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected && requiresDetail)
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 0),
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: viewModel
                                    .getDetailController(feedbackNumber),
                                style: body_2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: AppColors.line),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: AppColors.line),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: AppColors.line),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  hintText: getHintText(feedbackNumber),
                                  hintStyle: body_2.copyWith(
                                      color: AppColors.labelAssistive),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 40),
                      ],
                    );
                  }),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: viewModel.isButtonEnabled
                        ? () => handleSubmit(context)
                        : null,
                    child: Text('다음'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
