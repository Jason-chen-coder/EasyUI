import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _easyUiRepoUrl = 'https://github.com/Jason-chen-coder/EasyUI';
const _easyUiPreviewUrl = 'https://jason-chen-coder.github.io/EasyUI/';
const _githubProfileUrl = 'https://github.com/Jason-chen-coder';
const _sponsorEmail = 'hongxin.jasonchen@gmail.com';

Future<void> _launchExternal(
  Uri uri, {
  String webOnlyWindowName = '_blank',
}) async {
  final launched = await launchUrl(
    uri,
    mode: LaunchMode.platformDefault,
    webOnlyWindowName: webOnlyWindowName,
  );

  if (!launched) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _LandingTypography {
  const _LandingTypography._();

  static TextStyle heroTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 52,
      height: 1.04,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  static TextStyle heroSubtitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 24,
      height: 1.32,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }

  static TextStyle sectionTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 28,
      height: 1.24,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  static TextStyle sectionEyebrow(_LandingPalette palette) {
    return TextStyle(
      color: palette.primary,
      fontSize: 13,
      height: 1.3,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
    );
  }

  static TextStyle contentTitle(_LandingPalette palette) {
    return TextStyle(
      color: palette.textStrong,
      fontSize: 18,
      height: 1.35,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  static TextStyle body(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 16,
      height: 1.7,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );
  }

  static TextStyle bodySmall(_LandingPalette palette) {
    return TextStyle(
      color: palette.textSoft,
      fontSize: 14,
      height: 1.65,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }

  static TextStyle link(_LandingPalette palette) {
    return TextStyle(
      color: palette.textMuted,
      fontSize: 17,
      height: 1.35,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }

  static TextStyle linkStrong(_LandingPalette palette) {
    return link(
      palette,
    ).copyWith(color: palette.blue, fontWeight: FontWeight.w800);
  }
}

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
              child: _ResourceSection(palette: palette),
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
            final visual = _HeroVisual(palette: palette);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Easy UI Design', style: _LandingTypography.heroTitle(palette)),
        const SizedBox(height: 14),
        Text(
          'Flutter 全平台应用的组件工作台',
          style: _LandingTypography.heroSubtitle(palette),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            '从按钮、表单、数据展示到富文本和 H5 容器，Easy UI 将迁移后的组件集中成一个可浏览、可验证、可复制的 Flutter UI kit。',
            style: _LandingTypography.body(palette),
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
  const _HeroVisual({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _LogoShowcase(palette: palette)),
          ],
        ),
      ),
    );
  }
}

class _LogoShowcase extends StatefulWidget {
  const _LogoShowcase({required this.palette});

  final _LandingPalette palette;

  @override
  State<_LogoShowcase> createState() => _LogoShowcaseState();
}

