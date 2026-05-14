import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class EasyLandingPage extends StatelessWidget {
  const EasyLandingPage({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  static const _maxWidth = 1180.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = _LandingPalette.resolve(isDark);

    return Scaffold(
      backgroundColor: palette.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroSection(palette: palette, onNavigate: onNavigate),
          ),
          SliverToBoxAdapter(
            child: _ConstrainedSection(
              top: 34,
              bottom: 28,
              child: _FeatureSection(palette: palette),
            ),
          ),
          SliverToBoxAdapter(
            child: _ConstrainedSection(
              top: 20,
              bottom: 34,
              child: _ComponentPreviewSection(
                palette: palette,
                onNavigate: onNavigate,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _ConstrainedSection(
              top: 20,
              bottom: 64,
              child: _ResourceSection(palette: palette, onNavigate: onNavigate),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.heroBackground),
      child: _ConstrainedSection(
        top: 78,
        bottom: 72,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 850;
            final intro = _HeroIntro(palette: palette, onNavigate: onNavigate);
            final visual = _HeroVisual(
              palette: palette,
              onNavigate: onNavigate,
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 36), visual],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 12, child: intro),
                const SizedBox(width: 44),
                Expanded(flex: 10, child: visual),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EasyStatusIndicator.green(
              text: 'Flutter package',
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            EasyStatusIndicator.blue(
              text: 'Web ready',
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          'Easy UI Design',
          style: theme.textTheme.displayMedium?.copyWith(
            color: palette.textStrong,
            fontSize: 52,
            height: 1.04,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Flutter 全平台应用的组件工作台',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: palette.textStrong,
            fontSize: 24,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            '从按钮、表单、数据展示到富文本和 H5 容器，Easy UI 将迁移后的组件集中成一个可浏览、可验证、可复制的 Flutter UI kit。',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: palette.textMuted,
              height: 1.75,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate('/overview'),
              icon: const Icon(Icons.widgets_outlined, size: 18),
              label: const Text('浏览组件'),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => onNavigate('/button'),
              icon: const Icon(Icons.touch_app_outlined, size: 18),
              label: const Text('查看按钮示例'),
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textStrong,
                side: BorderSide(color: palette.borderStrong),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _PreviewItem('按钮', Icons.smart_button_outlined, palette.blue, '/button'),
      _PreviewItem('表格', Icons.table_chart_outlined, palette.green, '/table'),
      _PreviewItem('流程图', Icons.account_tree_outlined, palette.amber, '/flow'),
      _PreviewItem('富文本', Icons.edit_note_outlined, palette.red, '/richEditor'),
    ];

    return SizedBox(
      height: 382,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 26,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _WindowDot(color: palette.red),
                const SizedBox(width: 6),
                _WindowDot(color: palette.amber),
                const SizedBox(width: 6),
                _WindowDot(color: palette.green),
                const Spacer(),
                Text(
                  'easy_ui/example',
                  style: TextStyle(color: palette.textSoft, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: cards.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.22,
                ),
                itemBuilder: (context, index) {
                  final item = cards[index];
                  return _PreviewTile(
                    item: item,
                    palette: palette,
                    onNavigate: onNavigate,
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            _CodeStrip(palette: palette),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatureData(
        icon: Icons.devices_other,
        color: palette.blue,
        title: '全平台视图构建',
        description: '覆盖 Web、桌面和移动端，示例工程直接验证组件在 Flutter 多端下的表现。',
      ),
      _FeatureData(
        icon: Icons.inventory_2_outlined,
        color: palette.green,
        title: '组件集中迁移',
        description: '统一以 Easy 命名导出，保留原组件能力，同时清理包名、资源路径和示例入口。',
      ),
      _FeatureData(
        icon: Icons.tune,
        color: palette.amber,
        title: '可调主题系统',
        description: '跟随 EasyTheme 与 Material Theme，示例内可切换亮色、暗色和语言环境。',
      ),
      _FeatureData(
        icon: Icons.web_asset_outlined,
        color: palette.red,
        title: 'Web 首屏友好',
        description: '借鉴 TolyUI 的原生 splash 思路，在 Flutter 首帧之前给 Web 用户明确反馈。',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          eyebrow: 'CAPABILITIES',
          title: '为真实项目准备的组件层',
          description: 'Landing page 不是单独的宣传页，它会直接带你进入可运行的组件示例。',
          palette: palette,
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 760 ? 1 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 154,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemBuilder:
                  (context, index) =>
                      _FeatureCard(data: items[index], palette: palette),
            );
          },
        ),
      ],
    );
  }
}

class _ComponentPreviewSection extends StatelessWidget {
  const _ComponentPreviewSection({
    required this.palette,
    required this.onNavigate,
  });

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final left = _SectionHeader(
          eyebrow: 'COMPONENT MAP',
          title: '从总览进入，再深入到每个组件',
          description:
              'Easy UI example 保留了组件库工作台的密度：左侧导航负责快速定位，右侧页面承载完整 API、用法和边界状态。',
          palette: palette,
        );
        final right = _CategoryRail(palette: palette, onNavigate: onNavigate);

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 22), right],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 8, child: left),
            const SizedBox(width: 34),
            Expanded(flex: 9, child: right),
          ],
        );
      },
    );
  }
}

