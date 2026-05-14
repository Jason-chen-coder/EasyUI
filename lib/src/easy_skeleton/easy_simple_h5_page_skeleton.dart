import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../easy_ui.dart';

class EasySimpleH5PageSkeleton extends StatelessWidget {
  const EasySimpleH5PageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.of(context).size;
        final width =
            constraints.hasBoundedWidth
                ? constraints.maxWidth
                : mediaSize.width;
        final height =
            constraints.hasBoundedHeight
                ? constraints.maxHeight
                : mediaSize.height;

        return SizedBox(
          width: width,
          height: height,
          child: _buildSkeleton(context),
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return Container(
      color: easyTheme.background,
      child: ListView(
        padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
        children: [
          _buildSectionSkeleton(context, height: 300),
          _buildSectionSkeleton(context, height: 400),
          _buildSectionSkeleton(context, height: 250),
        ],
      ),
    );
  }

  Widget _buildSectionSkeleton(context, {required double height}) {
    final easyTheme = EasyTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: easyTheme.neutralEE,
          highlightColor: easyTheme.background,
          period: const Duration(milliseconds: 1000),
          child: Container(
            width: 150,
            height: 22,
            decoration: BoxDecoration(
              color: easyTheme.neutralEE,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
        SizedBox(height: 15),
        Shimmer.fromColors(
          baseColor: easyTheme.neutralEE,
          highlightColor: easyTheme.background,
          period: const Duration(milliseconds: 1000),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: easyTheme.neutralEE,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