class _LogoShowcaseState extends State<_LogoShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      return _buildStage(context, 0);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _buildStage(context, _controller.value),
    );
  }

  Widget _buildStage(BuildContext context, double progress) {
    final palette = widget.palette;
    final phase = progress * math.pi * 2;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.previewBackground,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _LogoOrbitPainter(palette: palette, progress: progress),
            ),
          ),
          Positioned(
            width: 286,
            height: 286,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.primary.withValues(alpha: 0.18),
                    palette.blue.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final shortest = math.min(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              final logoSize = shortest.clamp(138.0, 188.0).toDouble();
              final badgeSize = shortest < 250 ? 38.0 : 46.0;
              final logoScale = 1 + math.sin(phase) * 0.018;

              return Stack(
                alignment: Alignment.center,
                children: [
                  _OrbitBadge(
                    alignment: const Alignment(-0.72, -0.68),
                    progress: progress,
                    delay: 0,
                    size: badgeSize,
                    icon: Icons.smart_button_outlined,
                    color: palette.blue,
                    palette: palette,
                  ),
                  _OrbitBadge(
                    alignment: const Alignment(0.72, -0.56),
                    progress: progress,
                    delay: 0.22,
                    size: badgeSize,
                    icon: Icons.table_chart_outlined,
                    color: palette.green,
                    palette: palette,
                  ),
                  _OrbitBadge(
                    alignment: const Alignment(-0.68, 0.64),
                    progress: progress,
                    delay: 0.48,
                    size: badgeSize,
                    icon: Icons.tune,
                    color: palette.amber,
                    palette: palette,
                  ),
                  _OrbitBadge(
                    alignment: const Alignment(0.67, 0.66),
                    progress: progress,
                    delay: 0.72,
                    size: badgeSize,
                    icon: Icons.edit_note_outlined,
                    color: palette.red,
                    palette: palette,
                  ),
                  _SparkDot(
                    alignment: const Alignment(-0.18, -0.86),
                    progress: progress,
                    delay: 0.1,
                    color: palette.primary,
                  ),
                  _SparkDot(
                    alignment: const Alignment(0.22, 0.86),
                    progress: progress,
                    delay: 0.55,
                    color: palette.blue,
                  ),
                  Transform.translate(
                    offset: Offset(0, math.sin(phase + 0.6) * 3),
                    child: Transform.scale(
                      scale: logoScale,
                      child: SizedBox(
                        width: logoSize,
                        height: logoSize,
                        child: Image.asset(
                          'assets/images/easy_ui_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrbitBadge extends StatelessWidget {
  const _OrbitBadge({
    required this.alignment,
    required this.progress,
    required this.delay,
    required this.size,
    required this.icon,
    required this.color,
    required this.palette,
  });

  final Alignment alignment;
  final double progress;
  final double delay;
  final double size;
  final IconData icon;
  final Color color;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final phase = (progress + delay) * math.pi * 2;
    final drift = Offset(math.cos(phase) * 5, math.sin(phase) * 6);

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: drift,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: size * 0.48),
        ),
      ),
    );
  }
}

class _SparkDot extends StatelessWidget {
  const _SparkDot({
    required this.alignment,
    required this.progress,
    required this.delay,
    required this.color,
  });

  final Alignment alignment;
  final double progress;
  final double delay;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final phase = (progress + delay) * math.pi * 2;
    final opacity = 0.28 + (math.sin(phase) + 1) * 0.22;

    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: 0.82 + (math.sin(phase) + 1) * 0.18,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.36), blurRadius: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoOrbitPainter extends CustomPainter {
  const _LogoOrbitPainter({required this.palette, required this.progress});

  final _LandingPalette palette;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final basePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = palette.border.withValues(alpha: 0.78);
    final activePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = palette.primary.withValues(alpha: 0.36);
    final dotPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = palette.primary.withValues(alpha: 0.36);

    final wideOrbit = Rect.fromCenter(
      center: center,
      width: size.width * 0.72,
      height: size.height * 0.5,
    );
    final tallOrbit = Rect.fromCenter(
      center: center,
      width: size.width * 0.46,
      height: size.height * 0.72,
    );

    canvas.drawOval(wideOrbit, basePaint);
    canvas.drawOval(tallOrbit, basePaint);

    final start = progress * math.pi * 2;
    canvas.drawArc(wideOrbit, start, math.pi * 0.44, false, activePaint);
    canvas.drawArc(
      tallOrbit,
      -start * 0.82,
      math.pi * 0.36,
      false,
      activePaint,
    );

    for (final item in [
      (wideOrbit, start + math.pi * 0.82),
      (wideOrbit, start + math.pi * 1.56),
      (tallOrbit, -start + math.pi * 0.34),
      (tallOrbit, -start + math.pi * 1.22),
    ]) {
      final point = Offset(
        item.$1.center.dx + math.cos(item.$2) * item.$1.width / 2,
        item.$1.center.dy + math.sin(item.$2) * item.$1.height / 2,
      );
      canvas.drawCircle(point, 3.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.palette != palette;
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
        title: '全平台支持',
        description: '支持全平台应用开发中的视图构建。Android、iOS、MacOS、Linux、Windows、Web',
      ),
      _FeatureData(
        icon: Icons.widgets_outlined,
        color: palette.amber,
        title: '组件化',
        description: '组件独立存在，可选择使用个体组件。不侵入你原有的项目代码结构。',
      ),
      _FeatureData(
        icon: Icons.code,
        color: palette.green,
        title: '源代码开放',
        description: 'MIT 开源协议，源代码完全公开，允许任何个人和企业使用。',
      ),
      _FeatureData(
        icon: Icons.web_asset_outlined,
        color: palette.red,
        title: '响应式布局',
        description: '根据设备屏幕信息，让视图可以响应式变化。',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '功能特性',
          textAlign: TextAlign.center,
          style: _LandingTypography.sectionTitle(palette),
        ),
        const SizedBox(height: 46),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns =
                width >= 1060
                    ? 4
                    : width >= 700
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 270,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
  const _ResourceSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SponsorSection(palette: palette),
        _FooterDivider(palette: palette),
        _FooterLinksSection(palette: palette),
        _FooterDivider(palette: palette),
        _FooterCopyright(palette: palette),
      ],
    );
  }
}

