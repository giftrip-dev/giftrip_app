import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/formatter.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/features/notice/view_models/notice_view_model.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final Map<String, bool> _expandedStates = {}; // 아코디언 상태 관리

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeViewModel>().fetchNoticeList();
    });
    AmplitudeLogger.logViewEvent(
      'app_notice_screen_view',
      'app_notice_screen',
    );
  }

  void _toggleExpansion(String noticeId) {
    setState(() {
      _expandedStates[noticeId] = !(_expandedStates[noticeId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final noticeVM = context.watch<NoticeViewModel>();

    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '공지사항',
        type: BackButtonAppBarType.textLeft,
      ),
      body: noticeVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : noticeVM.noticeList.isEmpty
              ? Center(
                  child: Text(
                    '등록된 공지가 없어요.',
                    style: body_M.copyWith(color: AppColors.labelAssistive),
                  ),
                )
              : ListView.builder(
                  itemCount: noticeVM.noticeList.length,
                  itemBuilder: (context, index) {
                    final notice = noticeVM.noticeList[index];
                    final isExpanded = _expandedStates[notice.id] ?? false;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => _toggleExpansion(notice.id),
                          behavior: HitTestBehavior.opaque, // 빈 공간도 터치 가능하도록 설정
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateUtil.formatTimeAgo(
                                            notice.createdAt),
                                        style: caption.copyWith(
                                            color: AppColors.labelAlternative),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notice.title,
                                        style: subtitle_M,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? LucideIcons.chevronUp
                                      : LucideIcons.chevronDown,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: AppColors.backgroundAlternative,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice.content,
                                  style: body_S,
                                ),
                                if (notice.imageUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Image.network(
                                      notice.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const Divider(
                          color: AppColors.line,
                          height: 1,
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
