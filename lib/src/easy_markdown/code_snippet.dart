import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeSnippet extends StatelessWidget {
  final String code;
  final String language;
  const CodeSnippet(this.code, this.language, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(22, 8, 14, 0),
            child: Row(
              children: [
                Icon(Icons.code, size: 20, color: Color(0xFFF8F8F8)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    language,
                    style: TextStyle(color: Color(0xFFF8F8F8), fontSize: 12),
                  ),
                ),
                SizedBox(width: 24),
                _CopyButton(code),
              ],
            ),
          ),
          Divider(color: Color(0xFF414141), thickness: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 22),
            child: SyntaxView(
              withZoom: false,
              code: code,
              syntaxTheme: SyntaxTheme.vscodeDark().copyWith(
                backgroundColor: Color(0xFF1C1C1C),
              ),
              syntax: language.toSyntax,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton(this.text);

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool hasCopied = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          hasCopied ? Icons.check : Icons.copy_rounded,
          color: Color(0xFFF8F8F8),
          size: 20,
        ),
      ),
      onPressed: () async {
        if (hasCopied) return;
        await Clipboard.setData(ClipboardData(text: widget.text));
        if (mounted) setState(() => hasCopied = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => hasCopied = false);
      },
    );
  }
}

extension StringExtension on String {
  Syntax get toSyntax => switch (toUpperCase()) {
    'DART' => Syntax.DART,
    'C' => Syntax.C,
    'CPP' => Syntax.CPP,
    'JAVASCRIPT' => Syntax.JAVASCRIPT,
    'JAVA SCRIPT' => Syntax.JAVASCRIPT,
    'JS' => Syntax.JAVASCRIPT,
    'KOTLIN' => Syntax.KOTLIN,
    'JAVA' => Syntax.JAVA,
    'SWIFT' => Syntax.SWIFT,
    'YAML' => Syntax.YAML,
    'RUST' => Syntax.RUST,
    'LUA' => Syntax.LUA,
    'PYTHON' => Syntax.PYTHON,
    _ => Syntax.C,
  };
}
