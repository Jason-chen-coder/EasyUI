import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class WidgetHighlight extends StatefulWidget {
  const WidgetHighlight({
    super.key,
    this.backgroundColor,
    this.header,
    required this.builder,
    required this.codeSnippet,
    this.initiallyOpen = false,
  });

  /// 折叠部分的标题 默认为"源代码"
  final Widget? header;

  /// 需要展示的组件
  final Widget Function(BuildContext) builder;

  /// 组件对应的代码片段（传入markdown文本，亦可是组件文档）
  final String codeSnippet;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否默认展开
  final bool initiallyOpen;

  @override
  State<WidgetHighlight> createState() => _WidgetHighlightState();
}

class _WidgetHighlightState extends State<WidgetHighlight> {
  late bool isOpen = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          color: EasyTheme.of(context).onBackground.withValues(alpha: 0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: EasyTheme.of(context).onBackground.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        color: widget.backgroundColor ?? EasyTheme.of(context).background,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            alignment: AlignmentDirectional.topStart,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: EasyTheme.of(
                    context,
                  ).onBackground.withValues(alpha: 0.1),
                  width: 2.0,
                ),
              ),
            ),
            child: widget.builder.call(context),
          ),
          Theme(
            data: theme.copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child:
                widget.codeSnippet != ""
                    ? ExpansionTile(
                      initiallyExpanded: widget.initiallyOpen,
                      onExpansionChanged: (state) {
                        if (mounted) setState(() => isOpen = state);
                      },
                      title:
                          widget.header ??
                          const Text(
                            '源代码',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      children: [EasyMarkdown(text: widget.codeSnippet)],
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
