import 'package:easy_ui/easy_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class DrawerDemo extends StatelessWidget {
  const DrawerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyDrawer 抽屉组件'),
        h2('EasyDrawer 组件概述'),
        p(
          'EasyDrawer 是一个功能丰富的抽屉组件，支持多种尺寸、自定义头部与底部、滚动内容等功能。配合 EasyDrawerWrapper 可实现带动画的抽屉显示与隐藏效果。',
        ),
        // 1.带头部和底部的抽屉
        h2('带头部和底部的抽屉'),
        p('包含顶部栏与底部操作区的完整抽屉。'),
        WidgetHighlight(
          builder: (_) => _CompleteDrawerDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
  onPressed: () {
    Scaffold.of(context).openEndDrawer();
  },
  child: const Text('打开完整抽屉'),
);

// 在 Scaffold 中使用
Scaffold(
  endDrawer: EasyDrawer(
    header: const EasyDrawerTopBar(
      title: '设置',
    ),
    body: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('通知设置'),
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('隐私设置'),
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('安全设置'),
        ),
      ],
    ),
    footer: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: EasyDrawerFooterButton(
            text: '保存',
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  ),
  // ...
);
```
''',
        ),

        h1('EasyDrawerWrapper 全局抽屉控制器'),
        h2('EasyDrawerWrapper 组件概述'),
        p('EasyDrawerWrapper 是一个基于 Overlay 的抽屉控制器（非单例，每次使用请创建实例）。'),
        // 2.不同尺寸的抽屉
        h2('不同尺寸的抽屉'),
        p('支持小、中、大与全屏四种尺寸。'),
        WidgetHighlight(
          builder: (_) => _DifferentSizeDrawerDemo(),
          codeSnippet: '''
```dart
Column(
  children: [
    ElevatedButton(
      onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.small),
      child: const Text('小尺寸抽屉 (456px)'),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
      onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.medium),
      child: const Text('中尺寸抽屉 (714px)'),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
      onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.large),
      child: const Text('大尺寸抽屉 (914px)'),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
      onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.full),
      child: const Text('全屏抽屉'),
    ),
  ],
);

void _showDrawerWithSize(BuildContext context, EasyDrawerSize size) {
  final wrapper = EasyDrawerWrapper();
  wrapper.show(
    context: context,
    child: EasyDrawer(
      size: size,
      header: EasyDrawerTopBar(
        title: size.name+'尺寸抽屉',
      ),
      body: const Center(
        child: Text('抽屉内容区域'),
      ),
    ),
  );
}
```
''',
        ),
        // 3.确认关闭抽屉
        h2('确认关闭抽屉'),
        p('在关闭前显示确认对话框，防止意外丢失数据。'),
        WidgetHighlight(
          builder: (_) => _ConfirmCloseDrawerDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
  onPressed: () {
    final wrapper = EasyDrawerWrapper();
    wrapper.show(
      context: context,
      confirmBeforeClose: true,
      child: EasyDrawer(
        header: const EasyDrawerTopBar(
          title: '编辑表单',
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        footer: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: wrapper.close,
                child: Text('取消'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: EasyDrawerFooterButton(
                text: '保存',
                onPressed: wrapper.close,
              ),
            ),
          ],
        ),
      ),
    );
  },
  child: const Text('显示确认关闭抽屉'),
);
```
''',
        ),
        // 4.抽屉内再打开抽屉（叠加）
        h2('抽屉内再打开抽屉（叠加）'),
        p('先打开抽屉 A，然后在 A 的内容区域再打开抽屉 B，B 将覆盖在 A 上方。适用于分步表单或从详情进入更深一层编辑等场景。'),
        WidgetHighlight(
          builder: (_) => _NestedDrawersDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
  onPressed: () {
    final wrapperA = EasyDrawerWrapper();
    wrapperA.show(
      context: context,
      fromRight: true,
      child: EasyDrawer(
        header: EasyDrawerTopBar(
          title: '抽屉 A',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('这里是 A 的内容'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final wrapperB = EasyDrawerWrapper();
                  wrapperB.show(
                    context: context,
                    fromRight: true,
                    child: EasyDrawer(
                      header: EasyDrawerTopBar(
                        title: '抽屉 B（覆盖在 A 上）',
                      ),
                      body: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('这里是 B 的内容'),
                      ),
                      footer: Row(
                        children: [
                          Expanded(
                            child: EasyDrawerFooterButton(
                              text: '关闭 B',
                              onPressed: wrapperB.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('在 A 里打开 B'),
              ),
            ],
          ),
        ),
      ),
    );
  },
  child: const Text('打开抽屉 A'),
)
```
''',
        ),
        // 5.DropdownButton2
        h2('抽屉中使用 DropdownButton2'),
        p(
          '当抽屉内容使用 DropdownButton2 等需要 Navigator 上下文的组件时，可以通过在 EasyDrawer 传递 needNavigatorWrapper:true 来解决上下文问题。',
        ),
        WidgetHighlight(
          builder: (_) => _DropdownButton2InDrawerDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        final wrapper = EasyDrawerWrapper();
        wrapper.show(
          context: context,
          child: SizedBox(
            width: getEasyDrawerWidth(EasyDrawerSize.small),
            child: Navigator(
              onGenerateRoute: (settings) {
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      EasyDrawer(
                          size: EasyDrawerSize.medium,
                          header: EasyDrawerTopBar(title: '测试 DropdownButton2',actions: [DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              customButton: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.more_horiz_outlined,
                                  color: Color(0xff333333),
                                ),
                              ),
                              items: [DropdownMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "测试",
                                      ),
                                    ),
                                  ],
                                ),
                              ),],
                              onChanged: (value) {
                                print(value);
                              },
                              dropdownStyleData: DropdownStyleData(
                                width: 110,
                                padding:
                                const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8))),
                            ),
                          ),],),
                          body: Center(
                            child: Text('如果右上角的 DropdownButton2 能正常工作，说明 Navigator 上下文问题已解决。'),
                          )
                      ),
                );
              },
            ),
          ),
        );
      },
      child: const Text('测试 DropdownButton2'),
    );
