import 'package:flutter/material.dart';

import '../../../../../../toastification.dart';

class MinimalStandardToastStyle extends BaseStandardToastStyle {
  const MinimalStandardToastStyle({
    required super.type,
    super.providedValues,
    super.flutterTheme,
  });

  @override
  DefaultStyleValues get defaults => DefaultStyleValues(
    primaryColor: type.color.toMaterialColor,
    surfaceLight: Colors.white,
    surfaceDark: Colors.black,
    borderSide: const BorderSide(color: Color(0xffEBEBEB), width: 1.5),
  );

  @override
  Color get iconColor => providedValues?.primaryColor ?? defaults.primaryColor;
}
