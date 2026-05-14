import 'package:html/dom.dart' as h;
import 'package:markdown/markdown.dart' as m;
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html/dom_parsing.dart';

import 'markdown_widget.dart';

final RegExp tableRep = RegExp(
  r'<table[^>]*>',
  multiLine: true,
  caseSensitive: true,
);

final RegExp videoRep = RegExp(
  r'<video[^>]*>',
  multiLine: true,
  caseSensitive: true,
);

final RegExp htmlRep = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

///parse 解析html标签到markdown
List<SpanNode> parseHtml(
  m.Text node, {
  ValueCallback<dynamic>? onError,
  WidgetVisitor? visitor,
  TextStyle? parentStyle,
}) {
  try {
    final text = node.textContent.replaceAll(
      visitor?.splitRegExp ?? WidgetVisitor.defaultSplitRegExp,
      '',
    );
    if (!text.contains(htmlRep) || text.contains(videoRep)) {
      return [TextNode(text: node.text)];
    }
    h.DocumentFragment document = parseFragment(text);
    return HtmlToSpanVisitor(
      visitor: visitor,
      parentStyle: parentStyle,
    ).toVisit(document.nodes.toList());
  } catch (e) {
    onError?.call(e);
    return [TextNode(text: node.text)];
  }
}

class HtmlElement extends m.Element {
  @override
  final String textContent;

  HtmlElement(super.tag, super.children, this.textContent);
}

class HtmlToSpanVisitor extends TreeVisitor {
  final List<SpanNode> _spans = [];
  final List<SpanNode> _spansStack = [];
  final WidgetVisitor visitor;
  final TextStyle parentStyle;

  HtmlToSpanVisitor({WidgetVisitor? visitor, TextStyle? parentStyle})
    : visitor = visitor ?? WidgetVisitor(),
      parentStyle = parentStyle ?? TextStyle();

  List<SpanNode> toVisit(List<h.Node> nodes) {
    _spans.clear();
    for (final node in nodes) {
      final emptyNode = ConcreteElementNode(style: parentStyle);
      _spans.add(emptyNode);
      _spansStack.add(emptyNode);
      visit(node);
      _spansStack.removeLast();
    }
    final result = List.of(_spans);
    _spans.clear();
    _spansStack.clear();
    return result;
  }

  @override
  void visitText(h.Text node) {
    final last = _spansStack.last;
    if (last is ElementNode) {
      final textNode = TextNode(text: node.text);
      last.accept(textNode);
    }
  }

  @override
  void visitElement(h.Element node) {
    final localName = node.localName ?? '';

    if (localName.toLowerCase() == 'easychatbotloading') {
      final loadingNode = EasyChatbotLoadingNode();
      final last = _spansStack.last;
      if (last is ElementNode) {
        last.accept(loadingNode);
      }
      return;
    }

    final mdElement = m.Element(localName, []);
    mdElement.attributes.addAll(node.attributes.cast());
    SpanNode spanNode = visitor.getNodeByElement(mdElement, visitor.config);
    if (spanNode is! ElementNode) {
      final n = ConcreteElementNode(tag: localName, style: parentStyle);
      n.accept(spanNode);
      spanNode = n;
    }
    final last = _spansStack.last;
    if (last is ElementNode) {
      last.accept(spanNode);
    }
    _spansStack.add(spanNode);
    for (var child in node.nodes.toList(growable: false)) {
      visit(child);
    }
    _spansStack.removeLast();
  }
}

/// 自定义的加载动画
class EasyChatbotLoadingNode extends SpanNode {
  EasyChatbotLoadingNode();

  @override
  InlineSpan build() {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: _BlinkingCursor(),
    );
  }
}

/// 闪烁光标组件
class _BlinkingCursor extends StatefulWidget {
  @override
  _BlinkingCursorState createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value > 0.5 ? 1.0 : 0.0,
          child: Container(
            height: 15,
            width: 5,
            color:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
        );
      },
    );
  }
}
