import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../easy_theme.dart';

class EasyListSkeleton extends StatelessWidget {
  final double height;
  final double space;
  final int count;
  const EasyListSkeleton({
    super.key,
    this.height = 120,
    this.space = 8,
    this.count = 10,
  });

  @override
  Widget build(BuildContext context) {
    final easyThem = EasyTheme.of(context);

    return ListView.separated(
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: easyThem.neutralEE,
          highlightColor: Colors.white,
          period: const Duration(milliseconds: 1800),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: easyThem.neutralEE,
              borderRadius: BorderRadius.all(easyThem.cornerSmall),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: space);
      },
      itemCount: count,
    );
  }
}
