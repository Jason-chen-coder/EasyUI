import 'package:flutter/material.dart';

import '../../../easy_ui.dart';

class EasyI18nButton extends StatelessWidget {
  const EasyI18nButton({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return EasyButton2(
      type: EasyButtonType.iconDefault,
      style: EasyButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(theme.primaryGreen),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        fixedSize: WidgetStatePropertyAll(Size(36, 36)),
      ),
      child: EasySvgIcon.asset(
        'assets/svgs/ic_translate_btn.svg',
        package: 'easy_ui',
      ),
      onPressed: () {
        EasyI18nInputDrawer.show(context, onSaved: onSaved);
      },
    );
  }
}
