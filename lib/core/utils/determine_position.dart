import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String> determinePosition() async {
  // 위치 권한 요청
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return '위치 권한이 거부되었습니다.';
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return '위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.';
  }

  // 현재 위치 가져오기
  Position position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );

  // 위도, 경도로 주소 변환
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks.first;
    return "${place.country} ${place.administrativeArea} ${place.locality} ${place.subLocality}";
    // 예: 대한민국 서울특별시 강남구 역삼동
  } else {
    return "주소 정보를 찾을 수 없습니다.";
  }
}
