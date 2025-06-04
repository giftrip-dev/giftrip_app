import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';

// 커스텀 이미지 embed builder 클래스
class CustomImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'image';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final data = node.value.data;

    String? imageUrl;

    // 데이터가 Map인 경우 (예: {"image": "url"})
    if (data is Map) {
      if (data.containsKey('image')) {
        imageUrl = data['image'] as String;
      }
    }
    // 데이터가 String인 경우 (직접 URL)
    else if (data is String) {
      imageUrl = data;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomImage(
          imageUrl: imageUrl,
          width: MediaQuery.of(context).size.width - 40, // 패딩 고려
          height: 200,
          fit: BoxFit.contain,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class ProductDescriptionSection extends StatefulWidget {
  final String title;
  final String? content; // 서버에서 받은 JSON 형태의 퀼 콘텐츠

  const ProductDescriptionSection({
    super.key,
    required this.title,
    this.content,
  });

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  late QuillController _controller;
  bool _isExpanded = false;
  static const double _collapsedHeight = 200.0; // 축소 시 고정 높이

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    Document document;

    if (widget.content != null && widget.content!.isNotEmpty) {
      try {
        // 디버깅용 로그
        print('Content to parse: ${widget.content}');

        // JSON 형태의 퀼 콘텐츠를 파싱
        final json = jsonDecode(widget.content!);
        print('Parsed JSON: $json');

        // JSON이 List인지 확인하고, Quill Document 요구사항에 맞게 수정
        if (json is List && json.isNotEmpty) {
          // 마지막 요소가 개행문자로 끝나는지 확인
          final lastElement = json.last;
          bool needsNewline = true;

          if (lastElement is Map && lastElement.containsKey('insert')) {
            final insertValue = lastElement['insert'];
            // insert 값이 String인 경우에만 개행문자 체크
            if (insertValue is String && insertValue.endsWith('\n')) {
              needsNewline = false;
            }
            // insert 값이 Map(이미지 등)인 경우는 항상 개행문자 추가 필요
          }

          if (needsNewline) {
            // 마지막에 개행문자 요소 추가
            json.add({'insert': '\n'});
            print('Added newline to end of document');
          }

          document = Document.fromJson(json);
          print('Document created successfully');
        } else {
          print('JSON is not a valid List, treating as plain text');
          document = Document()..insert(0, widget.content ?? '');
        }
      } catch (e) {
        print('JSON parsing failed: $e');
        // JSON 파싱에 실패하면 일반 텍스트로 처리
        document = Document()..insert(0, widget.content ?? '');
      }
    } else {
      // 내용이 없으면 빈 문서
      document = Document()..insert(0, '상품 설명이 없습니다.');
    }

    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );

    // 읽기 전용 모드로 설정
    _controller.readOnly = true;
  }

  @override
  void didUpdateWidget(ProductDescriptionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: title_L),
          const SizedBox(height: 16),

          // 확장 상태에 따라 다른 높이로 표시
          _isExpanded
              ? QuillEditor.basic(
                  controller: _controller,
                  configurations: QuillEditorConfigurations(
                    padding: EdgeInsets.zero,
                    scrollable: false, // 스크롤 비활성화 (외부 스크롤뷰와 충돌 방지)
                    autoFocus: false,
                    showCursor: false, // 커서 숨김
                    enableInteractiveSelection: false, // 텍스트 선택 비활성화
                    readOnlyMouseCursor: SystemMouseCursors.basic,
                    embedBuilders: [
                      CustomImageEmbedBuilder(),
                    ],
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        HorizontalSpacing.zero,
                        const VerticalSpacing(0, 8),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                      h1: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        HorizontalSpacing.zero,
                        const VerticalSpacing(16, 8),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                      h2: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        HorizontalSpacing.zero,
                        const VerticalSpacing(12, 6),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                      h3: DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        HorizontalSpacing.zero,
                        const VerticalSpacing(8, 4),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    // 크롭된 에디터 (고정 높이)
                    SizedBox(
                      height: _collapsedHeight,
                      child: ClipRect(
                        child: QuillEditor.basic(
                          controller: _controller,
                          configurations: QuillEditorConfigurations(
                            padding: EdgeInsets.zero,
                            scrollable: false,
                            autoFocus: false,
                            showCursor: false,
                            enableInteractiveSelection: false,
                            readOnlyMouseCursor: SystemMouseCursors.basic,
                            embedBuilders: [
                              CustomImageEmbedBuilder(),
                            ],
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                                HorizontalSpacing.zero,
                                const VerticalSpacing(0, 8),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h1: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                HorizontalSpacing.zero,
                                const VerticalSpacing(16, 8),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h2: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                HorizontalSpacing.zero,
                                const VerticalSpacing(12, 6),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h3: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                HorizontalSpacing.zero,
                                const VerticalSpacing(8, 4),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 하단 그라데이션 효과
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          // 더보기/접기 버튼
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _isExpanded
                ? CTAButton(
                    isEnabled: true,
                    onPressed: _toggleExpand,
                    text: '접기',
                    type: CTAButtonType.outline,
                    size: CTAButtonSize.large,
                  )
                : CTAButton(
                    isEnabled: true,
                    onPressed: _toggleExpand,
                    text: '더보기',
                    type: CTAButtonType.outline,
                    size: CTAButtonSize.large,
                  ),
          ),
        ],
      ),
    );
  }
}
