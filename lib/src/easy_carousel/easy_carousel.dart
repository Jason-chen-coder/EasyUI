import 'package:easy_ui/src/easy_theme.dart';

import 'package:shadcn_flutter/shadcn_flutter.dart';

class EasyCarouselController extends CarouselController {}

typedef EasyCarouselAlignment = CarouselAlignment;

class EasyCarouselFractionalConstraint extends CarouselFractionalConstraint {
  const EasyCarouselFractionalConstraint(super.value);
}

class EasyCarouselFixedConstraint extends CarouselFixedConstraint {
  const EasyCarouselFixedConstraint(super.value);
}

class EasyCarouselTransition extends CarouselTransition {
  final CarouselTransition _delegate;

  const EasyCarouselTransition._(this._delegate);

  static EasyCarouselTransition sliding({double gap = 0}) =>
      EasyCarouselTransition._(CarouselTransition.sliding(gap: gap));

  static EasyCarouselTransition fading() =>
      EasyCarouselTransition._(CarouselTransition.fading());

  @override
  List<Widget> layout(
    BuildContext context, {
    required double progress,
    required BoxConstraints constraints,
    required CarouselAlignment alignment,
    required Axis direction,
    required CarouselSizeConstraint sizeConstraint,
    required double progressedIndex,
    required int? itemCount,
    required CarouselItemBuilder itemBuilder,
    required bool wrap,
    required bool reverse,
  }) {
    return _delegate.layout(
      context,
      progress: progress,
      constraints: constraints,
      alignment: alignment,
      direction: direction,
      sizeConstraint: sizeConstraint,
      progressedIndex: progressedIndex,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      wrap: wrap,
      reverse: reverse,
    );
  }
}

class EasyCarousel extends Carousel {
  const EasyCarousel({
    super.key,
    required super.itemBuilder,
    super.itemCount,
    super.controller,
    super.alignment = EasyCarouselAlignment.center,
    super.direction = Axis.horizontal,
    super.wrap = true,
    super.pauseOnHover = true,
    super.autoplaySpeed,
    super.waitOnStart = false,
    super.draggable = true,
    super.reverse = false,
    super.autoplayReverse = false,
    super.sizeConstraint = const EasyCarouselFractionalConstraint(1),
    super.speed = const Duration(milliseconds: 200),
    super.curve = Curves.easeInOut,
    super.duration,
    super.durationBuilder,
    super.onIndexChanged,
    super.disableOverheadScrolling = true,
    super.disableDraggingVelocity = false,
    required super.transition,
  });
}

class EasyCarouselDotIndicator extends StatelessWidget {
  final int itemCount;
  final CarouselController controller;
  final Duration duration;
  final Curve curve;
  final double unselectedRadius;
  final double selectedRadius;

  const EasyCarouselDotIndicator({
    super.key,
    required this.itemCount,
    required this.controller,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.unselectedRadius = 16,
    this.selectedRadius = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 0) return const SizedBox();
    final easyTheme = EasyTheme.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        int currentIndex = controller.value.round() % itemCount;
        if (currentIndex < 0) {
          currentIndex += itemCount;
        }

        return SizedBox(
          height: selectedRadius,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemCount, (index) {
              final isSelected = currentIndex == index;
              final double size =
                  isSelected ? selectedRadius : unselectedRadius;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    controller.animateTo(index.toDouble(), duration, curve);
                  },
                  child: AnimatedContainer(
                    duration: duration,
                    curve: curve,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSelected
                              ? easyTheme.primaryGreen
                              : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF03BF7D)
                                : const Color(0xFF999999),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
