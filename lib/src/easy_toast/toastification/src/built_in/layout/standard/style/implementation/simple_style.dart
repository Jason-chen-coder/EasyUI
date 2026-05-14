import 'package:flutter/material.dart';

import '../../../../../../toastification.dart';

class SimpleStandardToastStyle extends BaseStandardToastStyle {
  const SimpleStandardToastStyle({
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
    constraints: const BoxConstraints(),
  );

  @override
  Color get iconColor => primaryColor;
}
