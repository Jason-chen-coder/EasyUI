# Easy UI

<p align="center">
  <img src="readme_images/logo_image.png" alt="Easy UI Logo" width="132">
</p>

[![部署示例](https://github.com/Jason-chen-coder/EasyUI/actions/workflows/deploy-example.yml/badge.svg)](https://github.com/Jason-chen-coder/EasyUI/actions/workflows/deploy-example.yml)

中文 | [English](README.en.md)

Easy UI 是一个面向 Flutter 应用的 UI 组件库，用于构建 Web、桌面端和移动端的产品型界面。它将迁移后的 `Easy*` 组件、设计 token、交互模式和示例页面统一到一个可复用的 UI 层中，适合需要沉淀内部组件能力、减少重复页面实现的团队使用。

## 文档

在线示例是当前主要的文档和预览入口：

[https://jason-chen-coder.github.io/EasyUI/](https://jason-chen-coder.github.io/EasyUI/)

示例应用由 `example/` 目录通过 GitHub Actions 自动部署，包含独立首页、组件工作台、主题切换、语言切换和 Web 首屏加载反馈。具体组件的演示和配方应放在示例应用中维护，README 只保留项目级信息，避免变成长篇组件用法清单。

## 特性

- **Flutter 原生组件**：以 Flutter Widget 形式实现，并通过统一的包入口导出。
- **统一 Easy 命名**：迁移后的公开组件遵循 `Easy*` 命名约定。
- **覆盖产品型场景**：沉淀表单、数据展示、反馈、内容渲染等常见应用界面能力。
- **主题友好**：支持浅色/深色表现，并与 Easy UI 和 Material 主题体系集成。
- **国际化准备**：包含生成的本地化元数据，并在示例中提供语言切换。
- **Web 预览流程**：示例项目会自动构建并部署到 GitHub Pages。

## 安装

通过 GitHub 添加 Easy UI：

```yaml
dependencies:
  easy_ui:
    git:
      url: https://github.com/Jason-chen-coder/EasyUI.git
      ref: main
```

拉取依赖：

```bash
flutter pub get
```

在需要构建界面的地方导入包：

```dart
import 'package:easy_ui/easy_ui.dart';
```

## AI Skill

仓库内提供了 `easy-ui-view-builder` AI skill，用于让 Codex、Claude Code 等 AI 编程工具根据需求直接选择 Easy UI 组件并生成 Flutter 视图代码。

通过 `npx` 从 GitHub 安装到本机。默认会同时安装到 Codex 和 Claude Code：

```bash
npx --yes github:Jason-chen-coder/EasyUI
```

默认安装位置：

- Codex：`${CODEX_HOME:-~/.codex}/skills/easy-ui-view-builder`
- Claude Code：`~/.claude/skills/easy-ui-view-builder`

也可以只安装到其中一个目标：

```bash
npx --yes github:Jason-chen-coder/EasyUI -- --target codex
npx --yes github:Jason-chen-coder/EasyUI -- --target claude
npx --yes github:Jason-chen-coder/EasyUI -- --target claude-project
```

安装后重启 Codex 或 Claude Code，让新的 skill 被加载。使用时可以直接提到 skill 名称：

```text
$easy-ui-view-builder 帮我用 Easy UI 做一个带筛选、表格、分页和详情抽屉的订单管理页面
```

如果后续发布到 npm registry，也可以使用同样的参数：

```bash
npx --yes easy-ui-skill@latest
```

## 环境要求

当前仓库使用以下版本验证：

- Flutter `3.29.2`
- Dart `3.7.2`

该组件库面向 Flutter Web、桌面端和移动端应用。部分能力依赖平台相关插件；启用文件、通知、H5、PDF 或桌面端相关能力时，请结合示例项目确认平台配置。

## 仓库结构

```text
easy_ui/
├── lib/                 # 组件库源码和公共导出
├── assets/              # 组件使用的资源
├── fonts/               # 内置字体资源
├── test/                # 组件库测试
├── example/             # 可运行的 Flutter 示例应用
└── .github/workflows/   # CI 与 GitHub Pages 部署流程
```

## 本地开发

安装组件库依赖：

```bash
flutter pub get
```

运行静态检查和测试：

```bash
flutter analyze
flutter test
```

本地运行示例：

```bash
cd example
flutter pub get
flutter run -d chrome
```

构建 Web 示例：

```bash
cd example
flutter build web --release --no-web-resources-cdn --pwa-strategy=none
```

部署到 GitHub Pages 时，需要使用仓库路径作为 base href：

```bash
cd example
flutter build web --release \
  --base-href /EasyUI/ \
  --no-web-resources-cdn \
  --pwa-strategy=none
```

## 部署

`Deploy Example` workflow 会在推送到 `main` 和 `master` 时运行。

流程包括：

1. 安装组件库依赖
2. 运行组件库静态检查
3. 运行组件库测试
4. 安装示例项目依赖
5. 运行示例项目测试
6. 构建示例 Web 产物
7. 上传 GitHub Pages artifact
8. 部署到 GitHub Pages

线上地址：

[https://jason-chen-coder.github.io/EasyUI/](https://jason-chen-coder.github.io/EasyUI/)

## 贡献

贡献代码时请保持当前迁移规则一致：

- 公开组件名使用 `Easy*` 前缀。
- 文件名使用 `easy_*` 约定。
- 示例页面需要保持 Web 端可运行。
- 提交 PR 前运行 `flutter analyze` 和相关测试。
- 不要提交 `build/`、`.dart_tool/` 或本地平台配置等生成产物。

## 许可证

许可条款记录在 [LICENSE](LICENSE) 中。发布稳定版本前需要补全最终 license 文本。
