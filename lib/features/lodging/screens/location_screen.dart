import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/lodging/widgets/location_tab.dart';
import 'package:giftrip/features/lodging/widgets/sub_category_item.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _selectedIndex = 0;
  late final List<LocationData> _locationData;

  @override
  void initState() {
    super.initState();
    _locationData = LocationManager.getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        type: BackButtonAppBarType.textLeft,
        title: '위치',
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
                              onTap: () {
                                Navigator.pop(context, item);
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
    );
  }
}
