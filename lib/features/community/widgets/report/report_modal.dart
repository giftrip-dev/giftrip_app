import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/features/community/models/dto/report_dto.dart';
import 'package:myong/features/community/repositories/report_repo.dart';
import 'package:myong/features/community/widgets/content_input_field.dart';
import 'package:myong/features/community/widgets/report/report_drop_down.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class ReportModal extends StatefulWidget {
  final String targetId;
  final String targetType;

  const ReportModal({
    super.key,
    required this.targetId,
    required this.targetType,
  });

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  final TextEditingController _detailController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // 내부 스크롤 컨트롤러 추가
  final FocusNode _detailFocusNode = FocusNode();
  final ReportRepo _reportRepo = ReportRepo();
  String? _selectedReason;

  // 에러 메시지 상태
  String? _reasonError; // 신고 사유 에러
  String? _detailError; // 상세 내용 에러

  final List<Map<String, String>> _reportReasons = [
    {'value': '1', 'text': '불법 및 유해 콘텐츠'},
    {'value': '2', 'text': '신체적,정신적 폭력을 조장하는 콘텐츠'},
    {'value': '3', 'text': '특정 집단(인종,성별,종교 등)에 대한 혐오 발언'},
    {'value': '4', 'text': '음란물 및 성적인 콘텐츠'},
    {'value': '5', 'text': '스팸 및 광고성 게시글'},
    {'value': '6', 'text': '기타'},
  ];

  // '신고하기' 버튼의 위치를 찾기 위한 GlobalKey 추가
  final GlobalKey _submitButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _detailFocusNode.addListener(_scrollToButton);
  }

  @override
  void dispose() {
    _detailController.dispose();
    _scrollController.dispose();
    _detailFocusNode.dispose();
    super.dispose();
  }

  /// **상세 내용 입력 필드에 포커스 시 '신고하기' 버튼까지 스크롤**
  void _scrollToButton() {
    if (_detailFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox? renderBox =
            _submitButtonKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null && _scrollController.hasClients) {
          final position = renderBox.localToGlobal(Offset.zero).dy;
          _scrollController.animateTo(
            position + 40,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  /// 신고 요청
  void _submitReport() async {
    setState(() {
      _reasonError = _selectedReason == null ? "신고 사유를 선택해 주세요." : null;
      _detailError = _detailController.text.trim().length < 10
          ? "최소 10자 이상 구체적으로 작성해주세요."
          : null;
    });

    if (_reasonError != null || _detailError != null) return;

    final reportDto = ReportDto(
      reason: _selectedReason!,
      detail: _detailController.text,
      targetId: widget.targetId,
      targetType: widget.targetType,
    );
    AmplitudeLogger.logClickEvent(
        "report_cta_click", "report_cta", "${widget.targetType}_report_modal");
    final result = await _reportRepo.reportContent(reportDto);
    if (result.isSuccess) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return OneButtonModal(
            title: '신고 접수 완료',
            desc: "신고가 정상적으로 완료되었습니다.\n 건전한 커뮤니티 환경 조성을 위해\n 최선을 다하겠습니다.",
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    } else {
      if (result.code == 400) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return OneButtonModal(
              title: '중복 신고 알림',
              desc: "이미 접수된 신고입니다.\n 건전한 커뮤니티 환경 조성을 위해\n 최선을 다하겠습니다.",
              onConfirm: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return RequestFailModal(
              onConfirm: () => Navigator.of(context).pop(),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Transform.translate(
      offset: Offset(0, -keyboardHeight / 10), // 키보드 높이의 절반만큼 모달창 자체 이동
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // 입력창 외부 클릭 시 키보드 닫기
          },
          behavior: HitTestBehavior.opaque, // 빈 공간 클릭 감지
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 348),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // 키보드 높이만큼 여백 추가
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 헤더
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('신고하기', style: title_L),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(LucideIcons.x, size: 18),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        Text(
                          '신고된 게시글 및 댓글은 24시간 내 검토 후 조치를 취합니다.',
                          style: subtitle_XS.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 14),

                        /// 신고 사유 드롭다운
                        Text('신고 사유', style: title_S),
                        const SizedBox(height: 8),
                        ReportDropDown(
                          items: _reportReasons,
                          hintText: "신고 사유를 선택해주세요.",
                          value: _selectedReason,
                          errorText: _reasonError,
                          onChanged: (value) {
                            setState(() {
                              _selectedReason = value;
                              _reasonError = null; // 선택 시 에러 메시지 제거
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        Text('상세 내용', style: title_S),
                        const SizedBox(height: 8),

                        /// 상세 내용 입력 필드 (유동적인 높이 적용)
                        Flexible(
                          child: ContentInputField(
                            controller: _detailController,
                            placeholder: "내용을 입력해주세요.",
                            errorText: _detailError,
                            minLen: 10,
                            maxLen: 300,
                            focusNode: _detailFocusNode,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 신고하기 버튼
                        ElevatedButton(
                          key: _submitButtonKey,
                          onPressed: _submitReport,
                          child: const Text('신고하기'),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
