import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class SwitchDemo extends StatelessWidget {
  const SwitchDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySwitch 组件示例'),
        h2('基本用法'),
        p('展示基本的开关组件用法'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchBaseView();
          },
          codeSnippet: '''
```dart
EasySwitch(
  defaultChecked: false,
  onChange: (checked) {
    print('Switch changed to: \$checked');
  },
)
```
          ''',
        ),
        h2('受控模式'),
        p('通过 checked 参数控制开关状态'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchControlledView();
          },
          codeSnippet: '''
```dart
bool _isChecked = false;

EasySwitch(
  checked: _isChecked,
  onChange: (checked) {
    setState(() {
      _isChecked = checked;
    });
  },
)
```
          ''',
        ),
        h2('自定义内容'),
        p('通过 checkedChildren 和 unCheckedChildren 自定义选中和未选中时的内容'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchCustomContentView();
          },
          codeSnippet: '''
```dart
EasySwitch(
  checkedChildren: Text('ON', style: TextStyle(color: Colors.white, fontSize: 12)),
  unCheckedChildren: Text('OFF', style: TextStyle(color: Colors.grey, fontSize: 12)),
  onChange: (checked) {},
)
```
          ''',
        ),
        h2('禁用状态'),
        p('通过 disabled 参数禁用开关'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchDisabledView();
          },
          codeSnippet: '''
```dart
EasySwitch(
  checked: true,
  disabled: true,
  onChange: (checked) {},
)

EasySwitch(
  checked: false,
  disabled: true,
  onChange: (checked) {},
)
```
          ''',
        ),
        h2('加载状态'),
        p('通过 loading 参数显示加载中的开关'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchLoadingView();
          },
          codeSnippet: '''
```dart
EasySwitch(
  checked: true,
  loading: true,
  onChange: (checked) {},
)

EasySwitch(
  checked: false,
  loading: true,
  onChange: (checked) {},
)
```
          ''',
        ),
        h2('自定义尺寸'),
        p('通过 size 参数自定义开关的宽高'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchCustomSizeView();
          },
          codeSnippet: '''
```dart
EasySwitch(
  size: Size(60, 30),
  onChange: (checked) {},
)

EasySwitch(
  size: Size(80, 40),
  onChange: (checked) {},
)
```
          ''',
        ),
        h2('带 Label 用法'),
        p(
          '通过 label / labelPosition 快速实现 Row([label, switch]) 或 Row([switch, label])',
        ),
        WidgetHighlight(
          builder: (context) {
            return _SwitchLabelView();
          },
          codeSnippet: r'''
```dart
EasySwitch(
  label: const Text('自动更新'),
  labelPosition: EasySwitchLabelPosition.left, // label 在左
  labelSpacing: 12,
  onTapWholeRow: true, // 整行可点
  defaultChecked: true,
  onChange: (checked) {},
)

EasySwitch(
  label: const Text('隐私模式'),
  labelPosition: EasySwitchLabelPosition.right, // label 在右
  onTapWholeRow: false, // 只点开关切换
  defaultChecked: false,
  onChange: (checked) {},
)
      ''',
        ),
        h2('自定义背景颜色'),
        p('通过 checkedColor / uncheckedColor 控制开关背景色'),
        WidgetHighlight(
          builder: (context) {
            return _SwitchCustomColorView();
          },
          codeSnippet: r'''
```dart
EasySwitch(
  label: const Text('成功状态'),
  checkedColor: Colors.green,
  uncheckedColor: Colors.grey.shade300,
  defaultChecked: true,
  onChange: (v) {},
)

EasySwitch(
  label: const Text('警告状态'),
  checkedColor: Colors.orange,
  uncheckedColor: Colors.grey.shade300,
  onChange: (v) {},
)

EasySwitch(
  label: const Text('危险状态（禁用）'),
  checkedColor: Colors.red,
  uncheckedColor: Colors.grey.shade300,
  disabled: true,
  checked: true,
)''',
        ),

        h2('EasySwitch 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasySwitch 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('默认值')),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('checked')),
                        DataCell(Text('bool?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('指定当前是否选中（受控模式）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('checkedChildren')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选中时的内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unCheckedChildren')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('非选中时的内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('defaultChecked')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('初始是否选中（非受控模式）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('disabled')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否禁用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('loading')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('加载中的开关')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('size')),
                        DataCell(Text('Size?')),
                        DataCell(Text('Size(44.0, 22.0)')),
                        DataCell(Text('否')),
                        DataCell(Text('可指定宽高')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('value')),
                        DataCell(Text('bool?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('当前值（与 checked 相同，用于兼容）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChange')),
                        DataCell(Text('ValueChanged<bool>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('变化时的回调函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('label')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('外部标签内容；传入后组件会用 Row 组合展示')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('labelPosition')),
                        DataCell(Text('EasySwitchLabelPosition')),
                        DataCell(Text('EasySwitchLabelPosition.left')),
                        DataCell(Text('否')),
                        DataCell(Text('label 在左或在右（left/right）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('labelSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('8.0')),
                        DataCell(Text('否')),
                        DataCell(Text('label 与 switch 的间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onTapWholeRow')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否整行（label + switch）都可点击切换')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}

class _SwitchBaseView extends StatelessWidget {
  const _SwitchBaseView();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              defaultChecked: false,
              onChange: (checked) {
                print('Switch 1 changed to: $checked');
              },
            ),
            Text('默认未选中'),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              defaultChecked: true,
              onChange: (checked) {
                print('Switch 2 changed to: $checked');
              },
            ),
            Text('默认选中'),
          ],
        ),
      ],
    );
  }
}

class _SwitchControlledView extends StatefulWidget {
  const _SwitchControlledView();

  @override
  State<_SwitchControlledView> createState() => _SwitchControlledViewState();
}

class _SwitchControlledViewState extends State<_SwitchControlledView> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              checked: _isChecked,
              onChange: (checked) {
                setState(() {
                  _isChecked = checked;
                });
              },
            ),
            Text('当前状态: ${_isChecked ? "选中" : "未选中"}'),
          ],
        ),
        const SizedBox(height: 8),
        EasyButton2(
          type: EasyButtonType.primary,
          size: EasyButtonSize.small,
          onPressed: () {
            setState(() {
              _isChecked = !_isChecked;
            });
          },
          child: Text('切换状态'),
        ),
      ],
    );
  }
}