class _ResourceSection extends StatelessWidget {
  const _ResourceSection({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        color: palette.footer,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 18,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready for Easy UI',
                  style: TextStyle(
                    color: palette.textStrong,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '继续使用左侧导航查看组件细节，或从总览页扫描完整组件矩阵。',
                  style: TextStyle(color: palette.textMuted, height: 1.6),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _TextLinkButton(
                text: '组件总览',
                icon: Icons.dashboard_customize_outlined,
                route: '/overview',
                palette: palette,
                onNavigate: onNavigate,
              ),
              _TextLinkButton(
                text: '主题',
                icon: Icons.palette_outlined,
                route: '/theme',
                palette: palette,
                onNavigate: onNavigate,
              ),
              _TextLinkButton(
                text: '富文本',
                icon: Icons.edit_note_outlined,
                route: '/richEditor',
                palette: palette,
                onNavigate: onNavigate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConstrainedSection extends StatelessWidget {
  const _ConstrainedSection({
    required this.child,
    this.top = 0,
    this.bottom = 0,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 720 ? 22.0 : 40.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: EasyLandingPage._maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.palette,
  });

  final String eyebrow;
  final String title;
  final String description;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: theme.textTheme.labelMedium?.copyWith(
            color: palette.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: palette.textStrong,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: palette.textMuted,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.data, required this.palette});

  final _FeatureData data;
  final _LandingPalette palette;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(
            color: _hovered ? widget.data.color : palette.border,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              _hovered
                  ? [
                    BoxShadow(
                      color: palette.shadow,
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: widget.data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.data.icon, color: widget.data.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.title,
                    style: TextStyle(
                      color: palette.textStrong,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.data.description,
                    style: TextStyle(
                      color: palette.textMuted,
                      height: 1.55,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.palette, required this.onNavigate});

  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final categories = [
      const _CategoryData('基础组件', '头像、按钮、排版、图片、SVG、主题', '/overview'),
      const _CategoryData('数据展示', '表格、轮播图、空占位、流程图', '/table'),
      const _CategoryData('数据输入', '表单、选择器、日期时间、签名板', '/form'),
      const _CategoryData(
        '反馈与富文本',
        'Dialog、Toast、Popover、Rich Editor',
        '/toast',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children:
            categories.indexed.map((entry) {
              final index = entry.$1;
              final data = entry.$2;
              return _CategoryRow(
                data: data,
                index: index,
                palette: palette,
                onNavigate: onNavigate,
                showDivider: index != categories.length - 1,
              );
            }).toList(),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.data,
    required this.index,
    required this.palette,
    required this.onNavigate,
    required this.showDivider,
  });

  final _CategoryData data;
  final int index;
  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = [palette.blue, palette.green, palette.amber, palette.red];
    return InkWell(
      onTap: () => onNavigate(data.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border:
              showDivider
                  ? Border(bottom: BorderSide(color: palette.border))
                  : null,
        ),
        child: Row(
          children: [
            Text(
              '0${index + 1}',
              style: TextStyle(
                color: colors[index],
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      color: palette.textStrong,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.description,
                    style: TextStyle(color: palette.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 18, color: palette.textSoft),
          ],
        ),
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.item,
    required this.palette,
    required this.onNavigate,
  });

  final _PreviewItem item;
  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onNavigate(item.route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.previewBackground,
          border: Border.all(color: palette.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: TextStyle(
                color: palette.textStrong,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: item.color.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(item.icon, color: item.color, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeStrip extends StatelessWidget {
  const _CodeStrip({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.codeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "import 'package:easy_ui/easy_ui.dart';",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: palette.codeText,
          fontSize: 13,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({
    required this.text,
    required this.icon,
    required this.route,
    required this.palette,
    required this.onNavigate,
  });

  final String text;
  final IconData icon;
  final String route;
  final _LandingPalette palette;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => onNavigate(route),
      icon: Icon(icon, size: 17),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.textStrong,
        side: BorderSide(color: palette.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}

class _CategoryData {
  const _CategoryData(this.title, this.description, this.route);

  final String title;
  final String description;
  final String route;
}

class _PreviewItem {
  const _PreviewItem(this.label, this.icon, this.color, this.route);

  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _LandingPalette {
  const _LandingPalette({
    required this.background,
    required this.heroBackground,
    required this.surface,
    required this.footer,
    required this.previewBackground,
    required this.codeBackground,
    required this.textStrong,
    required this.textMuted,
    required this.textSoft,
    required this.codeText,
    required this.primary,
    required this.onPrimary,
    required this.border,
    required this.borderStrong,
    required this.shadow,
    required this.blue,
    required this.green,
    required this.amber,
    required this.red,
  });

  final Color background;
  final Color heroBackground;
  final Color surface;
  final Color footer;
  final Color previewBackground;
  final Color codeBackground;
  final Color textStrong;
  final Color textMuted;
  final Color textSoft;
  final Color codeText;
  final Color primary;
  final Color onPrimary;
  final Color border;
  final Color borderStrong;
  final Color shadow;
  final Color blue;
  final Color green;
  final Color amber;
  final Color red;

  static _LandingPalette resolve(bool isDark) {
    if (isDark) {
      return const _LandingPalette(
        background: Color(0xFF101820),
        heroBackground: Color(0xFF111C25),
        surface: Color(0xFF17232E),
        footer: Color(0xFF15212B),
        previewBackground: Color(0xFF111B24),
        codeBackground: Color(0xFF0B1219),
        textStrong: Color(0xFFE9F3F1),
        textMuted: Color(0xFFAAB8B9),
        textSoft: Color(0xFF75868A),
        codeText: Color(0xFF9DE7CB),
        primary: Color(0xFF31DA9F),
        onPrimary: Color(0xFF072016),
        border: Color(0xFF263744),
        borderStrong: Color(0xFF3C5262),
        shadow: Color(0x66060B10),
        blue: Color(0xFF58A6FF),
        green: Color(0xFF31DA9F),
        amber: Color(0xFFF4BE59),
        red: Color(0xFFFF7474),
      );
    }
    return const _LandingPalette(
      background: Color(0xFFF7FAFC),
      heroBackground: Color(0xFFFBFDFE),
      surface: Color(0xFFFFFFFF),
      footer: Color(0xFFF1F6F7),
      previewBackground: Color(0xFFF8FBFC),
      codeBackground: Color(0xFF13202F),
      textStrong: Color(0xFF13202F),
      textMuted: Color(0xFF5E6B72),
      textSoft: Color(0xFF8A989E),
      codeText: Color(0xFFC7F7E7),
      primary: Color(0xFF17A779),
      onPrimary: Color(0xFFFFFFFF),
      border: Color(0xFFE0E8EC),
      borderStrong: Color(0xFFB7C7CD),
      shadow: Color(0x1A13202F),
      blue: Color(0xFF1484FC),
      green: Color(0xFF17A779),
      amber: Color(0xFFD8941A),
      red: Color(0xFFE45D5D),
    );
  }
}
