import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/event/models/event_model.dart';
import 'package:giftrip/features/event/screens/event_detail_screen.dart';

class EventItem extends StatelessWidget {
  final EventModel event;

  const EventItem({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM.dd');
    final startDate = dateFormat.format(event.startDate);
    final endDate = dateFormat.format(event.endDate);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 239),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              imageUrl: event.thumbnailUrl,
              width: double.infinity,
              height: 145,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: subtitle_XS,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                event.description,
                style: body_S,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '이벤트 기간 : $startDate - $endDate',
              style: caption.copyWith(color: AppColors.labelNatural),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
