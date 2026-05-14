import 'dart:math' as math;

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class EasyPagination extends StatelessWidget {
  const EasyPagination({
    super.key,
    required this.pageSize,
    required this.total,
    required this.currentPage,
    required this.onPageChanged,
    this.loadingData = false,
    this.totalTextStyle = const TextStyle(
      color: Color(0xFF666666),
      fontSize: 12,
    ),
    this.pageSizeList = const [10, 20, 50, 100],
    this.onPageSizeChanged,
    this.defaultFontSize = 12.0,
  });

  /// 每页大小
  final int pageSize;

  /// 总数
  final int total;

  /// 当前页码
  final int currentPage;

  /// 页码改变回调
  final Function(int) onPageChanged;

  /// 总数文本样式
  final TextStyle totalTextStyle;

  /// 是否正在加载数据
  final bool loadingData;

  /// 每页大小列表
  final List<int> pageSizeList;

  /// 每页大小改变回调
  final ValueChanged<int>? onPageSizeChanged;

  /// 默认字体大小
  final double defaultFontSize;

  /// 每页大小菜单控制器
  // final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final localizations = EasyUiLocalizations.of(context);
    final int totalPages = (total / pageSize).ceil();
    final List<Widget> pageButtons = [];

    if (totalPages == 0) {
      pageButtons.add(_buildPageNumber(context, 1, true));
    } else if (totalPages <= 5) {
      // If total pages are 5 or less, display all page numbers directly
      for (int i = 1; i <= totalPages; i++) {
        pageButtons.add(_buildPageNumber(context, i, currentPage == i));
      }
    } else {
      // Always add the first page
      pageButtons.add(_buildPageNumber(context, 1, currentPage == 1));

      // Determine the pages to show in the middle based on currentPage
      Set<int> middlePages = {};
      if (currentPage <= 3) {
        // If currentPage is 1, 2, or 3, show 2, 3, 4, 5
        for (int i = 2; i <= 5 && i <= totalPages; i++) {
          middlePages.add(i);
        }
      } else if (currentPage >= totalPages - 2) {
        // If currentPage is totalPages, totalPages-1, or totalPages-2, show totalPages-4, totalPages-3, totalPages-2, totalPages-1
        for (int i = totalPages - 4; i <= totalPages - 1 && i >= 1; i++) {
          middlePages.add(i);
        }
      } else {
        // General case: currentPage is in the middle, show currentPage-1, currentPage, currentPage+1
        middlePages.add(currentPage - 1);
        middlePages.add(currentPage);
        middlePages.add(currentPage + 1);
      }

      // Add leading ellipsis if needed
      // Check if the smallest middle page is greater than 2 (meaning there's a gap between 1 and the middle block)
      if (middlePages.isNotEmpty && middlePages.reduce(math.min) > 2) {
        pageButtons.add(
          _buildEllipsis(() {
            int jumpToPage = math.max(1, currentPage - 4);
            onPageChanged(jumpToPage);
          }),
        );
      }

      // Add middle pages to the list
      List<int> sortedMiddlePages = middlePages.toList()..sort();
      for (int pageNum in sortedMiddlePages) {
        if (pageNum != 1 && pageNum != totalPages) {
          // Avoid duplicating 1 or totalPages
          pageButtons.add(
            _buildPageNumber(context, pageNum, currentPage == pageNum),
          );
        }
      }

      // Add trailing ellipsis if needed
      // Check if the largest middle page is less than totalPages - 1 (meaning there's a gap between middle block and totalPages)
      if (middlePages.isNotEmpty &&
          middlePages.reduce(math.max) < totalPages - 1) {
        pageButtons.add(
          _buildEllipsis(() {
            int jumpToPage = math.min(totalPages, currentPage + 4);
            onPageChanged(jumpToPage);
          }),
        );
      }

      // Always add the last page, unless it's the same as the first page (totalPages == 1)
      if (totalPages > 1) {
        pageButtons.add(
          _buildPageNumber(context, totalPages, currentPage == totalPages),
        );
      }
    }

    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              localizations.totalRecords(total),
              style: totalTextStyle,
            ),
          ),
          // 分页组件
          Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 上一页
                  InkWell(
                    onTap:
                        currentPage > 1 && !loadingData
                            ? () {
                              onPageChanged(currentPage - 1);
                            }
                            : null,
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color:
                            currentPage > 1 && !loadingData
                                ? const Color(0xFF8D8C8D)
                                : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  // 页码部分
                  ...pageButtons,
                  // 下一页
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap:
                        currentPage * pageSize < total && !loadingData
                            ? () {
                              onPageChanged(currentPage + 1);
                            }
                            : null,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color:
                            currentPage * pageSize < total && !loadingData
                                ? const Color(0xFF8D8C8D)
                                : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (pageSizeList.isNotEmpty && menuController != null)
          if (pageSizeList.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: EasyMenuAnchor(
                style: EasyMenuStyle(
                  boxShadows: [],
                  boxBorder: Border.all(color: easyTheme.neutralEE),
                ),
                childBuilder: (context, menuController, _) {
                  return InkWell(
                    onTap:
                        loadingData
                            ? null
                            : () {
                              if (menuController.isOpen) {
                                menuController.close();
                              } else {
                                menuController.open();
                              }
                            },
                    child: Container(
                      height: 46,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(easyTheme.cornerSmall),
                        border: Border.all(color: easyTheme.neutralEE),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              localizations.itemsPerPage(pageSize),
                              style: TextStyle(
                                fontSize: defaultFontSize,
                                color: easyTheme.neutral66,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          menuController.isOpen
                              ? Icon(
                                Icons.keyboard_arrow_up,
                                color: easyTheme.neutral66,
                                size: 16,
                              )
                              : Icon(
                                Icons.keyboard_arrow_down,
                                color: easyTheme.neutral66,
                                size: 16,
                              ),
                        ],
                      ),
                    ),
                  );
                },
                menuBuilder: (context, menuController, overlayInfo) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: overlayInfo.anchorRect.width,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final e = pageSizeList[index];
                        return ListTile(
                          onTap:
                              loadingData || pageSize == e
                                  ? null
                                  : () {
                                    menuController.close();
                                    onPageSizeChanged?.call(e);
                                  },
                          tileColor: pageSize == e ? easyTheme.neutralEE : null,
                          title: Text(
                            localizations.itemsPerPage(e),
                            style: TextStyle(
                              fontSize: defaultFontSize,
                              color: easyTheme.neutral66,
                            ),
                          ),
                        );
                      },
                      itemCount: pageSizeList.length,
                    ),
                  );
                },
              ),
              // child: MenuAnchor(
              //   controller: menuController,
              //   style: MenuStyle(
              //     backgroundColor: WidgetStatePropertyAll(Colors.white),
              //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(4),
              //       side: BorderSide(color: Color(0xFFEEEEEE)),
              //     )),
              //     elevation: WidgetStatePropertyAll(0),
              //   ),
              //   alignmentOffset: Offset(0, 10),
              //   builder: (context, controller, child) {
              //     return InkWell(
              //       onTap: loadingData
              //           ? null
              //           : () {
              //               if (controller.isOpen) {
              //                 controller.close();
              //               } else {
              //                 controller.open();
              //               }
              //             },
              //       child: Container(
              //         height: 46,
              //         padding: EdgeInsets.symmetric(horizontal: 16),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(4),
              //           border: Border.all(color: Color(0xFFEEEEEE)),
              //         ),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Flexible(
              //               child: Text(
              //                 localizations.itemsPerPage(pageSize),
              //                 style: TextStyle(
              //                     fontSize: 12, color: Color(0xff666666)),
              //               ),
              //             ),
              //             const SizedBox(width: 8),
              //             controller.isOpen
              //                 ? Icon(
              //                     Icons.keyboard_arrow_up,
              //                     color: Color(0xff666666),
              //                     size: 16,
              //                   )
              //                 : Icon(
              //                     Icons.keyboard_arrow_down,
              //                     color: Color(0xff666666),
              //                     size: 16,
              //                   ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              //   menuChildren: pageSizeList
              //       .map((e) => SizedBox(
              //             width: 102,
              //             child: ListTile(
              //               onTap: loadingData || pageSize == e
              //                   ? null
              //                   : () {
              //                       onPageSizeChanged?.call(e);
              //                       menuController?.close();
              //                     },
              //               tileColor: pageSize == e ? Color(0xFFEEEEEE) : null,
              //               title: Text(
              //                 localizations.itemsPerPage(e),
              //                 style: const TextStyle(
              //                     fontSize: 12, color: Color(0xff666666)),
              //               ),
              //             ),
              //           ))
              //       .toList(),
              // ),
            ),
        ],
      ),
    );
  }

  // 页码按钮
  Widget _buildPageNumber(
    BuildContext context,
    int pageNumber,
    bool isCurrentPage,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap:
          loadingData
              ? null
              : () {
                if (!isCurrentPage) {
                  onPageChanged(pageNumber);
                }
              },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color:
              isCurrentPage
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            '$pageNumber',
            style:
                isCurrentPage
                    ? TextStyle(fontSize: defaultFontSize, color: Colors.white)
                    : TextStyle(
                      fontSize: defaultFontSize,
                      color: EasyTheme.of(context).neutral66,
                    ),
          ),
        ),
      ),
    );
  }

  // 省略号按钮
  Widget _buildEllipsis(VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: loadingData ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: const Center(
          child: Text(
            '...',
            style: TextStyle(fontSize: 14, color: Color(0xFF696969)),
          ),
        ),
      ),
    );
  }
}
