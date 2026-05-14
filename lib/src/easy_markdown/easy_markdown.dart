import 'package:easy_ui/src/easy_markdown/custom_node.dart';
import 'package:easy_ui/src/easy_markdown/latex.dart';
import 'package:easy_ui/src/easy_markdown/table_wrapper.dart';
import 'package:easy_ui/src/easy_markdown/code_snippet.dart';
import 'package:flutter/material.dart';
import '../easy_theme.dart';
import 'markdown_widget.dart';
import './image_viewer.dart' as ImageViewer;

class EasyMarkdown extends StatefulWidget {
  final String text;
  final bool showToc;
  final String fontFamily;
  final PConfig? pConfig;
  final EdgeInsets padding;
  final EdgeInsets linesMargin;
  const EasyMarkdown({
    super.key,
    required this.text,
    this.showToc = false,
    this.fontFamily = '',
    this.pConfig,
    this.padding = const EdgeInsets.only(left: 10, right: 10),
    this.linesMargin = const EdgeInsets.all(5),
  });

  @override
  State<EasyMarkdown> createState() => _EasyMarkdownState();
}

class _EasyMarkdownState extends State<EasyMarkdown> {
  final tocController = TocController();
  final fontFamilyFallback = [
    'PingFang SC', // macOS / iOS
    'Microsoft YaHei', // Windows
    'Noto Sans CJK SC', // Android / Chrome OS
    'Hiragino Sans GB', // macOS 旧系统
    'Source Han Sans', // Adobe 开源
    'sans-serif', // 最后退化
  ];
  Widget buildTocWidget() => TocWidget(
    controller: tocController,
    tocTextStyle: TextStyle(
      fontSize: 14,
      height: 1.55,
      fontFamily: widget.fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
  );
  Widget buildMarkdown() => ConstrainedBox(
    constraints: BoxConstraints(minHeight: 0, maxHeight: double.infinity),
    child: MarkdownWidget(
      data: widget.text,
      config: MarkdownConfig.defaultConfig.copy(
        configs: [
          widget.pConfig ??
              PConfig(
                textStyle: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                  color: EasyTheme.of(context).neutral33,
                ),
              ),
          PreConfig(builder: (code, language) => CodeSnippet(code, language)),
          TableConfig(
            wrapper: (table) {
              final ScrollController scrollController = ScrollController();
              return TableWrapper(scrollController, table: table);
            },
          ),
          ImgConfig(
            builder:
                (url, attributes) => ImageViewer.ImageViewer(url, attributes),
          ),
          H1Config(
            showDiver: true,
            style: TextStyle(
              fontSize: 32,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          H2Config(
            showDiver: true,
            style: TextStyle(
              fontSize: 24,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          H3Config(
            showDiver: false,
            style: TextStyle(
              fontSize: 20,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          H4Config(
            style: TextStyle(
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          H5Config(
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          H6Config(
            style: TextStyle(
              fontSize: 13,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      markdownGenerator: MarkdownGenerator(
        linesMargin: widget.linesMargin,
        inlineSyntaxList: [LatexSyntax()],
        generators: [latexGenerator],
        textGenerator: (node, config, visitor) {
          return CustomTextNode(node.textContent, config, visitor);
        },
        richTextBuilder:
            (span) => Text.rich(
              span,
              style: TextStyle(
                fontFamily: widget.fontFamily,
                fontFamilyFallback: fontFamilyFallback,
              ),
            ),
      ),
      tocController: widget.showToc == true ? tocController : null,
    ),
  );
  final Map<HeadingNode, GlobalKey> headingKeys = {};
  @override
  Widget build(BuildContext context) {
    if (widget.showToc == true) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 200),
              child: buildTocWidget(),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(padding: widget.padding, child: buildMarkdown()),
          ),
        ],
      );
    } else {
      return Padding(padding: widget.padding, child: buildMarkdown());
    }
  }
}
