import 'package:easy_ui/src/easy_skeleton/easy_labware_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../easy_theme.dart';
import '../l10n/gen/easy_ui_localizations.dart';
import 'easy_report_detail_page_skeleton.dart';
import 'easy_simple_h5_page_skeleton.dart';

/// 快速示例
///
/// ```dart
/// // 1) 最简用法（默认骨架）
/// EasySkeleton(
///   isLoading: true,
///   child: MyContentWidget(),
/// );
///
/// // 2) 指定内置骨架（list）
/// EasySkeleton(
///   isLoading: true,
///   preset: SkeletonPreset.list,
///   child: MyContentWidget(),
/// );
///
/// // 3) 自定义骨架（优先）
/// EasySkeleton(
///   isLoading: true,
///   customSkeleton: MyCustomSkeletonWidget(),
///   child: MyContentWidget(),
/// );
///
/// // 4) 错误状态（isError 可不传）
/// EasySkeleton(
///   isLoading: false,
///   isError: true,
///   onRetry: _loadData,
///   child: MyContentWidget(),
/// );
///
/// // 5) 网格骨架（新增：指定行数和列数）
/// EasySkeleton(
///   isLoading: true,
///   rows: 3,
///   columns: 2,
///   child: MyContentWidget(),
/// );
///
/// // 6) 自定义元素骨架（新增：为网格每个元素自定义骨架）
/// EasySkeleton(
///   isLoading: true,
///   rows: 2,
///   columns: 2,
///   customElementSkeleton: Container(
///     height: 100,
///     decoration: BoxDecoration(
///       color: Colors.grey[300],
///       borderRadius: BorderRadius.circular(8),
///     ),
///   ),
///   child: MyContentWidget(),
/// );
/// ```
///
/// 说明：
/// - `isLoading` 与 `child` 为必传（最小使用接口）。
/// - `preset`、`isError`、`customSkeleton`、`onRetry` 可选；`customSkeleton` 优先级最高。
/// - `rows`、`columns`、`customElementSkeleton` 为新增的网格布局参数。
/// - 该注释会在类的文档中显示，方便使用者查看示例。
///
///
enum SkeletonPreset { avatar, list, card, chat, report, h5, text, labwareList }

