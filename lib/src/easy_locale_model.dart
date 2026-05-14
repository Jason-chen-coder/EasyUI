import 'dart:ui';

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/foundation.dart';

abstract class EasyLocaleModel extends ChangeNotifier {
  Locale get locale;

  Future<void> changeLocale(Locale locale);

  static List<Locale> get supportedLocales {
    // TODO: 暂不开放俄语选项
    return EasyUiLocalizations.supportedLocales
        .where((e) => e.languageCode != 'ru')
        .toList();
  }
}
