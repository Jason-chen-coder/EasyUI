import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'l10n/gen/easy_ui_localizations.dart';

class EasyEmptyView extends StatelessWidget {
  const EasyEmptyView({
    super.key,
    this.reload,
    this.text,
    this.image,
    this.title = '',
    this.reloadButtonTextColor,
    this.reloadButtonIconColor,
    this.reloadButtonStyle,
  }) : _isComingSoon = false;

  const EasyEmptyView.comingSoon({super.key})
    : _isComingSoon = true,
      reload = null,
      text = null,
      image = null,
      title = '',
      reloadButtonTextColor = null,
      reloadButtonIconColor = null,
      reloadButtonStyle = null;

  final Function? reload;
  final String? text;
  final String title;
  final String? image;
  final Color? reloadButtonTextColor;
  final Color? reloadButtonIconColor;
  final ButtonStyle? reloadButtonStyle;
  final bool _isComingSoon;

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _isComingSoon
                    ? 'assets/images/coming_soon.png'
                    : (image == null
                        ? switch (theme.brightness) {
                          Brightness.light => 'assets/images/empty_data.png',
                          Brightness.dark =>
                            'assets/images/empty_data_dark.png',
                        }
                        : image!),
                package: _isComingSoon || image == null ? 'easy_ui' : null,
              ),
              Column(
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xff4f5159),
                        fontSize: 16,
                      ),
                    ),
                  if (text == null || text?.isNotEmpty == true)
                    Text(
                      _isComingSoon
                          ? l10n.comingSoonDescription
                          : (text ?? l10n.dataMissed),
                      style: const TextStyle(
                        color: Color(0xff9E9EA1),
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 14),
                  if (reload != null)
                    FilledButton.icon(
                      style:
                          reloadButtonStyle ??
                          FilledButton.styleFrom(
                            backgroundColor: Color(0xff1484FC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                          ),
                      onPressed: () async {
                        reload!();
                      },
                      label: Text(
                        EasyUiLocalizations.of(context).reload,
                        style: TextStyle(
                          fontSize: 14,
                          color: reloadButtonTextColor ?? Colors.white,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/svgs/ic_refresh.svg',
                        package: 'easy_ui',
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          reloadButtonIconColor ?? Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
