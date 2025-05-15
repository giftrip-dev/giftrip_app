import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class ReportDropDown extends StatefulWidget {
  final List<Map<String, String>> items;
  final String hintText;
  final String? value;
  final Function(String?) onChanged;
  final String? errorText;

  const ReportDropDown({
    super.key,
    required this.items,
    required this.hintText,
    this.value,
    required this.onChanged,
    this.errorText,
  });

  @override
  _ReportDropDownState createState() => _ReportDropDownState();
}

class _ReportDropDownState extends State<ReportDropDown> {
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 외부 영역 클릭 감지용 GestureDetector 추가
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown, // 외부 클릭 시 드롭다운 닫기
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width - 86,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, 60),
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.map((item) {
                      final isLastItem = widget.items.last == item;

                      return Column(
                        children: [
                          ListTile(
                            title: Text(item['text']!, style: subtitle_M),
                            onTap: () {
                              widget.onChanged(item['value']);
                              _closeDropdown();
                            },
                          ),
                          if (!isLastItem)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.line,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: SizedBox(
              height: 52,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: body_M,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.statusError
                          : AppColors.line,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.statusError
                          : AppColors.line,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.statusError
                          : AppColors.line,
                    ),
                  ),
                  suffixIcon: Icon(
                    _isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 18,
                  ),
                ),
                child: Text(
                  widget.value != null
                      ? widget.items.firstWhere(
                          (r) => r['value'] == widget.value)['text']!
                      : widget.hintText,
                  style: body_M.copyWith(
                    color: widget.value != null
                        ? Colors.black
                        : AppColors.labelAssistive,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              widget.errorText!,
              style: subtitle_XS.copyWith(color: AppColors.statusError),
            ),
          ),
      ],
    );
  }
}
