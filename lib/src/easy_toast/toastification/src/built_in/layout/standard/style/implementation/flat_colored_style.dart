import 'package:flutter/material.dart';

import '../../../../../../toastification.dart';

class FlatStandardColoredToastStyle extends BaseStandardToastStyle {
  const FlatStandardColoredToastStyle({
    required super.type,
    super.providedValues,
    super.flutterTheme,
  });

  @override
  DefaultStyleValues get defaults => DefaultStyleValues(
    primaryColor: type.color.toMaterialColor,
    surfaceLight: Colors.white,
    surfaceDark: Colors.black,
  );

  @override
  Color get backgroundColor => primaryColor.shade50;

  @override
  Color get iconColor => providedValues?.surfaceDark ?? defaults.surfaceDark;

  @override
  BorderSide get borderSide =>
      providedValues?.borderSide ?? BorderSide(color: primaryColor, width: 1.5);
}
