import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/features/user/screens/certification_complete_screen.dart';
import 'package:myong/features/user/screens/certification_complete_no_alarm_screen.dart';
import 'package:myong/core/utils/check_permission.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/features/user/view_models/certificate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class EmploymentFormScreen extends StatefulWidget {
  final BeautyCategory category;
  const EmploymentFormScreen({super.key, required this.category});

  @override
  State<EmploymentFormScreen> createState() => _EmploymentFormScreenState();
}

class _EmploymentFormScreenState extends State<EmploymentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 입력 필드 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _designerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_employment_form_screen_view", "app_employment_form_screen");
  }

  @override
  Widget build(BuildContext context) {
    // 알림 권한 상태 확인
    checkNotificationPermission(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 터치하면 키보드를 닫음
      },
      child: Scaffold(
        appBar: const BackButtonAppBar(
          title: '재직 정보 등록',
          type: BackButtonAppBarType.textCenter,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('이름', _nameController, '이름을 입력해주세요.',
                    isRequired: true),
                _buildDatePicker('생년월일', _birthController, '생년월일을 입력해주세요.',
                    isRequired: true),
                _buildTextField(
                    '디자이너 예명', _designerNameController, '예명을 입력해주세요.',
                    isRequired: true),
                _buildTextField(
                    '재직 중인 매장 이름', _storeNameController, '매장 이름을 입력해주세요.',
                    isRequired: true),
                _buildTextField('공식 인스타그램 아이디', _instagramController,
                    '매장 공식 인스타그램 아이디를 입력해주세요.'),
                Text('해당 정보는 재직 정보 확인에만 사용되며 다른 사용자에게 공개되지 않습니다.',
                    style: caption.copyWith(color: AppColors.label)),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: OneButtonBottomSheet(
          isEnabled: _isFormValid(),
          buttonText: '등록하기',
          onButtonPressed: () async {
            if (_formKey.currentState!.validate()) {
              final certificateViewModel = context.read<CertificateViewModel>();
              await certificateViewModel.handleUploadCertificateNoImage(
                category: widget.category,
                name: _nameController.text,
                birthDate: _birthController.text,
                designerName: _designerNameController.text,
                storeName: _storeNameController.text,
                instagramId: _instagramController.text,
              );
              AmplitudeLogger.logClickEvent(
                  "employment_form_screen_register_click",
                  "employment_form_screen_register_button",
                  "employment_form_screen");
              // 알림 권한 상태 확인
              final permissionStatus =
                  await GlobalStorage().getNotificationPermission();
              final storageService = GlobalStorage();
              if (permissionStatus == "denied") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CertificationCompleteNoAlarmScreen(),
                  ),
                  (route) => false,
                );
              } else {
                await storageService.setCertificateComplete();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CertificationCompleteScreen(),
                  ),
                  (route) => false,
                );
              }
            }
          },
        ),
      ),
    );
  }

  /// 폼 유효성 검사
  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _birthController.text.isNotEmpty &&
        _designerNameController.text.isNotEmpty &&
        _storeNameController.text.isNotEmpty &&
        _selectedDate != null;
  }

  /// 라벨과 텍스트 입력 필드
  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: title_M),
            if (isRequired)
              Text(" *", style: title_M.copyWith(color: AppColors.statusError)),
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          style: body_2.copyWith(color: AppColors.label),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: body_2.copyWith(color: AppColors.labelAssistive),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.line),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.line),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.statusError),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() {}); // 입력값이 변경될 때마다 상태를 업데이트
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// 라벨과 날짜 선택 필드
  Widget _buildDatePicker(
      String label, TextEditingController controller, String hint,
      {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: title_M),
            if (isRequired)
              Text(" *", style: title_M.copyWith(color: AppColors.statusError)),
          ],
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate; // 선택된 날짜를 저장할 변수
            await showCupertinoModalPopup<DateTime>(
              context: context,
              builder: (context) {
                return Container(
                  height: 300,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 0, right: 16),
                              child: Text('확인',
                                  style: subtitle_L.copyWith(
                                      color: AppColors.labelStrong)),
                              onPressed: () {
                                Navigator.of(context).pop(selectedDate);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _selectedDate != null
                              ? DateTime.parse(
                                  _selectedDate!.replaceAll('/', '-'))
                              : DateTime.now(),
                          dateOrder: DatePickerDateOrder.ymd,
                          onDateTimeChanged: (DateTime newDateTime) {
                            selectedDate = newDateTime; // 선택된 날짜 업데이트
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ).then((value) {
              if (value != null) {
                setState(() {
                  _selectedDate =
                      "${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}";
                  controller.text = _selectedDate!; // 컨트롤러에 업데이트
                });
              }
            });
          },
          child: InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.line),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.line),
                borderRadius: BorderRadius.circular(8.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.statusError),
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate ?? "YYYY/MM/DD",
                  style: body_2.copyWith(
                    color: _selectedDate == null
                        ? AppColors.labelAssistive
                        : AppColors.labelStrong,
                  ),
                ),
                const Icon(
                  LucideIcons.chevronDown,
                  color: AppColors.componentStrong,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
