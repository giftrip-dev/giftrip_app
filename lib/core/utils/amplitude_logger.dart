import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/services/storage_service.dart';

class AmplitudeLogger {
  static final Amplitude _amplitude = Amplitude(Configuration(
    apiKey: dotenv.maybeGet('AMPLITUDE_API_KEY') ?? '',
  ));

  static final storageService = GlobalStorage();
  static final userId = storageService.getAmplitudeUserId();

  static Future<void> logClickEvent(
      String eventName, String buttonName, String location) async {
    final String? currentUserId = await userId;
    if (currentUserId != null) {
      _amplitude
          .track(BaseEvent(eventName, userId: currentUserId, eventProperties: {
        "button_name": buttonName,
        "location": location,
      }));
    } else {
      _amplitude.track(BaseEvent(eventName, eventProperties: {
        "button_name": buttonName,
        "location": location,
      }));
    }
    _amplitude.flush();

    logger.d("Amplitude click event logged: $eventName");
  }

  static Future<void> logViewEvent(String eventName, String location) async {
    final String? currentUserId = await userId;
    if (currentUserId != null) {
      _amplitude
          .track(BaseEvent(eventName, userId: currentUserId, eventProperties: {
        "location": location,
      }));
    } else {
      _amplitude.track(BaseEvent(eventName, eventProperties: {
        "location": location,
      }));
    }
    _amplitude.flush();

    logger.d("Amplitude view event logged: $eventName");
  }
}
