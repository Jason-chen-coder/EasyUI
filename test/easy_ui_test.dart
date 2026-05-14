import 'package:flutter_test/flutter_test.dart';

import 'package:easy_ui/easy_ui.dart';

void main() {
  test('exports Easy UI localization metadata', () {
    expect(EasyUiLocalizations.supportedLocales, isNotEmpty);
  });
}
