import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.child});

  final Widget child;

  /// 由于markdown组件本身含有水平方向的padding，使用此构造可以避免重复padding
  factory Body.multi({
    required List<Widget> children,
    ScrollController? controller,
  }) {
    final childrenWithAutoPadding =
        children.map((e) {
          if (e is EasyMarkdown) {
            return e;
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: e,
            );
          }
        }).toList();

    return Body(
      child: SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childrenWithAutoPadding,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
