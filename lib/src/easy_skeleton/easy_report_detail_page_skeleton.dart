import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EasyReportDetailPageSkeleton extends StatelessWidget {
  const EasyReportDetailPageSkeleton({super.key});

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

    return Column(
      children: [
        // Header skeleton
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: easyTheme.background,
            boxShadow: [
              BoxShadow(
                color: easyTheme.onBackground.withOpacity(0.05),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              // Back button
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
              // Title
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 250,
                    height: 34,
                    child: Shimmer.fromColors(
                      baseColor: easyTheme.neutralEE,
                      highlightColor: easyTheme.background,
                      period: const Duration(seconds: 1),
                      child: Container(
                        width: 100,
                        height: 24,
                        decoration: BoxDecoration(
                          color: easyTheme.neutralEE,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Empty space to balance the back button
              SizedBox(width: 48),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: easyTheme.neutralEE,
        ),
        Expanded(
          child: Row(
            children: [
              // Left sidebar skeleton
              Container(
                width: 180,
                color: easyTheme.background,
                padding: EdgeInsets.only(left: 30),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 30),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: easyTheme.neutralEE,
                          highlightColor: easyTheme.background,
                          period: const Duration(milliseconds: 1000),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: easyTheme.neutralEE,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),

              // Right content skeleton
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
                  children: [
                    // Experiment Status skeleton
                    _buildSectionSkeleton(context, height: 300),

                    // Protocol skeleton
                    _buildSectionSkeleton(context, height: 400),

                    // Devices & Modules skeleton
                    _buildSectionSkeleton(context, height: 250),

                    // Other Materials skeleton
                    _buildSectionSkeleton(context, height: 200),

                    // Protocol Steps skeleton
                    _buildSectionSkeleton(context, height: 350),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionSkeleton(BuildContext context, {required double height}) {
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
