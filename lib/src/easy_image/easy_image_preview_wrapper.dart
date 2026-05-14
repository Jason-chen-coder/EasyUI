import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../easy_button/easy_button.dart';
import '../easy_button/easy_button_style.dart';
import 'easy_image_tool.dart';

class EasyImagePreviewWrapper extends StatefulWidget {
  final List<String> galleryItems;
  final int initialIndex;

  const EasyImagePreviewWrapper({
    super.key,
    required this.galleryItems,
    required this.initialIndex,
  });

  @override
  State<EasyImagePreviewWrapper> createState() =>
      _EasyImagePreviewWrapperState();
}

class _EasyImagePreviewWrapperState extends State<EasyImagePreviewWrapper> {
  late PageController _pageController;
  late int _currentIndex;
  final Map<int, PhotoViewController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  PhotoViewController _getController(int index) {
    if (!_controllers.containsKey(index)) {
      _controllers[index] = PhotoViewController();
    }
    return _controllers[index]!;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final controller = _getController(_currentIndex);
      double currentScale = controller.scale ?? 1.0;
      double nextScale = currentScale - (event.scrollDelta.dy * 0.001);
      if (nextScale < 0.1) nextScale = 0.1;
      if (nextScale > 5.0) nextScale = 5.0;
      controller.scale = nextScale;
    }
  }

  void _jumpToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 遍历现有的控制器进行清理和重置
    final List<int> activeKeys = List.from(_controllers.keys);

    for (var key in activeKeys) {
      // 1. 如果是当前页，保持不动
      if (key == index) continue;

      final controller = _controllers[key];
      if (controller != null) {
        // 将值重置为初始状态：位置归零，缩放归一，旋转归零
        controller.value = const PhotoViewControllerValue(
          position: Offset.zero,
          scale: 0.0,
          rotation: 0.0,
          rotationFocusPoint: null,
        );
      }
    }
  }

  ImageProvider _getImageProvider(String src) {
    if (src.isNetwork) {
      return CachedNetworkImageProvider(src);
    } else if (src.isAsset) {
      return AssetImage(src);
    } else {
      return FileImage(File(src.normalizeFilePath));
    }
  }

  /// 只有桌面端才展示操作按钮
  bool get showAction =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  Widget build(BuildContext context) {
    final int totalCount = widget.galleryItems.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片层
          Listener(
            onPointerSignal: _onPointerSignal,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: _getImageProvider(widget.galleryItems[index]),
                  controller: _getController(index),
                  heroAttributes: PhotoViewHeroAttributes(
                    tag:
                        'easy_image_hero_${index}_${widget.galleryItems[index]}',
                  ),
                  errorBuilder:
                      (_, __, ___) => Center(
                        child: Image.asset(
                          'assets/images/error_img.png',
                          package: 'easy_ui',
                          fit: BoxFit.contain,
                        ),
                      ),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                );
              },
              itemCount: totalCount,
              pageController: _pageController,
              onPageChanged: _onPageChanged,
            ),
          ),

          // 顶部操作栏
          Positioned(
            top: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                spacing: 10,
                children: [
                  // if (showAction)
                  //   EasyButton2(
                  //     type: EasyButtonType.iconDefault,
                  //     size: EasyButtonSize.big,
                  //     style: EasyButtonStyle.styleFrom(
                  //       backgroundColor: Colors.black.withValues(alpha: 0.5),
                  //       foregroundColor: Colors.white,
                  //       iconSize: 24,
                  //       padding: EdgeInsets.all(8),
                  //       shape: CircleBorder(),
                  //     ),
                  //     child: Icon(Icons.rotate_right),
                  //     onPressed: () {
                  //       final controller = _getController(_currentIndex);
                  //       controller.rotation = controller.rotation + 1.5708;
                  //     },
                  //   ),
                  EasyButton2(
                    type: EasyButtonType.iconDefault,
                    size: EasyButtonSize.big,
                    style: EasyButtonStyle.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      foregroundColor: Colors.white,
                      iconSize: 24,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                    child: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_currentIndex + 1} / $totalCount",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),

          // 左侧切换按钮 (仅当不是第一张时显示)
          if (_currentIndex > 0 && showAction)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: EasyButton2(
                  type: EasyButtonType.iconDefault,
                  size: EasyButtonSize.big,
                  style: EasyButtonStyle.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    foregroundColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.arrow_back_ios_new),
                  onPressed: () => _jumpToPage(_currentIndex - 1),
                ),
              ),
            ),

          // 右侧切换按钮 (仅当不是最后一张时显示)
          if (_currentIndex < totalCount - 1 && showAction)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: EasyButton2(
                  type: EasyButtonType.iconDefault,
                  size: EasyButtonSize.big,
                  style: EasyButtonStyle.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    foregroundColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () => _jumpToPage(_currentIndex + 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
