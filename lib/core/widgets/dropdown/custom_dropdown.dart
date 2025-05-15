import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final double? width;
  final double? height;
  final String? errorText;
  final bool? isError;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hintText,
    this.width,
    this.height,
    this.errorText,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: DropdownSearch<String>(
            items: (filter, _) => items,
            selectedItem: value,
            onChanged: onChanged,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: body_M.copyWith(color: AppColors.labelAssistive),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                filled: true,
                fillColor: AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: (errorText != null || isError == true)
                        ? AppColors.statusError
                        : AppColors.line,
                    width: (errorText != null || isError == true) ? 2 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: (errorText != null || isError == true)
                        ? AppColors.statusError
                        : AppColors.labelStrong,
                    width: 2,
                  ),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: false,
              menuProps: MenuProps(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: AppColors.line,
                    width: 1,
                  ),
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: height ?? 240,
              ),
              itemBuilder: (context, item, isSelected, isDisabled) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    item,
                    style: body_M.copyWith(
                      color: AppColors.labelStrong,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(errorText!,
                style: subtitle_S.copyWith(color: AppColors.statusError)),
          ),
      ],
    );
  }
}
