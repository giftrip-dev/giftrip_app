import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/auth/widgets/bottom_cta_button.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/lodging/widgets/location_tab.dart';
import 'package:giftrip/features/lodging/widgets/sub_category_item.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/screens/lodging_screen.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  final String? currentLocation;

  const LocationScreen({
    super.key,
    this.currentLocation,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _selectedIndex = 0;
  String? _selectedSubLocation;
  late final List<LocationData> _locationData;

  @override
  void initState() {
    super.initState();
    _locationData = LocationManager.getLocationData();

    // 현재 선택된 위치가 있다면 해당 위치의 인덱스와 서브카테고리를 찾아서 설정
    if (widget.currentLocation != null) {
      for (int i = 0; i < _locationData.length; i++) {
        final subLocations = _locationData[i].subLocations;
        final index = subLocations.indexOf(widget.currentLocation!);
        if (index != -1) {
          _selectedIndex = i;
          _selectedSubLocation = widget.currentLocation;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(
        title: '위치 선택',
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: AppColors.line,
          ),
          Expanded(
            child: Row(
              children: [
                // 왼쪽 카테고리 탭 메뉴
                Container(
                  width: 100,
                  color: AppColors.backgroundNatural,
                  child: Column(
                    children: List.generate(_locationData.length, (index) {
                      return LocationTab(
                        title: _locationData[index].mainLocation.label,
                        isSelected: _selectedIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _selectedSubLocation = null;
                          });
                        },
                      );
                    }),
                  ),
                ),
                // 오른쪽 서브 카테고리 메뉴
                Expanded(
                  child: ListView(
                    children: _locationData[_selectedIndex]
                        .subLocations
                        .map((item) => SubCategoryItem(
                              title: item,
                              categoryIndex: _selectedIndex,
                              isSelected: _selectedSubLocation == item,
                              onTap: () {
                                setState(() {
                                  _selectedSubLocation = item;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomCTAButton(
        isEnabled: _selectedSubLocation != null,
        text: '숙소 찾기',
        onPressed: () {
          if (_selectedSubLocation != null) {
            // 현재 화면을 모두 pop하고 lodging_screen으로 이동
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => LodgingViewModel()
                    ..setLocationText(_selectedSubLocation!),
                  child: const LodgingScreen(),
                ),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
