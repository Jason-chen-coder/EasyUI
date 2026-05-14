import 'package:flutter/material.dart';

import '../../toastification.dart';

extension ContextExt on BuildContext {
  ToastificationThemeData get toastTheme => ToastificationTheme.of(this);
}
