import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class EasyPdfViewer extends StatefulWidget {
  const EasyPdfViewer({super.key, required this.uri});

  final Uri uri;

  @override
  State<EasyPdfViewer> createState() => _EasyPdfViewerState();
}

class _EasyPdfViewerState extends State<EasyPdfViewer> {
  final _controller = PdfViewerController();

  // 定义每次点击放大的倍率，1.2表示每次放大/缩小 20%
  final double _zoomFactor = 1.2;

  @override
  Widget build(BuildContext context) {
    return PdfViewer.uri(
      widget.uri,
      controller: _controller,
      params: PdfViewerParams(
        backgroundColor: Colors.white,
        calculateInitialZoom: (document, controller, fitZoom, coverZoom) {
          return fitZoom;
        },
        loadingBannerBuilder: (context, downloaded, total) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBannerBuilder: (context, e, s, ref) {
          return EasyEmptyView(text: e.toString());
        },
        viewerOverlayBuilder: (context, size, handleLinkTap) {
          final l10n = EasyUiLocalizations.of(context);
          return [
            PdfViewerScrollThumb(
              controller: _controller, // 绑定同一个 controller
              orientation: ScrollbarOrientation.right, // 靠右放置
              thumbSize: const Size(40, 25), // 定义滑块(Thumb)的长宽尺寸
              // 4. 自定义滑块的外观
              thumbBuilder: (context, thumbSize, pageNumber, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  // 可以在滑块上直接显示当前的页码（pageNumber）
                  child: Text(
                    '$pageNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            // --- 左下角：缩放按钮组 ---
            Positioned(
              left: 16,
              bottom: 16,
              child: Card(
                color: Colors.black87,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // 使用 Row 将按钮横向排列
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 缩小按钮
                    IconButton(
                      icon: const Icon(Icons.zoom_out, color: Colors.white),
                      tooltip: l10n.actionZoomDown,
                      onPressed: () {
                        // 获取当前缩放比例，除以倍率实现缩小
                        final currentZoom = _controller.currentZoom;

                        _controller.setZoom(
                          _controller.centerPosition,
                          currentZoom / _zoomFactor,
                        );
                      },
                    ),

                    // 分割线 (可选，增加视觉精致度)
                    Container(width: 1, height: 20, color: Colors.white38),

                    // 重置/自适应按钮 (一键恢复默认大小，提升桌面端体验)
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      tooltip: l10n.actionZoomFit,
                      onPressed: () {
                        // 注意：这里需要重新触发引擎内部计算，或者粗略设为默认值。
                        // 由于初始我们用了 coverZoom，这里简单将视图复位（双击组件本身也有类似效果）
                        _controller.setZoom(_controller.centerPosition, 1.0);
                      },
                    ),

                    Container(width: 1, height: 20, color: Colors.white38),

                    // 放大按钮
                    IconButton(
                      icon: const Icon(Icons.zoom_in, color: Colors.white),
                      tooltip: l10n.actionZoomUp,
                      onPressed: () {
                        // 获取当前缩放比例，乘以倍率实现放大
                        final currentZoom = _controller.currentZoom;
                        _controller.setZoom(
                          _controller.centerPosition,
                          currentZoom * _zoomFactor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 右下角“回到顶部”按钮
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, _) {
                final pageNum = _controller.pageNumber;
                if (pageNum != null && pageNum > 1) {
                  return Positioned(
                    right: 60, // 距离右边多一点，避免挡住右侧滚动条
                    bottom: 16,
                    child: FloatingActionButton(
                      tooltip: l10n.actionBackToTop,
                      mini: true,
                      // 使用迷你尺寸，避免太突兀
                      backgroundColor: Colors.black87,
                      child: const Icon(
                        Icons.vertical_align_top,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // pdfrx 的页码是从 1 开始计数的
                        _controller.goToPage(pageNumber: 1);
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ];
        },
      ),
    );
  }
}
