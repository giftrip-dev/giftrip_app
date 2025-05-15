import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/global_app_bar.dart';
import 'package:giftrip/features/user/widgets/category_button.dart';
import 'package:giftrip/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:giftrip/features/user/screens/initial_certificate_screen.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_select_category_screen_view", "app_select_category_screen");
  }

  // 선택된 카테고리 인덱스
  int _selectedIndex = 0;

  // // 카테고리 리스트
  // final List<String> _categories = ['HAIR', 'MAKEUP', 'NAIL', 'SKIN_ESTHETIC'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(noAlarm: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 59.54),
        child: Column(
          children: [
            Text(
              '인증하실 미용 자격증을\n선택해 주세요',
              style: h1_M,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // 카테고리 버튼들
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryButton(
                      label: BeautyCategory.toKoreanString(BeautyCategory.hair),
                      isSelected: _selectedIndex == 0,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      selectedImagePath: 'assets/images/icon/hair.png',
                      unselectedImagePath: 'assets/images/icon/hair_black.png',
                    ),
                    CategoryButton(
                      label:
                          BeautyCategory.toKoreanString(BeautyCategory.makeup),
                      isSelected: _selectedIndex == 1,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      selectedImagePath: 'assets/images/icon/makeup.png',
                      unselectedImagePath:
                          'assets/images/icon/makeup_black.png',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryButton(
                      label: BeautyCategory.toKoreanString(BeautyCategory.nail),
                      isSelected: _selectedIndex == 2,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      selectedImagePath: 'assets/images/icon/nail.png',
                      unselectedImagePath: 'assets/images/icon/nail_black.png',
                    ),
                    CategoryButton(
                      label: BeautyCategory.toKoreanString(
                          BeautyCategory.skinEsthetic),
                      isSelected: _selectedIndex == 3,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      selectedImagePath: 'assets/images/icon/aesthetic.png',
                      unselectedImagePath:
                          'assets/images/icon/aesthetic_black.png',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: OneButtonBottomSheet(
        isEnabled: true,
        buttonText: '다음',
        onButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InitialCertificateScreen(
                      category: BeautyCategory.values[_selectedIndex],
                    )),
          );
          AmplitudeLogger.logClickEvent("app_select_category_next_click",
              "app_select_category_next_button", "app_select_category_screen");
        },
      ),
    );
  }
}