class _SwitchCustomContentView extends StatefulWidget {
  const _SwitchCustomContentView();

  @override
  State<_SwitchCustomContentView> createState() =>
      _SwitchCustomContentViewState();
}

class _SwitchCustomContentViewState extends State<_SwitchCustomContentView> {
  bool _isChecked1 = false;
  bool _isChecked2 = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              checked: _isChecked1,
              checkedChildren: Text(
                'ON',
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
              unCheckedChildren: Text(
                'OFF',
                style: TextStyle(color: Colors.grey, fontSize: 8),
              ),
              onChange: (checked) {
                setState(() {
                  _isChecked1 = checked;
                });
              },
            ),
            Text('文字内容'),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              checked: _isChecked2,
              checkedChildren: Icon(Icons.check, size: 14, color: Colors.white),
              unCheckedChildren: Icon(
                Icons.close,
                size: 14,
                color: Colors.grey,
              ),
              onChange: (checked) {
                setState(() {
                  _isChecked2 = checked;
                });
              },
            ),
            Text('图标内容'),
          ],
        ),
      ],
    );
  }
}

class _SwitchDisabledView extends StatelessWidget {
  const _SwitchDisabledView();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(checked: true, disabled: true, onChange: (checked) {}),
            Text('禁用状态（选中）'),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            EasySwitch(checked: false, disabled: true, onChange: (checked) {}),
            Text('禁用状态（未选中）'),
          ],
        ),
      ],
    );
  }
}

