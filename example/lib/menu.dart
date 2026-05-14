// 菜单配置
part of 'main.dart';

// 树状节点结构
class TreeNode {
  final String title;
  final String? routeName;
  final WidgetBuilder? builder;
  final List<TreeNode> children;
  bool isExpanded;

  TreeNode({
    required this.title,
    this.routeName,
    this.builder,
    this.children = const [],
    this.isExpanded = true,
  });

  bool get hasChildren => children.isNotEmpty;

  bool get isLeaf => !hasChildren;
}

final List<TreeNode> treeItems = [
  TreeNode(
    title: '组件总览',
    routeName: '/overview',
    builder: (context) => Overview(),
  ),
  TreeNode(
    title: '基础组件',
    children: [
      TreeNode(
        title: '头像',
        routeName: '/avatar',
        builder: (context) => AvatarDemo(),
      ),
      TreeNode(
        title: '按钮',
        routeName: '/button',
        builder: (context) => const EasyButtonExample(),
      ),
      TreeNode(
        title: '排版',
        routeName: '/typography',
        builder: (context) => TypographyParagraph(),
      ),
      TreeNode(
        title: '图片',
        routeName: '/image',
        builder: (context) => const ImageDemo(),
      ),
      TreeNode(
        title: 'SVG',
        routeName: '/svg',
        builder: (context) => const SvgDemo(),
      ),
      TreeNode(
        title: 'Lottie动画图标',
        routeName: '/lottieIcon',
        builder: (context) => const EasyLottieIconDemo(),
      ),
      TreeNode(
        title: '主题',
        routeName: '/theme',
        builder: (context) => const ThemeDemo(),
      ),
      TreeNode(
        title: 'Segments',
        routeName: '/segments',
        builder: (context) => const SegmentsDemo(),
      ),
      TreeNode(
        title: '开关',
        routeName: '/switch',
        builder: (context) => const SwitchDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '数据展示',
    children: [
      TreeNode(
        title: '表格',
        routeName: '/table',
        builder: (context) => DataTableDemo(),
      ),
      TreeNode(
        title: '轮播图',
        routeName: '/carousel',
        builder: (context) => const CarouselDemo(),
      ),
      TreeNode(
        title: '空占位',
        routeName: '/empty',
        builder: (context) => const EmptyViewDemo(),
      ),
      TreeNode(
        title: '记录卡片',
        routeName: '/recordCard',
        builder: (context) => const RecordCardDemo(),
      ),
      TreeNode(
        title: '骨架屏',
        routeName: '/skeleton',
        builder: (context) => const SkeletonDemo(),
      ),
      TreeNode(
        title: '状态指示器',
        routeName: '/statusIndicator',
        builder: (context) => const StatusIndicatorDemo(),
      ),
      TreeNode(
        title: '信息卡片',
        routeName: '/infoCard',
        builder: (context) => const InfoCardDemo(),
      ),
      TreeNode(
        title: '流程图',
        routeName: '/flow',
        builder: (context) => const EasyFlowDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '数据输入',
    children: [
      TreeNode(
        title: "下拉框",
        children: [
          TreeNode(
            title: '下拉框',
            routeName: '/select',
            builder: (context) => const SelectDemo(),
          ),
          TreeNode(
            title: '分页下拉框',
            routeName: '/paginationSelect',
            builder: (context) => const PaginationSelectDemo(),
          ),
          TreeNode(
            title: '下拉框1',
            routeName: '/dropdownTextfield1',
            builder: (context) => const DropDownDemo1(),
          ),
          TreeNode(
            title: '下拉框2',
            routeName: '/dropdownTextfield2',
            builder: (context) => const DropDownDemo2(),
          ),
        ],
      ),
      TreeNode(
        title: '提示按钮',
        routeName: '/dropdownTextfield3',
        builder: (context) => const ToolTip(),
      ),
      TreeNode(
        title: '表单',
        routeName: '/form',
        builder: (context) => const FormDemo(),
      ),
      TreeNode(
        title: '国际化输入框',
        routeName: '/i18nFormFiled',
        builder: (context) => const I18nFormFiledDemo(),
      ),
      TreeNode(
        title: '时间选择器',
        routeName: '/timePicker',
        builder: (context) => const TimePickerDemo(),
      ),
      TreeNode(
        title: '日期选择器',
        routeName: '/datePicker',
        builder: (context) => const DatePickerDemo(),
      ),
      TreeNode(
        title: '签名板',
        routeName: '/easySignaturePadDemo',
        builder: (context) => const EasySignaturePadExample(),
      ),
      TreeNode(
        title: '滑块',
        routeName: '/slider',
        builder: (context) => const SliderDemo(),
      ),
      TreeNode(
        title: '屏幕键盘',
        routeName: '/onscreenKeyboard',
        builder: (context) => const OnscreenKeyboard(),
      ),
    ],
  ),
  TreeNode(
    title: '反馈组件',
    children: [
      TreeNode(
        title: '对话框',
        routeName: '/dialog',
        builder: (context) => const DialogDemo(),
      ),
      TreeNode(
        title: '气泡框',
        routeName: '/popover',
        builder: (context) => const PopoverDemo(),
      ),
      TreeNode(
        title: '抽屉',
        routeName: '/drawer',
        builder: (context) => const DrawerDemo(),
      ),
      TreeNode(
        title: '轻提示',
        routeName: '/toast',
        builder: (context) => const ToastDemo(),
      ),
      TreeNode(
        title: '本地通知',
        routeName: '/localNotification',
        builder: (context) => const LocalNotificationDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '导航组件',
    children: [
      TreeNode(
        title: '步骤指示器',
        routeName: '/stepperIndicator',
        builder: (context) => const StepIndicatorDemo(),
      ),
      TreeNode(
        title: '步骤条',
        routeName: '/stepper',
        builder: (context) => const EasyStepperDemo(),
      ),
      TreeNode(
        title: '标签页',
        routeName: '/tabs',
        builder: (context) => const TabsDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '布局',
    children: [
      TreeNode(
        title: '多章节滚动布局',
        routeName: '/scrollSectionsLayout',
        builder: (context) => const EasyScrollSectionsLayoutDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '分页',
    children: [
      TreeNode(
        title: '分页组件',
        routeName: '/easyPagination',
        builder: (context) => EasyPaginationExample(),
      ),
    ],
  ),
  TreeNode(
    title: '富文本',
    children: [
      TreeNode(
        title: '富文本编辑器',
        routeName: '/richEditor',
        builder: (context) => const EasyRichEditorDemo(),
      ),
      TreeNode(
        title: 'Markdown查看器',
        routeName: '/markdownViewer',
        builder: (context) => const EasyMarkdownDemo(),
      ),
      TreeNode(
        title: 'PDF查看器',
        routeName: '/pdfViewer',
        builder: (context) => const EasyPdfViewerDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '进度指示',
    children: [
      TreeNode(
        title: '线性进度条',
        routeName: '/linearProgress',
        builder: (context) => const LinearProgressDemo(),
      ),
      TreeNode(
        title: '环形刻度仪表',
        routeName: '/radialProgress',
        builder: (context) => const EasyRadialProgressIndicatorDemo(),
      ),
      TreeNode(
        title: '跑马灯渐变条',
        routeName: '/marqueeGradient',
        builder: (context) => const GradientBarDemo(),
      ),
    ],
  ),
  TreeNode(
    title: '其他组件',
    children: [
      TreeNode(
        title: '拖拽或上传文件按钮',
        routeName: '/fileDragArea',
        builder: (context) => const EasyFileDragAreaDemo(),
      ),
      TreeNode(
        title: '颜色选择面板',
        routeName: '/colorPicker',
        builder: (context) => const EasyColorPickerDemo(),
      ),
      TreeNode(
        title: '长按复制',
        routeName: '/longPressCopyable',
        builder: (context) => const LongPressCopyableDemo(),
      ),
      TreeNode(
        title: 'H5 反向代理',
        routeName: '/h5Proxy',
        builder: (context) => const H5ProxyDemo(),
      ),
    ],
  ),
];
