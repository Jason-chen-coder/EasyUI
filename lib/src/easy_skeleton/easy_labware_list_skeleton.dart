import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../easy_theme.dart';

/// 实验耗材列表加载骨架屏组件
///
/// 展示一个 4 列网格布局的卡片加载动画，适用于耗材库列表页面。
class EasyLabwareListSkeleton extends StatelessWidget {
  const EasyLabwareListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.56;
    final easyTheme = EasyTheme.of(context);

    Widget buildSkeletonCard() {
      return Card(
        elevation: 3,
        color: easyTheme.background,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _shimmerBox(
                context,
                width: double.infinity,
                height: screenHeight * 0.10,
                borderRadius: BorderRadius.circular(4),
              ),
              SizedBox(height: 8),
              _shimmerBox(
                context,
                width: double.infinity,
                height: 60,
                borderRadius: BorderRadius.circular(4),
              ),
              SizedBox(height: 8),
              _shimmerBox(
                context,
                width: 120,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _shimmerBox(
                      context,
                      height: 40,
                      width: 40,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _shimmerBox(
                      context,
                      height: 40,
                      width: 40,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final rowCount = (screenHeight / cardHeight).ceil().clamp(2, 4);
    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rowCount - 1 ? 10 : 0),
          child: SizedBox(
            height: cardHeight / 4 * 3,
            child: Row(
              children: List.generate(4, (colIndex) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: colIndex < 3 ? 10 : 0),
                    child: buildSkeletonCard(),
                  ),
                );
              }),
            ),
          ),
        );
      }),
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
