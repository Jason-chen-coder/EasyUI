# 组件库示例

本项目提供了αLab组件库的示例，以下是向项目添加新组件说明的步骤：

## 步骤 1: 在 `menu.dart` 中添加新项

在 `menu.dart` 文件中，找到 `_treeItems` 列表，并添加一个新的 `TreeNode` 项。示例如下：

```dart
TreeNode(
  title: '新组件名称',
  routeName: '/newComponent',
  builder: (context) => const NewComponentExample(),
),
```

`title` 是组件的名称，`routeName` 是路由名称，`builder` 是对应的组件示例页面。

## 步骤 2: 在 `page` 文件夹中添加示例组件

在 `example/lib/page` 文件夹中，创建一个新的 Dart 文件，例如 `new_component_example.dart`，并实现组件的示例代码。示例如下：

```dart
import 'package:flutter/material.dart';

class NewComponentExample extends StatelessWidget {
  const NewComponentExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新组件示例'),
      ),
      body: const Center(
        child: Text('这是新组件的示例页面'),
      ),
    );
  }
}
```

## 示例参考
项目中提供了一些组件，使构建组件说明更加容易

可以参考 `demo` 文件夹中的示例：
- `demo_page_markdown.dart`
- `demo_page.dart`

