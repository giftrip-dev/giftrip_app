enum MainLocation {
  CAPITAL('수도권'),
  GANGWON('강원도'),
  GYEONGSANG('경상도'),
  CHUNGCHONG('충청도'),
  JEONLA('전라도'),
  JEJU('제주도');

  final String label;
  const MainLocation(this.label);
}

class LocationData {
  final MainLocation mainLocation;
  final List<String> subLocations;
  final Function(String)? onSubLocationTap;

  const LocationData({
    required this.mainLocation,
    required this.subLocations,
    this.onSubLocationTap,
  });
}

class LocationManager {
  static List<LocationData> getLocationData() {
    return [
      LocationData(
        mainLocation: MainLocation.CAPITAL,
        subLocations: [
          '서울',
          '인천',
          '가평/남양주/포천',
          '용인/수원/화성/평택',
          '파주/고양/김포',
          '이천/여주/안성/광주',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.GANGWON,
        subLocations: [
          '강릉/속초/양양',
          '춘천/인제/철원',
          '평창/정선/영월',
          '동해/삼척/태백',
          '홍천/횡성/원주',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.GYEONGSANG,
        subLocations: [
          '부산',
          '경주/포항',
          '대구',
          '울산/양산/밀양',
          '거제/통영/남해',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.CHUNGCHONG,
        subLocations: [
          '대전/세종',
          '충주/제천/단양',
          '태안/서산/보령',
          '청주/천안',
          '부여/공주',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.JEONLA,
        subLocations: [
          '전주/군산',
          '광주/나주/담양',
          '여수/순천/보성',
          '목포/해남/진도',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.JEJU,
        subLocations: [
          '제주시',
          '서귀포시',
        ],
      ),
    ];
  }
}