class _SwitchLoadingView extends StatelessWidget {
  const _SwitchLoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(checked: true, loading: true, onChange: (checked) {}),
            Text('加载中（选中）'),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            EasySwitch(checked: false, loading: true, onChange: (checked) {}),
            Text('加载中（未选中）'),
          ],
        ),
      ],
    );
  }
}

class _SwitchCustomSizeView extends StatefulWidget {
  const _SwitchCustomSizeView();

  @override
  State<_SwitchCustomSizeView> createState() => _SwitchCustomSizeViewState();
}

class _SwitchCustomSizeViewState extends State<_SwitchCustomSizeView> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              size: const Size(60, 30),
              checked: _isChecked1,
              onChange: (checked) {
                setState(() {
                  _isChecked1 = checked;
                });
              },
            ),
            Text('尺寸: 60x30'),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            EasySwitch(
              size: const Size(80, 40),
              checked: _isChecked2,
              onChange: (checked) {
                setState(() {
                  _isChecked2 = checked;
                });
              },
            ),
            Text('尺寸: 80x40'),
          ],
        ),
      ],
    );
  }
}

class _SwitchLabelView extends StatefulWidget {
  const _SwitchLabelView();

  @override
  State<_SwitchLabelView> createState() => _SwitchLabelViewState();
}

class _SwitchLabelViewState extends State<_SwitchLabelView> {
  bool _autoUpdate = true;
  bool _privacyMode = false;
  bool _wifiOnly = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label 在左：Row([label, switch])
        EasySwitch(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.system_update_alt, size: 16),
              SizedBox(width: 6),
              Text('自动更新'),
            ],
          ),
          labelPosition: EasySwitchLabelPosition.left,
          labelSpacing: 12,
          onTapWholeRow: true,
          checked: _autoUpdate,
          onChange: (v) => setState(() => _autoUpdate = v),
        ),

        // label 在右：Row([switch, label])
        EasySwitch(
          label: const Text('隐私模式'),
          labelPosition: EasySwitchLabelPosition.right,
          labelSpacing: 12,
          onTapWholeRow: true,
          checked: _privacyMode,
          onChange: (v) => setState(() => _privacyMode = v),
        ),

        // 只允许点开关本体切换（label 不切）
        EasySwitch(
          label: const Text('仅 Wi-Fi 下载（label 不可点）'),
          labelPosition: EasySwitchLabelPosition.left,
          onTapWholeRow: false,
          checked: _wifiOnly,
          onChange: (v) => setState(() => _wifiOnly = v),
        ),

        const SizedBox(height: 4),
        Text(
          '当前：自动更新=${_autoUpdate ? "开" : "关"}，隐私模式=${_privacyMode ? "开" : "关"}，仅Wi-Fi=${_wifiOnly ? "开" : "关"}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _SwitchCustomColorView extends StatefulWidget {
  const _SwitchCustomColorView();

  @override
  State<_SwitchCustomColorView> createState() => _SwitchCustomColorViewState();
}

class _SwitchCustomColorViewState extends State<_SwitchCustomColorView> {
  bool _success = true;
  bool _warning = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasySwitch(
          label: const Text('成功状态'),
          checkedColor: Colors.green,
          uncheckedColor: Colors.grey.shade300,
          checked: _success,
          onChange: (v) => setState(() => _success = v),
        ),

        EasySwitch(
          label: const Text('警告状态'),
          checkedColor: Colors.orange,
          uncheckedColor: Colors.grey.shade300,
          checked: _warning,
          onChange: (v) => setState(() => _warning = v),
        ),

        EasySwitch(
          label: const Text('危险状态（禁用）'),
          checkedColor: Colors.red,
          uncheckedColor: Colors.grey.shade300,
          disabled: true,
          checked: true,
        ),
      ],
    );
  }
}
