# Example Demo Page Agent Guide

本文件用于指导 AI 助手在 `easy-ui/example` 中快速、稳定地生成新的组件示例页面。

目标不是“随便做一个 Demo”，而是让新增页面与当前 example 项目的菜单结构、概览页、资源命名和展示风格保持一致。

## 适用范围

- 新增一个组件示例页面
- 为已有组件补充 example 演示
- 为概览页补充骨架 SVG
- 在菜单中注册新页面并确保可导航

## 先理解这个 example 的组织方式

- 入口文件是 `lib/main.dart`
- 菜单树定义在 `lib/menu.dart`
- 页面通过 `TreeNode(routeName, builder)` 注册到左侧菜单
- `lib/view/overview.dart` 会读取 `treeItems` 自动生成概览卡片
- 概览卡片的 SVG 资源路径规则是：
  `assets/overview/${routeName.replaceAll('/', '')}.svg`

这意味着：

1. 只要新增了菜单路由，overview 就可能尝试加载对应 SVG
2. 如果没有对应 SVG，不会崩，但会显示占位图标
3. 如果希望概览页完整展示，必须同步补上对应命名的骨架 SVG

## AI 执行总原则

- 优先复用现有 example 的结构和工具类，不新造一套 Demo 模板
- 优先复用 `easy_ui` 中已经提供的组件，不用原生组件替代核心展示
- 新页面应尽量保持“文档页”风格，而不是只堆一个组件
- 修改范围最小化，只动和当前示例有关的文件
- 不要顺手重构 `main.dart`、`menu.dart` 或其他无关示例页

## 新增示例页时的标准流程

1. 先判断组件属于哪个分类
2. 在对应 `lib/view/...` 目录新增页面文件
3. 在 `lib/main.dart` 增加 import
4. 在 `lib/menu.dart` 注册 `TreeNode`
5. 在 `assets/overview/` 新增对应骨架 SVG
6. 自查页面是否能从左侧菜单和概览页进入

## 1. 骨架 SVG 的制作规则

### 目标

概览页中的 SVG 不是完整 UI 截图，而是“组件结构骨架图”。它的作用是让用户快速理解组件形态。

### 命名规则

SVG 文件名必须与路由名严格对应：

- 路由 `'/localNotification'` 对应 `assets/overview/localNotification.svg`
- 路由 `'/easySignaturePadDemo'` 对应 `assets/overview/easySignaturePadDemo.svg`
- 路由 `'/tabs'` 对应 `assets/overview/tabs.svg`

规则就是去掉路由最前面的 `/`。

### 绘制原则

- 优先使用简化结构，不画真实业务细节
- 保持扁平、清晰、线框化
- 尺寸优先参考现有资源，通常使用：
  `width="320px" height="100px" viewBox="0 0 320 100"`
- 颜色保持克制，参考现有 overview 资源
- 常用占位元素：
  - 容器：`#FFFFFF` 背景 + `#E0E0E0` 边框
  - 文本行：`#EBEBEB` / `#F5F5F5`
  - 状态强调色：少量点缀色即可

### 资源风格参考

- `assets/overview/localNotification.svg`
- `assets/overview/skeleton.svg`
- `assets/overview/easySignaturePadDemo.svg`

### 不要这样做

- 不要导出复杂渐变、大量滤镜、超大 SVG
- 不要把真实截图转成 SVG
- 不要让骨架图尺寸与现有 overview 卡片风格差异太大

## 2. 在 menu 中定位路由和页面

### 菜单注册位置

所有示例页都通过 `lib/menu.dart` 中的 `treeItems` 注册。

AI 必须先判断组件应该挂在哪个一级分类下：

- 基础组件
- 数据展示
- 数据输入
- 反馈组件
- 导航组件
- 布局
- 分页
- 富文本
- 其他组件

### 注册方式

新增节点时使用现有 `TreeNode` 结构：

```dart
TreeNode(
  title: '签名板',
  routeName: '/easySignaturePadDemo',
  builder: (context) => const EasySignaturePadExample(),
),
```

### 同步修改点

新增页面通常至少需要改两个地方：

