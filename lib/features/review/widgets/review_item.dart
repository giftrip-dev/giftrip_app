import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/review/models/review_model.dart';
import 'dart:ui' as ui;

class ReviewItem extends StatefulWidget {
  final ReviewModel review;

  const ReviewItem({
    required this.review,
    super.key,
  });

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  /// 날짜를 YY.MM.DD 형식으로 변환
  String _formatDate(DateTime date) {
    final formatter = DateFormat('yy.MM.dd');
    return formatter.format(date);
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 딤 처리된 배경
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            // 이미지
            InteractiveViewer(
              child: Center(
                child: CustomImage(
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 닫기 버튼
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted = _formatDate(widget.review.createdAt);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 닉네임, 별점, 날짜 행
          Row(
            children: [
              Text(widget.review.userNickname, style: subtitle_S),
              const SizedBox(width: 9),
              Row(
                children: List.generate(
                  widget.review.rating.toInt(),
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index < widget.review.rating.toInt() - 1 ? 2 : 0,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: AppColors.primarySoft,
                      size: 13,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                createdAtFormatted,
                style: body_S.copyWith(color: AppColors.labelAlternative),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 콘텐츠 + 선택적 썸네일
          widget.review.thumbnailUrl != null
              ? _buildContentWithThumbnail()
              : _buildContentOnly(),
        ],
      ),
    );
  }

  Widget _buildContentText() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // overflow 체크를 위한 TextPainter
        final span = TextSpan(
          text: widget.review.content,
          style: body_S.copyWith(color: AppColors.label),
        );
        final tp = TextPainter(
          text: span,
          textDirection: ui.TextDirection.ltr,
          maxLines: 2,
        )..layout(maxWidth: constraints.maxWidth);

        final didOverflow = tp.didExceedMaxLines;
        // state 업데이트 (한 번만)
        if (didOverflow != _isOverflowing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isOverflowing = didOverflow);
            }
          });
        }

        return Text(
          widget.review.content,
          style: body_S.copyWith(color: AppColors.label),
          maxLines: _isExpanded ? null : 2,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildContentWithThumbnail() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContentText(),
              if (!_isExpanded && _isOverflowing)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _isExpanded = true),
                    child: Text(
                      '더보기',
                      style: body_S.copyWith(
                        color: AppColors.labelStrong,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () =>
              _showFullScreenImage(context, widget.review.thumbnailUrl!),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CustomImage(
              imageUrl: widget.review.thumbnailUrl!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentOnly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentText(),
        if (!_isExpanded && _isOverflowing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = true),
              child: Text(
                '더보기',
                style: body_S.copyWith(
                  color: AppColors.labelStrong,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
