import 'package:flutter/material.dart';
import 'package:giftrip/features/lodging/models/lodging_room_model.dart';
import 'package:giftrip/features/lodging/widgets/room_item.dart';

class RoomList extends StatelessWidget {
  final List<LodgingRoomModel> rooms;
  final double width;
  final double height;

  const RoomList({
    super.key,
    required this.rooms,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rooms.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          RoomItem(
            room: rooms[i],
            width: width,
            height: height,
          ),
        ]
      ],
    );
  }
}
