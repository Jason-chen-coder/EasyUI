import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

// 提供一个路径 Lottie.asset(package: 'easy_ui','assets/animations/device_running.json')
// 'assets/animations/device_running.json' -> EasyLottieIcon.deviceRunning
// 'assets/animations/loading_black.json' -> EasyLottieIcon.loadingBlack
// 'assets/animations/loading_white.json' -> EasyLottieIcon.loadingWhite

// 搞一个枚举 enum 映射路径
enum EasyLottieIconType {
  defaultType,
  deviceRunning,
  loadingBlack,
  loadingWhite,
}

extension EasyLottieIconExtension on EasyLottieIconType {
  String get path {
    return switch (this) {
      EasyLottieIconType.deviceRunning =>
        'assets/animations/device_running.json',
      EasyLottieIconType.loadingBlack => 'assets/animations/loading_black.json',
      EasyLottieIconType.loadingWhite => 'assets/animations/loading_white.json',
      EasyLottieIconType.defaultType => 'assets/animations/default.json',
    };
  }
}

class EasyLottieIcon extends StatelessWidget {
  const EasyLottieIcon({
    super.key,
    this.type = EasyLottieIconType.defaultType,
    this.path,
    this.package = 'easy_ui',
    this.width,
    this.height,
    this.fit,
  });

  final EasyLottieIconType type;
  final String? path;
  final String package;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final assetPath = path ?? type.path;
    return Lottie.asset(
      assetPath,
      package: package,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
