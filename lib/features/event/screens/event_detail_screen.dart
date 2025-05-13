import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/features/event/models/event_model.dart';
import 'package:myong/features/event/widgets/event_app_bar.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yy.MM.dd');
    final formattedDate = dateFormat.format(event.startDate);

    return Scaffold(
      appBar: const EventAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀 섹션
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.line,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: title_L,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: caption.copyWith(color: AppColors.labelNatural),
                    ),
                  ],
                ),
              ),
            ),
            // 디스크립션 섹션
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.description,
                    style: body_M,
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return CustomImage(
                        imageUrl: event.thumbnailUrl,
                        width: width,
                        height: width,
                        borderRadius: BorderRadius.circular(4),
                      );
                    },
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
