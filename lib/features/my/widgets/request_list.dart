import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/my/models/request_model.dart';
import 'request_item.dart';

class RequestList extends StatelessWidget {
  final List<RequestModel> requests;

  const RequestList({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          '목록이 없습니다.',
          style: body_M.copyWith(
            color: AppColors.labelAlternative,
          ),
        ),
      );
    }
    return Column(
      children:
          requests.map((request) => RequestItem(request: request)).toList(),
    );
  }
}
