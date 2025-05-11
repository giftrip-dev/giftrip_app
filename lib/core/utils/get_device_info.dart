import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:myong/core/services/storage_service.dart';

Future<Map<String, String?>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? deviceId;
  String? deviceModel;
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    deviceId = androidInfo.id; // Android ID
    deviceModel = androidInfo.model; // Android 모델명
    // await GlobalStorage().setDeviceId(deviceId);
    // await GlobalStorage().setDeviceModel(deviceModel);
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    deviceId = iosInfo.identifierForVendor; // iOS ID
    deviceModel = iosInfo.model; // iOS 모델명
    // await GlobalStorage().setDeviceId(deviceId ?? '');
    // await GlobalStorage().setDeviceModel(deviceModel);
  }

  await GlobalStorage().setDeviceId(deviceId ?? '');
  await GlobalStorage().setDeviceModel(deviceModel ?? '');
  print('Device ID: $deviceId');
  print('Device Model: $deviceModel');

  return {
    'deviceId': deviceId,
    'deviceModel': deviceModel,
  };
}
