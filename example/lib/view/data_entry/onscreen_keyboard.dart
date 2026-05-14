import 'dart:developer';

import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class OnscreenKeyboard extends StatelessWidget {
  const OnscreenKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyOnscreenKeyboard'),
        p('用于桌面、多端场景的浮动屏幕键盘，支持直接绑定输入框，也支持通过原始键盘组件自行处理按键事件。'),
        tip(
          '首先需要在 `MaterialApp` 中通过 '
          '`EasyOnscreenKeyboard.builder(...)` 完成全局挂载。',
        ),
        div(),
        h2('EasyOnscreenKeyboard.builder 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        DataCell(Text('layout')),
                        DataCell(Text('KeyboardLayout?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘布局配置，为空时根据平台自动选择')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('theme')),
                        DataCell(Text('EasyOnscreenKeyboardThemeData?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘主题样式，为空时使用默认主题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('WidthGetter?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘宽度配置函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('aspectRatio')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘宽高比')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showControlBar')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示键盘顶部控制栏')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('dragHandle')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义拖拽手柄组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('buildControlBarActions')),
                        DataCell(Text('ActionsBuilder?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义控制栏操作按钮')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('builder')),
                        DataCell(Text('TransitionBuilder?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('额外的应用级包装 builder')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
        h2('EasyOnscreenKeyboardTextField 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('继承 Flutter TextField 的所有参数，以下仅列出屏幕键盘相关的额外参数：'),
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
                        DataCell(Text('enableOnscreenKeyboard')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用屏幕键盘，设为 false 则使用系统键盘')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onscreenKeyboardMode')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始键盘模式，为空时使用布局的第一个模式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectAllOnFocus')),
                        DataCell(Text('bool?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('聚焦时是否全选文本')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
        h2('组件预览'),
        WidgetHighlight(
          codeSnippet: '''
```dart
final formFieldKey = GlobalKey<FormFieldState<String>>();

Column(
  children: [
    const EasyOnscreenKeyboardTextField(
      selectAllOnFocus: false,
      decoration: InputDecoration(labelText: 'Name'),
    ),
    const EasyOnscreenKeyboardTextField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Address'),
    ),
    EasyOnscreenKeyboardTextFormField(
      formFieldKey: formFieldKey,
      decoration: const InputDecoration(labelText: 'Note'),
      onChanged: (_) => formFieldKey.currentState?.validate(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    ),
  ],
)
```''',
          builder: (context) => const _KeyboardFieldDemo(),
        ),
        h2('EasyOnscreenTextFormField'),
        p(
          '特别的，组件已经预封装了 UI Kit 中`EasyTextFormField`组件，可以直接使用 `EasyOnscreenTextFormField`。',
        ),
        WidgetHighlight(
          codeSnippet: '''
```dart
const EasyOnscreenTextFormField(
  placeholder: 'EasyOnscreenTextFormField 示例',
  showRequiredMark: true,
)
```
''',
          builder:
              (context) => const EasyOnscreenTextFormField(
                placeholder: 'EasyOnscreenTextFormField示例',
              ),
        ),
        h2('Builder 用法'),
        p('当你需要保留自定义输入框样式时，可以用 Builder 组件把控制器、焦点和输入回调接到自己的 TextField 上。'),
        WidgetHighlight(
          codeSnippet: '''
```dart
EasyOnscreenKeyboardTextFieldBuilder(
  builder: (controller, focusNode, inputFormatters, keyboardType, maxLines, onChanged) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Custom Builder Field',
      ),
    );
  },
)
```
''',
          builder: (context) => const _BuilderDemo(),
        ),

        h2('EasyOnscreenKeyboardTextFieldBuilder 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        DataCell(Text('builder')),
                        DataCell(
                          Text('OnscreenKeyboardTextFieldBuilderCallback'),
                        ),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(
                          Text('构建自定义输入框的回调，接收 controller、focusNode 等参数'),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('enableOnscreenKeyboard')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用屏幕键盘，设为 false 则使用系统键盘')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onscreenKeyboardMode')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始键盘模式，为空时使用布局的第一个模式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('TextEditingController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本编辑控制器，为空时自动创建')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('focusNode')),
                        DataCell(Text('FocusNode?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('焦点节点，为空时自动创建')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('keyboardType')),
                        DataCell(Text('TextInputType?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘类型，启用屏幕键盘时会被忽略')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('maxLines')),
                        DataCell(Text('int?')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('最大行数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<String>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('inputFormatters')),
                        DataCell(Text('List<TextInputFormatter>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('输入格式化器列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectAllOnFocus')),
                        DataCell(Text('bool?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('聚焦时是否全选文本')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),

        h2('Raw Keyboard'),
        p(
          '`EasyRawOnscreenKeyboard` 只负责渲染键盘 UI，适合嵌入式输入面板、特殊布局或需要完全自定义按键行为的场景。',
        ),
        h2('EasyRawOnscreenKeyboard 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        DataCell(Text('layout')),
                        DataCell(Text('KeyboardLayout')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('键盘布局配置，定义键盘的行和按键')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('mode')),
                        DataCell(Text('String')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('当前激活的键盘模式，需匹配 layout.modes 中的 key')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onKeyDown')),
                        DataCell(Text('ValueChanged<EasyOnscreenKeyboardKey>')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('按键按下回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onKeyUp')),
                        DataCell(Text('ValueChanged<EasyOnscreenKeyboardKey>')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('按键释放回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('aspectRatio')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('键盘宽高比，为空时使用 layout 的默认值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('pressedActionKeys')),
                        DataCell(Text('Set<String>')),
                        DataCell(Text('const {}')),
                        DataCell(Text('否')),
                        DataCell(Text('当前按下的功能键名称集合（如 shift、capslock）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showSecondary')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示按键的次要值（如大写字母）')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
        WidgetHighlight(
          codeSnippet: '''
```dart
EasyRawOnscreenKeyboard(
  layout: const MobileKeyboardLayout(),
  mode: currentMode,
  pressedActionKeys: pressedActionKeys,
  showSecondary: showSecondary,
  onKeyDown: onKeyDown,
  onKeyUp: onKeyUp,
)
```
''',
          builder: (context) => const _RawKeyboardDemo(),
        ),
      ],
    );
  }
}

class _KeyboardFieldDemo extends StatefulWidget {
  const _KeyboardFieldDemo();

  @override
  State<_KeyboardFieldDemo> createState() => _KeyboardFieldDemoState();
}

class _KeyboardFieldDemoState extends State<_KeyboardFieldDemo> {
  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EasyOnscreenKeyboardController? _keyboard;
  bool _listenerAttached = false;
  String _lastEvent = '等待按键输入...';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_listenerAttached) {
      return;
    }
    _keyboard = EasyOnscreenKeyboard.of(context);
    _keyboard!.addRawKeyDownListener(_handleRawKeyDown);
    _listenerAttached = true;
  }

  @override
  void dispose() {
    if (_listenerAttached) {
      _keyboard?.removeRawKeyDownListener(_handleRawKeyDown);
    }
    super.dispose();
  }

  void _handleRawKeyDown(EasyOnscreenKeyboardKey key) {
    final message = switch (key) {
      TextKey(:final primary) => '文本键: "$primary"',
      ActionKey(:final name) => '功能键: $name',
    };
    log(message, name: 'EasyOnscreenKeyboardExample');
    if (!mounted) {
      return;
    }
    setState(() {
      _lastEvent = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = _keyboard ?? EasyOnscreenKeyboard.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: keyboard.open,
                child: const Text('Open Keyboard'),
              ),
              ElevatedButton(
                onPressed: keyboard.close,
                child: const Text('Close Keyboard'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          tip(
            '点击 `Open Keyboard` 只会显示浮动键盘。'
            '真正接收输入的目标必须是 `EasyOnscreenKeyboard` 配套的 '
            '`TextField / TextFormField / Builder` 组件。',
          ),
          tip('`Close Keyboard` 会关闭当前浮动键盘，并解除当前挂接的输入目标。'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EasyTheme.of(context).onBackground.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_lastEvent),
          ),
          const SizedBox(height: 16),
          const EasyOnscreenKeyboardTextField(
            selectAllOnFocus: false,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          const EasyOnscreenKeyboardTextField(
            maxLines: 4,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          const SizedBox(height: 16),
          EasyOnscreenKeyboardTextFormField(
            formFieldKey: _formFieldKey,
            selectAllOnFocus: false,
            decoration: const InputDecoration(labelText: 'Note'),
            onChanged: (_) => _formFieldKey.currentState?.validate(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => _formKey.currentState?.validate(),
              child: const Text('Validate Form'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderDemo extends StatelessWidget {
  const _BuilderDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyOnscreenKeyboardTextFieldBuilder(
          maxLines: 2,
          builder:
              (
                controller,
                focusNode,
                inputFormatters,
                keyboardType,
                maxLines,
                onChanged,
              ) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: EasyTheme.of(
                      context,
                    ).onBackground.withValues(alpha: 0.12),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Builder Field',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: EasyTheme.of(context).onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      inputFormatters: inputFormatters,
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      onChanged: onChanged,
                      decoration: const InputDecoration(
                        hintText: 'Use your own TextField layout here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }
}

class _RawKeyboardDemo extends StatefulWidget {
  const _RawKeyboardDemo();

  @override
  State<_RawKeyboardDemo> createState() => _RawKeyboardDemoState();
}

class _RawKeyboardDemoState extends State<_RawKeyboardDemo> {
  late final TextEditingController _controller;
  final Set<String> _pressedActionKeys = <String>{};

  bool _showSecondary = false;
  String _currentMode = 'alphabets';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncSecondaryState() {
    _showSecondary =
        _pressedActionKeys.contains('capslock') ^
        _pressedActionKeys.contains('shift');
  }

  void _replaceSelection(String value) {
    final selection = _controller.selection;
    if (!selection.isValid) {
      return;
    }
    final newText = _controller.text.replaceRange(
      selection.start,
      selection.end,
      value,
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + value.length,
      ),
    );
  }

  void _deleteBackward() {
    final selection = _controller.selection;
    if (!selection.isValid || _controller.text.isEmpty) {
      return;
    }

    if (!selection.isCollapsed) {
      final newText = _controller.text.replaceRange(
        selection.start,
        selection.end,
        '',
      );
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
      );
      return;
    }

    if (selection.start == 0) {
      return;
    }

    final leftText = _controller.text.substring(0, selection.start);
    final rightText = _controller.text.substring(selection.start);
    final leftCharacters = leftText.characters.toList()..removeLast();
    final newLeftText = leftCharacters.join();
    final newText = newLeftText + rightText;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newLeftText.length),
    );
  }

  void _switchMode() {
    final modes = const MobileKeyboardLayout().modes.keys.toList();
    final currentIndex = modes.indexOf(_currentMode);
    setState(() {
      _currentMode = modes[(currentIndex + 1) % modes.length];
    });
  }

  void _onKeyDown(EasyOnscreenKeyboardKey key) {
    switch (key) {
      case TextKey():
        _replaceSelection(key.getText(secondary: _showSecondary));
      case ActionKey():
        switch (key.name) {
          case 'backspace':
            _deleteBackward();
          case 'enter':
            _replaceSelection('\n');
          case 'space':
            _replaceSelection(' ');
          case 'mode_switch':
            _switchMode();
          case 'shift':
            setState(() {
              _pressedActionKeys.add('shift');
              _syncSecondaryState();
            });
          case 'capslock':
            setState(() {
              if (_pressedActionKeys.contains('capslock')) {
                _pressedActionKeys.remove('capslock');
              } else {
                _pressedActionKeys.add('capslock');
              }
              _syncSecondaryState();
            });
        }
    }
  }

  void _onKeyUp(EasyOnscreenKeyboardKey key) {
    if (key case ActionKey(name: 'shift')) {
      setState(() {
        _pressedActionKeys.remove('shift');
        _syncSecondaryState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 960),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Type here...',
              hintText: 'Use RawOnscreenKeyboard to control every key event',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'alphabets', label: Text('ABC')),
                  ButtonSegment(value: 'symbols', label: Text('123')),
                  ButtonSegment(value: 'emojis', label: Text('Emoji')),
                ],
                selected: <String>{_currentMode},
                onSelectionChanged: (selected) {
                  setState(() {
                    _currentMode = selected.first;
                  });
                },
              ),
              OutlinedButton(
                onPressed: () => _controller.clear(),
                child: const Text('Clear'),
              ),
              Text(
                'showSecondary: $_showSecondary',
                style: TextStyle(
                  color: EasyTheme.of(
                    context,
                  ).onBackground.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          tip(
            'Raw 版本只负责渲染键盘。文本插入、删除、切换模式、'
            '大小写逻辑都需要你在 `onKeyDown / onKeyUp` 中自行处理。',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth.clamp(280.0, 760.0);
              return Center(
                child: SizedBox(
                  width: width,
                  child: EasyRawOnscreenKeyboard(
                    layout: const MobileKeyboardLayout(),
                    mode: _currentMode,
                    onKeyDown: _onKeyDown,
                    onKeyUp: _onKeyUp,
                    pressedActionKeys: _pressedActionKeys,
                    showSecondary: _showSecondary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
