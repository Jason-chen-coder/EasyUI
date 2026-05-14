import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_ui/easy_ui.dart';

class EasyStepIndicator extends StatelessWidget {
  final int stepsLength;
  final List<String> stepNames;
  final int currentStep;
  final double height;

  const EasyStepIndicator({
    super.key,
    required this.stepsLength,
    required this.stepNames,
    required this.currentStep,
    this.height = 76,
  });

  Color _getBackgroundColor(BuildContext context, int stepIndex) {
    final primaryGreen = EasyTheme.of(context).primaryGreen;
    if (stepIndex < currentStep) return primaryGreen;
    if (stepIndex == currentStep) {
      if (stepIndex == stepsLength - 1) return primaryGreen;
      return primaryGreen.withOpacity(0.2);
    }
    return EasyTheme.of(context).neutralF8;
  }

  Color _getTextColor(BuildContext context, int stepIndex) {
    final primaryGreen = EasyTheme.of(context).primaryGreen;
    if (stepIndex < currentStep) return EasyTheme.of(context).background;
    if (stepIndex == currentStep) {
      if (stepIndex == stepsLength - 1) return EasyTheme.of(context).background;
      return primaryGreen;
    }
    return EasyTheme.of(context).neutral99;
  }

  @override
  Widget build(BuildContext context) {
    if (stepsLength == 0) return const SizedBox();

    return Container(
      height: height,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          if (availableWidth == double.infinity) {
            availableWidth = stepsLength * 120.0;
          }

          final double minTotalWidth = stepsLength * 120.0;
          final double width = max(availableWidth, minTotalWidth);

          final double height = 44.0;
          final double arrowWidth = 20.0;
          final double gap = 4.0;
          final double overlap = arrowWidth - gap;

          double W = (width + (stepsLength - 1) * overlap) / stepsLength;

          Widget content = SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: List.generate(stepsLength, (index) {
                final isFirst = index == 0;
                final isLast = index == stepsLength - 1;
                final double leftOffset = index * (W - overlap);

                return Positioned(
                  left: leftOffset,
                  top: 0,
                  bottom: 0,
                  width: W,
                  child: ClipPath(
                    clipper: ChevronClipper(
                      arrowWidth: arrowWidth,
                      isFirst: isFirst,
                      isLast: isLast,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: _getBackgroundColor(context, index),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: isFirst ? 16.0 : 16.0 + arrowWidth * 0.5,
                        right: isLast ? 16.0 : 16.0 + arrowWidth * 0.5,
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(context, index),
                          // Provide default font family to avoid Material default yellow underline if no Theme exists in the context path somehow, though not strictly necessary.
                        ),
                        child: Text(
                          stepNames.length > index
                              ? stepNames[index]
                              : '${index + 1}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );

          if (width > availableWidth) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }
}

class ChevronClipper extends CustomClipper<Path> {
  final double arrowWidth;
  final bool isFirst;
  final bool isLast;

  ChevronClipper({
    required this.arrowWidth,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (isFirst && isLast) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (isFirst) {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
    } else if (isLast) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ChevronClipper oldClipper) {
    return oldClipper.arrowWidth != arrowWidth ||
        oldClipper.isFirst != isFirst ||
        oldClipper.isLast != isLast;
  }
}
