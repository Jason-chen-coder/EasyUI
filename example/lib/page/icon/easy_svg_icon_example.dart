import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class EasySvgIconExample extends StatelessWidget {
  const EasySvgIconExample({super.key});
  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySvgIcon'),
        p('对 `SvgPicture` 的二次封装，主要添加了`IconTheme`的支持，以便在按钮中适配按钮主题的图标大小和颜色。'),
        p('用法和`SvgPicture`相同'),
        WidgetHighlight(
          builder: (context) {
            return EasySvgIcon.asset('assets/svgs/ic_lab.svg');
          },
          codeSnippet: '''
```dart
EasySvgIcon.asset('assets/svgs/ic_lab.svg')
```
''',
        ),
      ],
    );
  }
}