class _SponsorSection extends StatefulWidget {
  const _SponsorSection({required this.palette});

  final _LandingPalette palette;

  @override
  State<_SponsorSection> createState() => _SponsorSectionState();
}

class _SponsorSectionState extends State<_SponsorSection> {
  final _sponsorTooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final projects = [
      const _SponsorProjectData(
        name: 'Mxgraph EasyFlowEditor',
        description: '基于 mxGraph 和 Vue 2.0 的流程图编辑器',
        url: 'https://github.com/Jason-chen-coder/Mxgraph-EasyFlowEditor',
        imageAsset: 'assets/images/mxgraph_app_icon.png',
      ),
      const _SponsorProjectData(
        name: 'Flutter EasySpeechRecognition',
        description: 'Flutter 语音识别与录音能力工具',
        url:
            'https://github.com/Jason-chen-coder/Flutter-EasySpeechRecognition',
        imageAsset: 'assets/images/easy_speech_logo.jpg',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Text(
            '合作与赞助',
            textAlign: TextAlign.center,
            style: _LandingTypography.sectionTitle(palette),
          ),
          const SizedBox(height: 54),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final projectCards =
                  projects
                      .map(
                        (project) => _SponsorProjectCard(
                          data: project,
                          palette: palette,
                        ),
                      )
                      .toList();

              if (compact) {
                return Column(
                  children:
                      projectCards
                          .map(
                            (card) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: card,
                            ),
                          )
                          .toList(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: projectCards[0]),
                  const SizedBox(width: 78),
                  Flexible(child: projectCards[1]),
                ],
              );
            },
          ),
          const SizedBox(height: 50),
          Tooltip(
            key: _sponsorTooltipKey,
            message: _sponsorEmail,
            triggerMode: TooltipTriggerMode.manual,
            preferBelow: false,
            showDuration: const Duration(seconds: 4),
            child: OutlinedButton(
              onPressed: () {
                _sponsorTooltipKey.currentState?.ensureTooltipVisible();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textMuted,
                side: BorderSide(color: palette.borderStrong),
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 17,
                ),
                shape: const StadiumBorder(),
                textStyle: _LandingTypography.link(palette),
              ),
              child: const Text('成为赞助商!'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorProjectCard extends StatelessWidget {
  const _SponsorProjectCard({required this.data, required this.palette});

  final _SponsorProjectData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '打开 ${data.name}',
      child: InkWell(
        onTap:
            () => _launchExternal(
              Uri.parse(data.url),
              webOnlyWindowName: '_self',
            ),
        borderRadius: BorderRadius.circular(8),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SponsorProjectIcon(data: data, palette: palette),
              const SizedBox(width: 22),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _LandingTypography.contentTitle(
                        palette,
                      ).copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _LandingTypography.body(palette),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SponsorProjectIcon extends StatelessWidget {
  const _SponsorProjectIcon({required this.data, required this.palette});

  final _SponsorProjectData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    if (data.imageAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          data.imageAsset!,
          width: 82,
          height: 82,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: palette.textStrong,
        shape: BoxShape.circle,
      ),
      child: Icon(data.icon!, color: palette.surface, size: 42),
    );
  }
}

class _FooterLinksSection extends StatelessWidget {
  const _FooterLinksSection({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    final columns = [
      const _FooterColumnData(
        title: '链接',
        links: [
          _FooterLinkData('Github', _easyUiRepoUrl),
          _FooterLinkData('在线预览', _easyUiPreviewUrl),
          _FooterLinkData('更新日志', '$_easyUiRepoUrl/releases'),
          _FooterLinkData('常见问题', '$_easyUiRepoUrl/issues'),
        ],
      ),
      const _FooterColumnData(
        title: '讨论区',
        links: [
          _FooterLinkData('建议反馈', '$_easyUiRepoUrl/issues/new'),
          _FooterLinkData('Issue 列表', '$_easyUiRepoUrl/issues'),
          _FooterLinkData('参与贡献', '$_easyUiRepoUrl/pulls'),
        ],
      ),
      const _FooterColumnData(
        title: '资源链接',
        links: [
          _FooterLinkData(
            'Mxgraph EasyFlowEditor',
            'https://github.com/Jason-chen-coder/Mxgraph-EasyFlowEditor',
          ),
          _FooterLinkData(
            'Flutter EasySpeechRecognition',
            'https://github.com/Jason-chen-coder/Flutter-EasySpeechRecognition',
          ),
          _FooterLinkData('Github 主页', _githubProfileUrl),
        ],
      ),
      const _FooterColumnData(
        title: '联系我',
        links: [
          _FooterLinkData('邮箱', 'mailto:$_sponsorEmail'),
          _FooterLinkData('Github', _githubProfileUrl),
          _FooterLinkData('合作与赞助', 'mailto:$_sponsorEmail'),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 58),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnsPerRow =
              constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: columns.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnsPerRow,
              mainAxisExtent: 206,
              mainAxisSpacing: 26,
              crossAxisSpacing: 36,
            ),
            itemBuilder:
                (context, index) =>
                    _FooterColumn(data: columns[index], palette: palette),
          );
        },
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.data, required this.palette});

  final _FooterColumnData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title,
          style: _LandingTypography.sectionTitle(
            palette,
          ).copyWith(fontSize: 24),
        ),
        const SizedBox(height: 24),
        ...data.links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FooterLink(data: link, palette: palette),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.data, required this.palette});

  final _FooterLinkData data;
  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchExternal(Uri.parse(data.url)),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          data.label,
          style: _LandingTypography.link(palette).copyWith(
            decoration:
                data.url.startsWith('http')
                    ? TextDecoration.underline
                    : TextDecoration.none,
            decorationColor: palette.textSoft,
            decorationThickness: 1,
          ),
        ),
      ),
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  const _FooterCopyright({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Made by',
                style: _LandingTypography.link(
                  palette,
                ).copyWith(color: palette.textStrong),
              ),
              InkWell(
                onTap: () => _launchExternal(Uri.parse(_githubProfileUrl)),
                child: Text(
                  'Jason Chen',
                  style: _LandingTypography.linkStrong(palette),
                ),
              ),
              Text(
                '&',
                style: _LandingTypography.link(
                  palette,
                ).copyWith(color: palette.textStrong),
              ),
              Text('Easy UI', style: _LandingTypography.linkStrong(palette)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Copyright © 2026 Easy UI',
            textAlign: TextAlign.center,
            style: _LandingTypography.link(
              palette,
            ).copyWith(color: palette.textStrong),
          ),
          const SizedBox(height: 10),
          Text(
            '联系邮箱 $_sponsorEmail',
            textAlign: TextAlign.center,
            style: _LandingTypography.bodySmall(
              palette,
            ).copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FooterDivider extends StatelessWidget {
  const _FooterDivider({required this.palette});

  final _LandingPalette palette;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: palette.border);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: _LandingTypography.sectionEyebrow(palette)),
        const SizedBox(height: 8),
        Text(
          title,
          style: _LandingTypography.sectionTitle(
            palette,
          ).copyWith(color: palette.textStrong),
        ),
        const SizedBox(height: 10),
        Text(description, style: _LandingTypography.body(palette)),
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
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.data.icon,
              color: widget.data.color,
              size: 52,
              opticalSize: 52,
            ),
            const SizedBox(height: 26),
            Text(
              widget.data.title,
              textAlign: TextAlign.center,
              style: _LandingTypography.contentTitle(palette),
            ),
            const SizedBox(height: 18),
            Text(
              widget.data.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: _LandingTypography.bodySmall(palette),
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
              style: _LandingTypography.contentTitle(
                palette,
              ).copyWith(color: colors[index]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: _LandingTypography.contentTitle(palette),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.description,
                    style: _LandingTypography.bodySmall(
                      palette,
                    ).copyWith(color: palette.textMuted),
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

class _SponsorProjectData {
  const _SponsorProjectData({
    required this.name,
    required this.description,
    required this.url,
    this.icon,
    this.imageAsset,
  }) : assert(icon != null || imageAsset != null);

  final String name;
  final String description;
  final String url;
  final IconData? icon;
  final String? imageAsset;
}

class _FooterColumnData {
  const _FooterColumnData({required this.title, required this.links});

  final String title;
  final List<_FooterLinkData> links;
}

class _FooterLinkData {
  const _FooterLinkData(this.label, this.url);

  final String label;
  final String url;
}

class _CategoryData {
  const _CategoryData(this.title, this.description, this.route);

  final String title;
  final String description;
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
