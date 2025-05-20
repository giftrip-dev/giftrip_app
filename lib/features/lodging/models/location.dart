enum MainLocation {
  seoul('서울'),
  busan('부산'),
  jeju('제주'),
  gyeonggi('경기'),
  incheon('인천'),
  gangwon('강원'),
  gyeongsang('경상'),
  jeolla('전라'),
  chungcheong('충청');

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
        mainLocation: MainLocation.seoul,
        subLocations: [
          '강남/역삼/삼성',
          '신사/청담/압구정',
          '서초/교대/사당',
          '잠실/송파/강동',
          '을지로/명동/중구/동대문',
          '서울역/이태원/용산',
          '종로/인사동',
          '홍대/합정/마포/서대문',
          '여의도',
          '영등포역',
          '구로/신도림/금천',
          '김포공항/염창/강서',
          '건대입구/성수/왕십리',
          '성북/강북/노원/도봉',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.busan,
        subLocations: [
          '해운대/마린시티',
          '벡스코/센텀시티',
          '송정/기장/정관',
          '광안리/경성대',
          '부산역',
          '자갈치/남포동/영도',
          '송도/다대포',
          '서면/연산/범일',
          '동래/온천/금정구',
          '사상/강서/김해공항/하단',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.jeju,
        subLocations: [
          '제주시/제주국제공항',
          '서귀포시/모슬포',
          '애월/한림/협재',
          '중문',
          '표선/성산',
          '함덕/김녕/세화'
        ],
      ),
      LocationData(
        mainLocation: MainLocation.gyeonggi,
        subLocations: [
          '가평/청평/양평',
          '수원/화성',
          '고양/파주/김포',
          '의정부/포천/동두천',
          '용인/동탄',
          '오산/평택',
          '남양주/구리/성남/분당',
          '이천/광주/여주/하남',
          '부천/광명/시흥/안산',
          '안양/의왕/군포',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.incheon,
        subLocations: [
          '송도/소래포구',
          '인천국제공항/강화/을왕리',
          '영종도/월미도',
          '주안/간석/인천시청',
          '청라/계양/부평',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.gangwon,
        subLocations: [
          '강릉',
          '속초/고성',
          '양양(서피비치/낙산)',
          '춘천/인제/철원',
          '평창/정선/영월',
          '동해/삼척/태백',
          '홍천/횡성/원주',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.gyeongsang,
        subLocations: [
          '대구/구미/안동/문경',
          '경주',
          '울산/양산/밀양',
          '거제/통영',
          '포항/영덕/울진/청송',
          '창원/마산/진해/김해/부곡',
          '남해/사천/하동/진주',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.jeolla,
        subLocations: [
          '전주/완주',
          '광주/나주/함평',
          '여수',
          '순천/광양/담양/보성/화순',
          '남원/부안/정읍/고창/무주/구례',
          '군산/익산',
          '목포/신안/영광/진도/고흥/완도/강진/해남',
        ],
      ),
      LocationData(
        mainLocation: MainLocation.chungcheong,
        subLocations: [
          '대전/세종',
          '천안/아산/도고',
          '당진/덕산/태안/서산/안면도',
          '보령/대천/부여/공주/금산',
          '청주/음성/진천',
          '충주/제천/단양/괴산/증평',
        ],
      ),
    ];
  }
}
