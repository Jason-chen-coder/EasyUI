import 'package:flutter/material.dart';

import 'easy_button.dart';
import 'easy_button_style.dart';

class EasyResetSearchButton extends StatelessWidget {
  const EasyResetSearchButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return EasyButton2(
      style: EasyButtonStyle(
        maximumSize: WidgetStatePropertyAll(Size.square(38)),
        fixedSize: WidgetStatePropertyAll(Size.square(38)),
        minimumSize: WidgetStatePropertyAll(Size.square(38)),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        foregroundColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      withDebounce: true,
      onPressed: onPressed,
      child: Image.asset(
        width: 38,
        height: 38,
        'assets/images/ic_reset_search_btn.png',
        package: 'easy_ui',
      ),
    );
  }
}