```
''',
        ),
        // 6.在容器内打开抽屉
        h2('在容器内打开抽屉（Overlay 模式）'),
        p(
          '通过 DrawerRenderMode.overlay 模式，可以将抽屉限制在指定容器内部，抽屉会跟随容器滚动并受容器边界裁剪。注意：容器必须包含 Overlay widget。',
        ),
        WidgetHighlight(
          builder: (_) => _ContainerDrawerDemo(),
          codeSnippet: '''
```dart
class _ContainerDrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          width: double.infinity,
          height: 600,
          // 关键：使用 Overlay 包裹容器内容
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '这是一个容器，抽屉将在此容器内打开',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final wrapper = EasyDrawerWrapper();
                          wrapper.show(
                            context: context,
                            confirmBeforeClose:true,
                            mode: DrawerRenderMode.overlay, // 使用 overlay 模式
                            child: EasyDrawer(
                              size: EasyDrawerSize.medium,
                              header: const EasyDrawerTopBar(
                                title: '容器内的抽屉',
                              ),
                              body: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('这个抽屉限制在容器内部'),
                                    SizedBox(height: 12),
                                    Text('• 抽屉会跟随容器滚动'),
                                    Text('• 抽屉会被容器边界裁剪'),
                                    Text('• 不会覆盖容器外的区域'),
                                  ],
                                ),
                              ),
                              footer: Builder(
                                builder: (context) => Row(
                                  children: [
                                    Expanded(
                                      child: EasyDrawerFooterButton(
                                        text: '关闭',
                                        onPressed: () {
                                          wrapper.close();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('在容器内打开抽屉'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
```
''',
        ),
        // EasyDrawer 参数说明
        h2('EasyDrawer 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyDrawer 参数说明：'),
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
                        DataCell(Text('body')),
                        DataCell(Text('Widget')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('抽屉主体内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('size')),
                        DataCell(Text('EasyDrawerSize')),
                        DataCell(Text('EasyDrawerSize.small')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '抽屉尺寸：small(456px)、medium(714px)、large(914px)、full(全屏)。',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('bodyPadding')),
                        DataCell(Text('EdgeInsets?')),
                        DataCell(
                          Text(
                            'EdgeInsets.all(24) 或 EdgeInsets.only(left: 24, right: 24, top: 24)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('主体内容内边距；存在 footer 时，默认不包含底部内边距。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color?')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('抽屉背景色。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('header')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('抽屉头部组件。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('footer')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('抽屉底部组件。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('footerPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text(
                            'EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('底部组件内边距。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('bodyScrollable')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否为主体内容启用滚动。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('needNavigatorWrapper')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '当抽屉内容使用 DropdownButton2 等需要 Navigator 上下文的组件时，设置为 true 可解决上下文问题。',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),

        // EasyDrawerTopBar 参数说明
        h2('EasyDrawerTopBar 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyDrawerTopBar 参数说明：'),
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
                        DataCell(Text('onBackButtonTap')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('Navigator.of(context).pop()')),
                        DataCell(Text('否')),
                        DataCell(Text('返回按钮点击事件。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('title')),
                        DataCell(Text('String')),
                        DataCell(Text('""')),
                        DataCell(Text('否')),
                        DataCell(Text('标题文本。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('titleStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(
                          Text(
                            'TextStyle(fontSize: 16, color: theme.neutral33)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('标题文本样式。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('titleWidget')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义标题组件，优先级高于 title。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('actions')),
                        DataCell(Text('List<Widget>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('顶部栏右侧操作按钮。')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),

        // EasyDrawerWrapper 参数说明
        h2('EasyDrawerWrapper 参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyDrawerWrapper.show() 方法参数说明：'),
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
                        DataCell(Text('context')),
                        DataCell(Text('BuildContext')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('构建上下文。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('child')),
                        DataCell(Text('Widget')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('抽屉内容组件。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('mode')),
                        DataCell(Text('DrawerRenderMode')),
                        DataCell(Text('DrawerRenderMode.route')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '渲染模式：route(全屏模式) 或 overlay(容器模式，需要容器包含 Overlay widget)。',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('duration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 250)')),
                        DataCell(Text('否')),
                        DataCell(Text('动画持续时间。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fromRight')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否从右侧滑入。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('scrimColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.black54')),
                        DataCell(Text('否')),
                        DataCell(Text('遮罩颜色。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('barrierDismissible')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否允许点击遮罩关闭。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('curve')),
                        DataCell(Text('Curve')),
                        DataCell(Text('Curves.easeOut')),
                        DataCell(Text('否')),
                        DataCell(Text('进入动画曲线。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reverseCurve')),
                        DataCell(Text('Curve')),
                        DataCell(Text('Curves.easeIn')),
                        DataCell(Text('否')),
                        DataCell(Text('退出动画曲线。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('enableSwipeToClose')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用滑动手势关闭。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('closeVelocity')),
                        DataCell(Text('double')),
                        DataCell(Text('600')),
                        DataCell(Text('否')),
                        DataCell(Text('触发关闭的滑动速度阈值。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('confirmBeforeClose')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('关闭前是否显示确认对话框。')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),

        // 注意事项
        h2('使用注意事项'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('使用 EasyDrawer 时请注意以下事项：'),
                const SizedBox(height: 8),
                p('1. EasyDrawer 可直接用于 Scaffold 的 drawer 或 endDrawer 属性。'),
                p('2. 使用 EasyDrawerWrapper 可获得更丰富的动画与交互能力。'),
                p(
                  '3. 当 bodyScrollable 为 true 时，body 会自动包裹在 SingleChildScrollView 中。',
                ),
                p('4. EasyDrawerWrapper 为非单例，可创建多个实例以同时显示多个抽屉。'),
                p('5. 当 confirmBeforeClose 为 true 时，点击遮罩或滑动关闭会先显示确认对话框。'),
                p(
                  '6. 存在 footer 时，bodyPadding 默认不包含底部内边距，避免与 footerPadding 重复。',
                ),
                p(
                  '7. EasyDrawerTopBar 的返回按钮默认执行 Navigator.pop()，可通过 onBackButtonTap 自定义。',
                ),
                p(
                  '8. 当抽屉内容使用 DropdownButton2 等需要 Navigator 上下文的组件时，可以通过在 EasyDrawer 传递 needNavigatorWrapper:true  来解决上下文问题。',
                ),
                p(
                  '9. 使用 DrawerRenderMode.overlay 模式时，容器必须包含 Overlay widget，抽屉会受容器边界限制。',
                ),
                p(
                  '10. DrawerRenderMode.route 模式（默认）使用全屏显示，支持返回键；overlay 模式在容器内显示，会跟随容器滚动。',
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

// 完整抽屉演示
class _CompleteDrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final wrapper = EasyDrawerWrapper();
        wrapper.show(
          context: context,
          child: EasyDrawer(
            header: const EasyDrawerTopBar(title: '设置'),
            body: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('通知设置'),
                ),
                ListTile(leading: Icon(Icons.privacy_tip), title: Text('隐私设置')),
                ListTile(leading: Icon(Icons.security), title: Text('安全设置')),
              ],
            ),
            footer: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: wrapper.close,
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EasyDrawerFooterButton(
                    text: '保存',
                    onPressed: wrapper.close,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Text('打开完整抽屉'),
    );
  }
}

// 不同尺寸抽屉演示
class _DifferentSizeDrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.small),
          child: const Text('小尺寸抽屉 (456px)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.medium),
          child: const Text('中尺寸抽屉 (714px)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.large),
          child: const Text('大尺寸抽屉 (914px)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showDrawerWithSize(context, EasyDrawerSize.full),
          child: const Text('全屏抽屉'),
        ),
      ],
    );
  }

  void _showDrawerWithSize(BuildContext context, EasyDrawerSize size) {
    final wrapper = EasyDrawerWrapper();
    wrapper.show(
      context: context,
      child: EasyDrawer(
        size: size,
        header: EasyDrawerTopBar(title: '${size.name} 尺寸抽屉'),
        body: const Center(child: Text('抽屉内容区域')),
      ),
    );
  }
}

// 确认关闭抽屉演示
class _ConfirmCloseDrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final wrapper = EasyDrawerWrapper();
        wrapper.show(
          context: context,
          confirmBeforeClose: true,
          child: EasyDrawer(
            header: const EasyDrawerTopBar(title: '编辑表单'),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: '姓名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '邮箱',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            footer: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: wrapper.close,
                    child: Text('取消'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: EasyDrawerFooterButton(
                    text: '保存',
                    onPressed: wrapper.close,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Text('显示确认关闭抽屉'),
    );
  }
}

// 抽屉中使用 DropdownButton 演示
class _DropdownInDrawerDemo extends StatefulWidget {
  @override
  State<_DropdownInDrawerDemo> createState() => _DropdownInDrawerDemoState();
}

class _DropdownInDrawerDemoState extends State<_DropdownInDrawerDemo> {
  String _selectedValue = 'option1';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final wrapper = EasyDrawerWrapper();
        wrapper.show(
          context: context,
          child: EasyDrawer(
            header: EasyDrawerTopBar(title: '测试 DropdownButton'),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('这个抽屉包含 DropdownButton，验证 Navigator 上下文是否正确：'),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedValue,
                    items: const [
                      DropdownMenuItem(value: 'option1', child: Text('选项 1')),
                      DropdownMenuItem(value: 'option2', child: Text('选项 2')),
                      DropdownMenuItem(value: 'option3', child: Text('选项 3')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                      print('选择了: $value');
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('如果 DropdownButton 能正常工作，说明 Navigator 上下文问题已解决。'),
                ],
              ),
            ),
          ),
        );
      },
      child: const Text('测试 DropdownButton'),
    );
  }
}

// 抽屉中使用 DropdownButton2 演示
class _DropdownButton2InDrawerDemo extends StatelessWidget {
  const _DropdownButton2InDrawerDemo();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final wrapper = EasyDrawerWrapper();
        wrapper.show(
          context: context,
          child: EasyDrawer(
            size: EasyDrawerSize.medium,
            needNavigatorWrapper: true,
            header: EasyDrawerTopBar(
              title: '测试 DropdownButton2',
              actions: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: Color(0xff333333),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Row(children: [Expanded(child: Text("测试"))]),
                      ),
                    ],
                    onChanged: (value) {
                      print("value:$value");
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 110,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Text(
                '如果右上角的 DropdownButton2 能正常工作，说明 Navigator 上下文问题已解决。',
              ),
            ),
          ),
        );
      },
      child: const Text('测试 DropdownButton2'),
    );
  }
}

// 抽屉内再打开抽屉（叠加）演示
class _NestedDrawersDemo extends StatelessWidget {
  const _NestedDrawersDemo();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final wrapperA = EasyDrawerWrapper();
        wrapperA.show(
          context: context,
          fromRight: true,
          child: EasyDrawer(
            size: EasyDrawerSize.medium,
            header: EasyDrawerTopBar(title: '抽屉 A'),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('这里是 A 的内容'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final wrapperB = EasyDrawerWrapper();
                      wrapperB.show(
                        context: context,
                        fromRight: true,
                        child: EasyDrawer(
                          size: EasyDrawerSize.small,
                          header: EasyDrawerTopBar(title: '抽屉 B（覆盖在 A 上）'),
                          body: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('这里是 B 的内容'),
                          ),
                          footer: Row(
                            children: [
                              Expanded(
                                child: EasyDrawerFooterButton(
                                  text: '关闭 B',
                                  onPressed: wrapperB.close,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text('在 A 里打开 B'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: const Text('打开抽屉 A'),
    );
  }
}

// 容器内抽屉演示
class _ContainerDrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 600,
        // 关键：使用 Overlay 包裹容器内容
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder:
                  (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '这是一个容器，抽屉将在此容器内打开',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final wrapper = EasyDrawerWrapper();
                            wrapper.show(
                              context: context,
                              confirmBeforeClose: true,
                              mode: DrawerRenderMode.overlay, // 使用 overlay 模式
                              child: EasyDrawer(
                                size: EasyDrawerSize.medium,
                                header: const EasyDrawerTopBar(title: '容器内的抽屉'),
                                body: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('这个抽屉限制在容器内部'),
                                      SizedBox(height: 12),
                                      Text('• 抽屉会跟随容器滚动'),
                                      Text('• 抽屉会被容器边界裁剪'),
                                      Text('• 不会覆盖容器外的区域'),
                                    ],
                                  ),
                                ),
                                footer: Builder(
                                  builder:
                                      (context) => Row(
                                        children: [
                                          Expanded(
                                            child: EasyDrawerFooterButton(
                                              text: '关闭',
                                              onPressed: () {
                                                wrapper.close();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            );
                          },
                          child: const Text('在容器内打开抽屉'),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
