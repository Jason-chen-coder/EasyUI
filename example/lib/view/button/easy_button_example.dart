import 'package:easy_ui/easy_ui.dart';
import 'package:example/main.dart' show navigateToRoute;
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EasyButtonExample extends StatelessWidget {
  const EasyButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyButton'),
        p('常用的操作按钮'),
        h2('基础用法'),
        p('每种按钮拥有不同的默认尺寸'),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.defalut,
                      onPressed: () {},
                      child: Text('默认按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      onPressed: () {},
                      child: Text('主要按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.secondary,
                      onPressed: () {},
                      child: Text('主要按钮(蓝)'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.outline,
                      onPressed: () {},
                      child: Text('描边按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.info,
                      onPressed: () {},
                      child: Text('信息按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      onPressed: () {},
                      child: Text('文字按钮'),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  type: EasyButtonType.defalut,
  onPressed: () {},
  child: Text('默认按钮'),
),
EasyButton2(
  type: EasyButtonType.primary,
  onPressed: () {},
  child: Text('主要按钮'),
),
EasyButton2(
  type: EasyButtonType.secondary,
  onPressed: () {},
  child: Text('主要按钮(蓝)'),
),
EasyButton2(
  type: EasyButtonType.outline,
  onPressed: () {},
  child: Text('描边按钮'),
),
EasyButton2(
  type: EasyButtonType.info,
  onPressed: () {},
  child: Text('信息按钮'),
),
EasyButton2(
  type: EasyButtonType.text,
  onPressed: () {},
  child: Text('文字按钮'),
),
EasyButton2(
  tooltip: '图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
```
''',
        ),
        h2('按钮尺寸'),
        p('通过 `size` 属性来设置按钮尺寸'),
        tip('注意：默认按钮和图标按钮的不同尺寸样式不同'),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('大尺寸按钮：'),
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.defalut,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('默认按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('主要按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.secondary,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('主要按钮(蓝)'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.outline,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('描边按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.info,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('信息按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Text('文字按钮'),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      size: EasyButtonSize.big,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      size: EasyButtonSize.big,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      size: EasyButtonSize.big,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                p('小尺寸按钮：'),
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.defalut,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('默认按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('主要按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.secondary,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('主要按钮(蓝)'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.outline,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('描边按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.info,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('信息按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Text('文字按钮'),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      size: EasyButtonSize.small,
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      size: EasyButtonSize.small,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      size: EasyButtonSize.small,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// 大尺寸按钮
EasyButton2(
  type: EasyButtonType.defalut,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('默认按钮'),
),
EasyButton2(
  type: EasyButtonType.primary,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('主要按钮'),
),
EasyButton2(
  type: EasyButtonType.secondary,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('主要按钮(蓝)'),
),
EasyButton2(
  type: EasyButtonType.outline,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('描边按钮'),
),
EasyButton2(
  type: EasyButtonType.info,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('信息按钮'),
),
EasyButton2(
  type: EasyButtonType.text,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Text('文字按钮'),
),
EasyButton2(
  tooltip: '图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  size: EasyButtonSize.big,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  size: EasyButtonSize.big,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  size: EasyButtonSize.big,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
// 小尺寸按钮
EasyButton2(
  type: EasyButtonType.defalut,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('默认按钮'),
),
EasyButton2(
  type: EasyButtonType.primary,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('主要按钮'),
),
EasyButton2(
  type: EasyButtonType.secondary,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('主要按钮(蓝)'),
),
EasyButton2(
  type: EasyButtonType.outline,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('描边按钮'),
),
EasyButton2(
  type: EasyButtonType.info,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('信息按钮'),
),
EasyButton2(
  type: EasyButtonType.text,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Text('文字按钮'),
),
EasyButton2(
  tooltip: '图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  size: EasyButtonSize.small,
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  size: EasyButtonSize.small,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  size: EasyButtonSize.small,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: () {},
  child: Icon(Icons.settings),
),
```
''',
        ),
        h2('快速移除交互效果'),
        p('通过设置 `showHover` 或 `showSplash` 为 false 来禁用按钮的部分交互效果'),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.text,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('按钮点击')));
                      },
                      child: Text('默认状态'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      showHover: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('按钮点击')));
                      },
                      child: Text('删除hover效果'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      showSplash: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('按钮点击')));
                      },
                      child: Text('删除点击效果'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      showHover: false,
                      showSplash: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('按钮点击')));
                      },
                      child: Text('同时删除hover和点击效果'),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  type: EasyButtonType.text,
  onPressed: () {
    // TODO 按钮点击
  },
  child: Text('默认状态'),
),
EasyButton2(
  type: EasyButtonType.text,
  showHover: false,
  onPressed: () {
    // TODO 按钮点击
  },
  child: Text('删除hover效果'),
),
EasyButton2(
  type: EasyButtonType.text,
  showSplash: false,
  onPressed: () {
    // TODO 按钮点击
  },
  child: Text('删除点击效果'),
),
EasyButton2(
  type: EasyButtonType.text,
  showHover: false,
  showSplash: false,
  onPressed: () {
    // TODO 按钮点击
  },
  child: Text('同时删除hover和点击效果'),
),
```
''',
        ),
        h2('自定义样式'),
        p('可以通过 `style` 属性自定义按钮样式'),
        tip(
          '可以使用 `EasyButtonStyle.styleFrom` 方法快速创建样式，如果需要更加精细的控制样式，请使用 `EasyButtonStyle` 的默认构造函数',
        ),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      tooltip: '自定义样式的图标按钮',
                      type: EasyButtonType.iconDefault,
                      size: EasyButtonSize.big,
                      style: EasyButtonStyle.styleFrom(
                        padding: EdgeInsets.all(8),
                        backgroundColor: Colors.transparent,
                        foregroundColor: EasyTheme.of(context).neutral66,
                        iconSize: 16,
                        fixedSize: Size(32, 32),
                      ),
                      onPressed: () {},
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      style: EasyButtonStyle.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('圆角紫色按钮'),
                      onPressed: () {},
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      onPressed: () {},
                      style: EasyButtonStyle(
                        // 不同状态下的文字样式
                        textStyle: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            );
                          }
                          if (states.contains(WidgetState.hovered)) {
                            return const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            );
                          }
                          return const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          );
                        }),
                        // 不同状态下的内边距
                        padding: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            );
                          }
                          if (states.contains(WidgetState.hovered)) {
                            return const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 13,
                            );
                          }
                          return const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          );
                        }),
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.blueAccent,
                        ),
                      ),
                      child: const Text('文字和内边距变化'),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  tooltip: '自定义样式的图标按钮',
  type: EasyButtonType.iconDefault,
  size: EasyButtonSize.big,
  style: EasyButtonStyle.styleFrom(
    padding: EdgeInsets.all(8),
    backgroundColor: Colors.transparent,
    foregroundColor: EasyTheme.of(context).neutral66,
    iconSize: 16,
    fixedSize: Size(32, 32),
  ),
  onPressed: () {},
  child: Icon(Icons.settings),
),
EasyButton2(
  type: EasyButtonType.primary,
  style: EasyButtonStyle.styleFrom(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  child: const Text('圆角紫色按钮'),
  onPressed: () {},
),
EasyButton2(
  type: EasyButtonType.primary,
  onPressed: () {},
  style: EasyButtonStyle(
    // 不同状态下的文字样式
    textStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        );
      }
      if (states.contains(WidgetState.hovered)) {
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
      }
      return const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
    }),
    // 不同状态下的内边距
    padding: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        );
      }
      if (states.contains(WidgetState.hovered)) {
        return const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 13,
        );
      }
      return const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      );
    }),
    backgroundColor: const WidgetStatePropertyAll(
      Colors.blueAccent,
    ),
  ),
  child: const Text('文字和内边距变化'),
),
```
''',
        ),
        h2('禁用状态'),
        p('通过设置 `onPressed` 为 null 来禁用按钮'),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.defalut,
                      onPressed: null,
                      child: Text('默认按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.primary,
                      onPressed: null,
                      child: Text('主要按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.secondary,
                      onPressed: null,
                      child: Text('主要按钮(蓝)'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.outline,
                      onPressed: null,
                      child: Text('描边按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.info,
                      onPressed: null,
                      child: Text('信息按钮'),
                    ),
                    EasyButton2(
                      type: EasyButtonType.text,
                      onPressed: null,
                      child: Text('文字按钮'),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      onPressed: null,
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      onPressed: null,
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（默认）',
                      type: EasyButtonType.iconDefault,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: null,
                      child: Icon(Icons.settings),
                    ),
                    EasyButton2(
                      tooltip: '圆形图标按钮（主色）',
                      type: EasyButtonType.iconPrimary,
                      style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
                      onPressed: null,
                      child: Icon(Icons.settings),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  type: EasyButtonType.defalut,
  onPressed: null,
  child: Text('默认按钮'),
),
EasyButton2(
  type: EasyButtonType.primary,
  onPressed: null,
  child: Text('主要按钮'),
),
EasyButton2(
  type: EasyButtonType.secondary,
  onPressed: null,
  child: Text('主要按钮(蓝)'),
),
EasyButton2(
  type: EasyButtonType.outline,
  onPressed: null,
  child: Text('描边按钮'),
),
EasyButton2(
  type: EasyButtonType.info,
  onPressed: null,
  child: Text('信息按钮'),
),
EasyButton2(
  type: EasyButtonType.text,
  onPressed: null,
  child: Text('文字按钮'),
),
EasyButton2(
  tooltip: '图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  onPressed: null,
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  onPressed: null,
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（默认）',
  type: EasyButtonType.iconDefault,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: null,
  child: Icon(Icons.settings),
),
EasyButton2(
  tooltip: '圆形图标按钮（主色）',
  type: EasyButtonType.iconPrimary,
  style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
  onPressed: null,
  child: Icon(Icons.settings),
),
```
''',
        ),
        h2('带有图标的按钮'),
        p('通过 .icon 构造函数来创建带有图标的按钮'),
        tip('图标按钮没有 .icon 构造函数'),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2.icon(
                      type: EasyButtonType.primary,
                      icon: Icon(Icons.add),
                      onPressed: () {},
                      child: Text('左侧图标'),
                    ),
                    EasyButton2.icon(
                      type: EasyButtonType.primary,
                      icon: Icon(Icons.add),
                      style: EasyButtonStyle(iconPosition: IconPosition.end),
                      onPressed: () {},
                      child: Text('右侧图标'),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2.icon(
  type: EasyButtonType.primary,
  icon: Icon(Icons.add),
  onPressed: () {},
  label: Text('左侧图标'),
),
EasyButton2.icon(
  type: EasyButtonType.primary,
  icon: Icon(Icons.add),
  // 通过 style 设置图标位置 (style会与默认值合并)
  style: ButtonStyle(iconAlignment: IconAlignment.end),
  onPressed: () {},
  label: Text('右侧图标'),
),
```
''',
        ),
        h2('防抖'),
        p(
          '通过`withDebounce`属性开启防抖功能（默认启用），开启防抖后，当`onPressed`或`onLongPress`是异步函数时，按钮会在异步函数执行期间禁用，防止重复点击。',
        ),
        tip('注意：如果`onPressed`或`onLongPress`不是异步函数，防抖功能不会生效。'),
        WidgetHighlight(
          builder: (context) {
            int count = 0;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(
                  builder: (context, setter) {
                    return Row(
                      spacing: 16,
                      children: [
                        Flexible(
                          child: Wrap(
                            spacing: 16,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 16,
                            children: [
                              EasyButton2(
                                type: EasyButtonType.primary,
                                onPressed: () async {
                                  setter(() => count++);
                                  await Future.delayed(Duration(seconds: 2));
                                },
                                child: Text('开启防抖'),
                              ),
                              EasyButton2(
                                type: EasyButtonType.primary,
                                withDebounce: false,
                                onPressed: () async {
                                  setter(() => count++);
                                  await Future.delayed(Duration(seconds: 2));
                                },
                                child: Text('关闭防抖'),
                              ),
                            ],
                          ),
                        ),
                        Text('点击次数: $count'),
                      ],
                    );
                  },
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  type: EasyButtonType.primary,
  onPressed: () async {
    setter(() => count++);
    await Future.delayed(Duration(seconds: 2));
  },
  child: Text('开启防抖'),
),
EasyButton2(
  type: EasyButtonType.primary,
  withDebounce: false,
  onPressed: () async {
    setter(() => count++);
    await Future.delayed(Duration(seconds: 2));
  },
  child: Text('关闭防抖'),
),
```
''',
        ),
        h2('svg图标支持'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black54),
              children: [
                TextSpan(text: '可以通过`'),
                TextSpan(
                  text: 'EasySvgIcon',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: EasyTheme.of(context).primaryGreen,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => navigateToRoute('/svg'),
                ),
                TextSpan(text: '`来使用Svg图标'),
              ],
            ),
          ),
        ),
        WidgetHighlight(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    EasyButton2(
                      type: EasyButtonType.iconPrimary,
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 2));
                      },
                      child: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
                    ),
                    EasyButton2.icon(
                      type: EasyButtonType.primary,
                      icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 2));
                      },
                      child: Text('Svg图标按钮'),
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  type: EasyButtonType.iconPrimary,
  onPressed: () async {
    await Future.delayed(Duration(seconds: 2));
  },
  child: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
),
EasyButton2.icon(
  type: EasyButtonType.primary,
  icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 2));
  },
  child: Text('Svg图标按钮'),
),
```
''',
        ),
      ],
    );
  }
}