class EasySkeleton extends StatelessWidget {
  final bool isLoading; // 是否在加载中（必传）
  final bool? isError; // 是否加载失败（可选）
  final SkeletonPreset? preset; // 内置骨架类型（可选）
  final Widget? customSkeleton; // 自定义骨架（可选，优先级最高）
  final Widget child; // 真实内容（必传）
  final VoidCallback? onRetry; // 错误重试回调（可选）
  final Duration fadeDuration; // 动画时长（可选）
  final EdgeInsets padding; // 内边距（可选，默认16）
  // 新增：网格布局参数
  final int rows; // 行数（默认1）
  final int columns; // 列数（默认1）
  final Widget? customElementSkeleton; // 自定义元素骨架（可选）
  final double? elementHeight; // 元素高度（可选）
  final double spacing; // 间距（默认12）
  final double elementBorderRadius; // 默认骨架子元素圆角（默认0）
  final Widget textContent;
  final Color baseColor;
  final Color? highlightColor;
  const EasySkeleton({
    super.key,
    required this.isLoading,
    required this.child,
    this.isError,
    this.preset,
    this.customSkeleton,
    this.onRetry,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.rows = 1,
    this.columns = 1,
    this.padding = const EdgeInsets.all(16.0),
    this.textContent = const SizedBox(),
    this.baseColor = const Color(0xff7C7C7C),
    this.highlightColor,
    this.customElementSkeleton,
    this.elementHeight,
    this.spacing = 12.0,
    this.elementBorderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCurrentState(context);
  }

  Widget _buildCurrentState(BuildContext context) {
    if (isError == true) {
      return _buildFailure(context);
    }

    if (isLoading) {
      return SingleChildScrollView(child: _buildSkeleton(context));
    }

    return KeyedSubtree(key: const ValueKey('easy_content'), child: child);
  }

  /// 失败占位（替换为 Easy UI Kit 内的 Empty 组件）
  Widget _buildFailure(BuildContext context) {
    return Center(
      key: const ValueKey('easy_error'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            EasyUiLocalizations.of(context).loadFailed,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(EasyUiLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }

  /// 加载中骨架（customSkeleton 优先）
  Widget _buildSkeleton(BuildContext context) {
    Widget content;
    if (customSkeleton != null) {
      content = KeyedSubtree(
        key: const ValueKey('easy_customSkeleton'),
        child: customSkeleton!,
      );
    } else {
      // 检查是否使用网格布局（rows > 1 或 columns > 1）或者指定了元素高度（需要走网格逻辑来应用 height）
      if (rows > 1 || columns > 1 || elementHeight != null) {
        content = KeyedSubtree(
          key: const ValueKey('easy_gridSkeleton'),
          child: _gridSkeleton(),
        );
      } else {
        // 单个骨架使用预设类型
        switch (preset) {
          case SkeletonPreset.avatar:
            content = KeyedSubtree(
              key: const ValueKey('easy_avatarSkeleton'),
              child: _avatarSkeleton(),
            );
          case SkeletonPreset.chat:
            content = KeyedSubtree(
              key: const ValueKey('easy_chatSkeleton'),
              child: _chatSkeleton(),
            );
          case SkeletonPreset.text:
            content = KeyedSubtree(
              key: const ValueKey('easy_textSkeleton'),
              child: _textSketon(
                textContent,
                baseColor: baseColor,
                highlightColor:
                    highlightColor ?? EasyTheme.of(context).background,
              ),
            );
          case SkeletonPreset.list:
            content = KeyedSubtree(
              key: const ValueKey('easy_listSkeleton'),
              child: _listSkeleton(),
            );
          case SkeletonPreset.card:
            content = KeyedSubtree(
              key: const ValueKey('easy_cardSkeleton'),
              child: _cardSkeleton(),
            );
          case SkeletonPreset.report:
            content = KeyedSubtree(
              key: const ValueKey('easy_cardSkeleton'),
              child: _reportSkeleton(),
            );
          case SkeletonPreset.h5:
            content = KeyedSubtree(
              key: const ValueKey('easy_cardSkeleton'),
              child: _h5tSkeleton(),
            );
          case SkeletonPreset.labwareList:
            content = KeyedSubtree(
              key: const ValueKey('easy_labwareListSkeleton'),
              child: _labwareListSkeleton(),
            );
          case null:
            content = KeyedSubtree(
              key: const ValueKey('easy_defaultSkeleton'),
              child: _defaultSkeleton(),
            );
        }
      }
    }
    return Padding(padding: padding, child: content);
  }

  Widget _avatarSkeleton() {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            _shimmerBox(context, width: 50, height: 50, shape: BoxShape.circle),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(context, width: double.infinity, height: 12),
                  const SizedBox(height: 8),
                  _shimmerBox(context, width: 100, height: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _textSketon(
    Widget textContent, {
    Color baseColor = const Color(0xff7C7C7C),
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: Duration(milliseconds: 3000),
      child: textContent,
    );
  }

  Widget _chatSkeleton() {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(context, width: double.infinity, height: 60),
            SizedBox(height: 80),
            Column(
              children: List.generate(2, (i) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerBox(
                                context,
                                width: double.infinity,
                                height: 75,
                              ),
                              const SizedBox(height: 5),
                              _shimmerBox(context, width: 200, height: 16),
                            ],
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _shimmerBox(
                                context,
                                width: double.infinity,
                                height: 75,
                              ),
                              const SizedBox(height: 5),
                              _shimmerBox(context, width: 200, height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _listSkeleton() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => _shimmerBox(
            context,
            width: double.infinity,
            height: 60,
            borderRadius: BorderRadius.circular(8),
          ),
    );
  }

  // 新增：单个列表项骨架（用于网格中按 preset 渲染）
  Widget _listItemSkeleton(BuildContext context) {
    return _shimmerBox(
      context,
      width: double.infinity,
      height: elementHeight ?? 60,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _cardSkeleton() {
    return Builder(
      builder: (context) {
        return _shimmerBox(
          context,
          width: double.infinity,
          height: 150,
          borderRadius: BorderRadius.circular(8),
        );
      },
    );
  }

  /// 报告详情页骨架
  Widget _reportSkeleton() {
    return const EasyReportDetailPageSkeleton();
  }

  /// 简单 H5 页面骨架
  Widget _h5tSkeleton() {
    return const EasySimpleH5PageSkeleton();
  }

  /// 实验耗材列表骨架
  Widget _labwareListSkeleton() {
    return const EasyLabwareListSkeleton();
  }

  Widget _defaultSkeleton() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => _shimmerBox(
            context,
            width: double.infinity,
            height: 40,
            borderRadius: BorderRadius.circular(4),
          ),
    );
  }

  /// 新增：网格骨架布局，支持与 preset 组合
  Widget _gridSkeleton() {
    return Builder(
      builder: (context) {
        Widget buildCell() {
          if (customElementSkeleton != null) return customElementSkeleton!;
          switch (preset) {
            case SkeletonPreset.avatar:
              return _avatarSkeleton();
            case SkeletonPreset.chat:
              return _chatSkeleton();
            case SkeletonPreset.text:
              return _textSketon(
                textContent,
                baseColor: baseColor,
                highlightColor:
                    highlightColor ?? EasyTheme.of(context).background,
              );
            case SkeletonPreset.list:
              return _listItemSkeleton(context);
            case SkeletonPreset.card:
              return _cardSkeleton();
            case SkeletonPreset.report:
              return _defaultElementSkeleton();
            case SkeletonPreset.h5:
              return _defaultElementSkeleton();
            case SkeletonPreset.labwareList:
              return _defaultElementSkeleton();
            case null:
              return _defaultElementSkeleton();
          }
        }

        return Column(
          children: List.generate(rows, (rowIndex) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < rows - 1 ? spacing : 0,
              ),
              child: Row(
                children: List.generate(columns, (columnIndex) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: columnIndex < columns - 1 ? spacing : 0,
                      ),
                      child: buildCell(),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      },
    );
  }

  /// 默认元素骨架
  Widget _defaultElementSkeleton() {
    return Builder(
      builder: (context) {
        final easyTheme = EasyTheme.of(context);
        final borderRadius =
            elementBorderRadius == 0
                ? BorderRadius.all(easyTheme.cornerSmall)
                : BorderRadius.circular(elementBorderRadius);
        return Shimmer.fromColors(
          baseColor: easyTheme.neutralEE,
          highlightColor: easyTheme.background,
          period: const Duration(milliseconds: 2000),
          child: Container(
            height: elementHeight ?? 60,
            decoration: BoxDecoration(
              color: easyTheme.neutralEE,
              borderRadius: borderRadius,
            ),
          ),
        );
      },
    );
  }

  /// 公共 shimmer 容器（使用 shimmer 插件）
  Widget _shimmerBox(
    BuildContext context, {
    required double width,
    required double height,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final easyTheme = EasyTheme.of(context);

    return Shimmer.fromColors(
      baseColor: easyTheme.neutralEE,
      highlightColor: easyTheme.background,
      period: const Duration(milliseconds: 2000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: easyTheme.neutralEE,
          borderRadius:
              shape == BoxShape.rectangle
                  ? (borderRadius ?? BorderRadius.all(easyTheme.cornerSmall))
                  : null,
        ),
      ),
    );
  }
}