- `lib/main.dart`：补 import
- `lib/menu.dart`：补 `TreeNode`

### 路由选择原则

- `routeName` 要简洁、稳定、可读
- 不要随意改已有 routeName，否则 overview 对应 SVG 名也要一起改
- 如果是某个分类下的普通示例页，优先使用单层 routeName，不必额外设计复杂层级

## 3. 页面搭建规则

### 页面结构必须贴近现有风格

优先参考：

- `lib/view/easy_signature_pad_example.dart`
- `lib/view/data_display/skeleton.dart`

推荐页面骨架：

```dart
return Body.multi(
  children: [
    h1('组件名称'),
    p('组件用途说明'),
    div(),
    h2('组件预览'),
    WidgetHighlight(
      builder: (context) => ...,
      codeSnippet: '''
```dart
...
```
''',
    ),
    h2('参数说明'),
    WidgetHighlight(
      builder: (_) => ...,
      codeSnippet: '',
    ),
  ],
);
```

### 推荐使用的页面辅助组件

- `Body.multi`
- `WidgetHighlight`
- `h1 / h2 / p / div`

这些工具已经形成了 example 项目的统一文档感，新增页面应继续沿用。

### 示例内容应该怎么组织

一个合格的组件示例页，至少应包含：

1. 组件标题和一句话说明
2. 组件预览区域
3. 可复制/可阅读的代码片段
4. 至少一个真实交互场景或不同状态

如果组件参数较多，再补：

- 状态组合示例
- 注意事项

### 组件使用原则

- 优先直接使用我提供的 `easy_ui` 组件
- 不要为了省事改成原生 Flutter 组件替代核心能力
- 原生组件只能作为包裹和辅助，比如 `Column`、`Wrap`、`SizedBox`、`LayoutBuilder`
- 如果示例里需要按钮、文本、卡片等辅助元素，优先考虑是否已有 UI Kit 组件可用

### 代码片段规则

- `WidgetHighlight.codeSnippet` 传 markdown 字符串
- 代码块请使用 ```dart fenced code block
- 代码片段尽量与实际 `builder` 中展示的核心代码一致
- 不要放与示例无关的大段样板代码

## 文件放置建议

新增示例页时，按组件分类放到对应目录：

- 基础组件：`lib/view/base/`
- 数据展示：`lib/view/data_display/`
- 数据输入：`lib/view/data_entry/`
- 反馈组件：`lib/view/feedback/`
- 导航组件：`lib/view/navigation/`
- 布局：`lib/view/layout/`
- 分页：`lib/view/pagination/`
- 其他组件：`lib/view/other/`

如果现有目录中已经有最接近的类别，不要新建平行目录。

## 新增页面时的检查清单

- 是否已放在正确的 `lib/view/...` 分类目录
- 是否已在 `lib/main.dart` import
- 是否已在 `lib/menu.dart` 注册
- `routeName` 是否唯一且命名合理
- 是否已补 `assets/overview/<route>.svg`
- 页面是否使用 `Body.multi`
- 页面是否使用 `WidgetHighlight`
- 是否优先使用 UI Kit 组件搭建
- 概览页点击卡片后是否能正确进入页面
- 左侧菜单点击后是否能正确进入页面

## AI 不应做的事

- 不要修改 `overview.dart` 的资源命名规则来迁就新页面
- 不要绕过 `menu.dart` 直接写死导航
- 不要只新增 Dart 页面却不注册菜单
- 不要只注册菜单却忘记补 overview SVG
- 不要让页面风格和现有示例体系脱节
- 不要为了演示方便写过度复杂的状态管理

## 建议的工作方式

当用户要求“新增一个组件示例页”时，AI 应默认执行下面的顺序：

1. 找到最接近的现有示例页作为模板
2. 确认分类目录、菜单位置和 routeName
3. 创建页面文件
4. 更新 `main.dart` 和 `menu.dart`
5. 创建 overview 骨架 SVG
6. 最后检查菜单、路由和资源命名是否一致

如果用户没有特别说明，默认同时完成“页面 + 菜单 + SVG”三部分，而不是只做其中一项。
