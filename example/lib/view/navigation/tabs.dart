import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class TabsDemo extends StatefulWidget {
  const TabsDemo({super.key});

  @override
  State<TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  dynamic _selectedTab1 = 'tab1';
  dynamic _selectedTab2 = 'tab2';
  dynamic _selectedTab3 = 'tab3';
  dynamic _selectedTab4 = 'tab1';
  dynamic _selectedTab5 = 'tab1';
  dynamic _selectedTab6 = 'tab1';
  dynamic _selectedTab7 = 'tab1';

  Color _adaptiveTintBackground(BuildContext context, Color tintColor) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double opacity = isDark ? 0.28 : 0.12;
    return Color.alphaBlend(
      tintColor.withOpacity(opacity),
      colorScheme.surface,
    );
  }

  Color _adaptiveBorderColor(BuildContext context, Color baseColor) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return baseColor.withOpacity(isDark ? 0.6 : 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyTabs 示例'),
        h2('基本用法'),
        p('展示基本的标签页切换功能'),
        WidgetHighlight(
          builder: (_) {
            return EasyTabs(
              tabs: [
                EasyTabItem(label: '全部', value: 'tab1'),
                EasyTabItem(label: '进行中', value: 'tab2'),
                EasyTabItem(label: '已完成', value: 'tab3'),
                EasyTabItem(label: '已取消', value: 'tab4'),
              ],
              value: _selectedTab1,
              onChange: (value) {
                setState(() {
                  _selectedTab1 = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabs: [
    EasyTabItem(
      label: '全部',
      value: 'tab1',
    ),
    EasyTabItem(
      label: '进行中',
      value: 'tab2',
    ),
    EasyTabItem(
      label: '已完成',
      value: 'tab3',
    ),
    EasyTabItem(
      label: '已取消',
      value: 'tab4',
    ),
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h2('带内容的标签页'),
        p('使用 content 属性在选中标签页时显示对应的内容区域'),
        WidgetHighlight(
          builder: (_) {
            return EasyTabs(
              tabs: [
                EasyTabItem(
                  label: '基本信息',
                  value: 'tab1',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.blue),
                    child: const Text('这是基本信息的内容区域'),
                  ),
                ),
                EasyTabItem(
                  label: '详细信息',
                  value: 'tab2',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.green),
                    child: const Text('这是详细信息的内容区域'),
                  ),
                ),
                EasyTabItem(
                  label: '设置',
                  value: 'tab3',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.orange),
                    child: const Text('这是设置的内容区域'),
                  ),
                ),
              ],
              value: _selectedTab2,
              onChange: (value) {
                setState(() {
                  _selectedTab2 = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabs: [
    EasyTabItem(
      label: '基本信息',
      value: 'tab1',
      content: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue.shade50,
        child: const Text('这是基本信息的内容区域'),
      ),
    ),
    EasyTabItem(
      label: '详细信息',
      value: 'tab2',
      content: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.green.shade50,
        child: const Text('这是详细信息的内容区域'),
      ),
    ),
    EasyTabItem(
      label: '设置',
      value: 'tab3',
      content: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.orange.shade50,
        child: const Text('这是设置的内容区域'),
      ),
    ),
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h2('自定义高度'),
        p('通过 height 参数自定义标签栏的高度'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyTabs(
                  tabs: [
                    EasyTabItem(label: '标签1', value: 'tab1'),
                    EasyTabItem(label: '标签2', value: 'tab2'),
                    EasyTabItem(label: '标签3', value: 'tab3'),
                  ],
                  value: _selectedTab3,
                  onChange: (value) {
                    setState(() {
                      _selectedTab3 = value;
                    });
                  },
                  height: 60,
                ),
                const SizedBox(height: 16),
                EasyTabs(
                  tabs: [
                    EasyTabItem(label: '标签1', value: 'tab1'),
                    EasyTabItem(label: '标签2', value: 'tab2'),
                    EasyTabItem(label: '标签3', value: 'tab3'),
                  ],
                  value: _selectedTab3,
                  onChange: (value) {
                    setState(() {
                      _selectedTab3 = value;
                    });
                  },
                  height: 40,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// 高度为 60
EasyTabs(
  tabs: [
    EasyTabItem(label: '标签1', value: 'tab1'),
    EasyTabItem(label: '标签2', value: 'tab2'),
    EasyTabItem(label: '标签3', value: 'tab3'),
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
  height: 60,
)

// 高度为 40
EasyTabs(
  tabs: [
    EasyTabItem(label: '标签1', value: 'tab1'),
    EasyTabItem(label: '标签2', value: 'tab2'),
    EasyTabItem(label: '标签3', value: 'tab3'),
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
  height: 40,
)
```
''',
        ),
        h2('自定义装饰'),
        p('通过 decoration 参数自定义标签栏的边框样式'),
        WidgetHighlight(
          builder: (_) {
            return EasyTabs(
              tabs: [
                EasyTabItem(label: '首页', value: 'tab1'),
                EasyTabItem(label: '产品', value: 'tab2'),
                EasyTabItem(label: '关于', value: 'tab3'),
              ],
              value: _selectedTab4,
              onChange: (value) {
                setState(() {
                  _selectedTab4 = value;
                });
              },
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _adaptiveBorderColor(context, Colors.blue),
                    width: 2,
                  ),
                ),
                color: _adaptiveTintBackground(context, Colors.grey),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabs: [
    EasyTabItem(label: '首页', value: 'tab1'),
    EasyTabItem(label: '产品', value: 'tab2'),
    EasyTabItem(label: '关于', value: 'tab3'),
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
  decoration: BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.blue.withOpacity(0.3),
        width: 2,
      ),
    ),
    color: Colors.grey.shade100,
  ),
)
```
''',
        ),
        h2('复杂内容示例'),
        p('展示在标签页内容中使用复杂组件的场景'),
        WidgetHighlight(
          builder: (_) {
            return EasyTabs(
              tabs: [
                EasyTabItem(
                  label: '列表',
                  value: 'list',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '列表内容',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          5,
                          (index) => ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text('列表项 ${index + 1}'),
                            subtitle: Text('这是第 ${index + 1} 个列表项'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                EasyTabItem(
                  label: '表单',
                  value: 'form',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '表单内容',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '用户名',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '密码',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('提交'),
                        ),
                      ],
                    ),
                  ),
                ),
                EasyTabItem(
                  label: '卡片',
                  value: 'card',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(
                        4,
                        (index) =>
                            Card(child: Center(child: Text('卡片 ${index + 1}'))),
                      ),
                    ),
                  ),
                ),
              ],
              value: _selectedTab2,
              onChange: (value) {
                setState(() {
                  _selectedTab2 = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabs: [
    EasyTabItem(
      label: '列表',
      value: 'list',
      content: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 列表内容...
          ],
        ),
      ),
    ),
    EasyTabItem(
      label: '表单',
      value: 'form',
      content: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 表单内容...
          ],
        ),
      ),
    ),
    // 更多标签页...
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h2('标签页位置 (tabPosition)'),
        p('通过 tabPosition 参数可以设置标签页相对于内容的位置，支持 top、bottom、left、right 四种位置'),
        h3('顶部位置 (top，默认)'),
        p('标签页在顶部，内容在下方，指示器横线在下方'),
        WidgetHighlight(
          builder: (_) {
            return EasyTabs(
              tabPosition: EasyTabPosition.top,
              tabs: [
                EasyTabItem(
                  label: '全部',
                  value: 'tab1',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.blue),
                    child: const Text('这是顶部标签页的内容'),
                  ),
                ),
                EasyTabItem(
                  label: '进行中',
                  value: 'tab2',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.green),
                    child: const Text('进行中的内容'),
                  ),
                ),
                EasyTabItem(
                  label: '已完成',
                  value: 'tab3',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    color: _adaptiveTintBackground(context, Colors.orange),
                    child: const Text('已完成的内容'),
                  ),
                ),
              ],
              value: _selectedTab5,
              onChange: (value) {
                setState(() {
                  _selectedTab5 = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabPosition: EasyTabPosition.top, // 默认值
  tabs: [
    EasyTabItem(
      label: '全部',
      value: 'tab1',
      content: Container(...),
    ),
    // 更多标签页...
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h3('底部位置 (bottom)'),
        p('标签页在底部，内容在上方，指示器横线在上方'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 200,
              child: EasyTabs(
                tabPosition: EasyTabPosition.bottom,
                tabs: [
                  EasyTabItem(
                    label: '首页',
                    value: 'tab1',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.blue),
                      child: const Text('首页内容'),
                    ),
                  ),
                  EasyTabItem(
                    label: '发现',
                    value: 'tab2',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.green),
                      child: const Text('发现内容'),
                    ),
                  ),
                  EasyTabItem(
                    label: '我的',
                    value: 'tab3',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.orange),
                      child: const Text('我的内容'),
                    ),
                  ),
                ],
                value: _selectedTab6,
                onChange: (value) {
                  setState(() {
                    _selectedTab6 = value;
                  });
                },
              ),
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabPosition: EasyTabPosition.bottom,
  tabs: [
    EasyTabItem(
      label: '首页',
      value: 'tab1',
      content: Container(...),
    ),
    // 更多标签页...
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h3('左侧位置 (left)'),
        p('标签页在左侧，内容在右侧，标签页垂直排列，指示器竖线在右边'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyTabs(
                tabPosition: EasyTabPosition.left,
                height: 150,
                tabs: [
                  EasyTabItem(
                    label: '用户管理',
                    value: 'tab1',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.blue),
                      child: const Text('用户管理内容区域'),
                    ),
                  ),
                  EasyTabItem(
                    label: '权限设置',
                    value: 'tab2',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.green),
                      child: const Text('权限设置内容区域'),
                    ),
                  ),
                  EasyTabItem(
                    label: '系统配置',
                    value: 'tab3',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.orange),
                      child: const Text('系统配置内容区域'),
                    ),
                  ),
                ],
                value: _selectedTab7,
                onChange: (value) {
                  setState(() {
                    _selectedTab7 = value;
                  });
                },
              ),
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabPosition: EasyTabPosition.left,
  height: 150, // 对于 left/right 位置，height 表示宽度
  tabs: [
    EasyTabItem(
      label: '用户管理',
      value: 'tab1',
      content: Container(...),
    ),
    // 更多标签页...
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h3('右侧位置 (right)'),
        p('标签页在右侧，内容在左侧，标签页垂直排列，指示器竖线在左边'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyTabs(
                tabPosition: EasyTabPosition.right,
                height: 150,
                tabs: [
                  EasyTabItem(
                    label: '设置',
                    value: 'tab1',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.blue),
                      child: const Text('设置内容区域'),
                    ),
                  ),
                  EasyTabItem(
                    label: '帮助',
                    value: 'tab2',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.green),
                      child: const Text('帮助内容区域'),
                    ),
                  ),
                  EasyTabItem(
                    label: '关于',
                    value: 'tab3',
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      color: _adaptiveTintBackground(context, Colors.orange),
                      child: const Text('关于内容区域'),
                    ),
                  ),
                ],
                value: _selectedTab4,
                onChange: (value) {
                  setState(() {
                    _selectedTab4 = value;
                  });
                },
              ),
            );
          },
          codeSnippet: '''
```dart
EasyTabs(
  tabPosition: EasyTabPosition.right,
  height: 150, // 对于 left/right 位置，height 表示宽度
  tabs: [
    EasyTabItem(
      label: '设置',
      value: 'tab1',
      content: Container(...),
    ),
    // 更多标签页...
  ],
  value: _selectedTab,
  onChange: (value) {
    setState(() {
      _selectedTab = value;
    });
  },
)
```
''',
        ),
        h2('EasyTabs 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyTabs 参数说明：'),
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
                        DataCell(Text('tabs')),
                        DataCell(Text('List<EasyTabItem>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('标签页列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('value')),
                        DataCell(Text('dynamic')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('当前选中的标签页值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChange')),
                        DataCell(Text('ValueChanged<dynamic>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('标签页切换时的回调函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('50 (top/bottom) 或 120 (left/right)')),
                        DataCell(Text('否')),
                        DataCell(Text('标签栏的高度（top/bottom位置）或宽度（left/right位置）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decoration')),
                        DataCell(Text('BoxDecoration?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '标签栏的装饰样式，默认有底部边框（top）或顶部边框（bottom）或右侧边框（left）或左侧边框（right）',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tabPosition')),
                        DataCell(Text('EasyTabPosition')),
                        DataCell(Text('EasyTabPosition.top')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '标签页相对于内容的位置：top（顶部，默认）、bottom（底部）、left（左侧）、right（右侧）',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyTabItem 参数说明：'),
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
                        DataCell(Text('label')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('标签页显示的文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('value')),
                        DataCell(Text('dynamic')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('标签页的唯一标识值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('content')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选中该标签页时显示的内容区域')),
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
