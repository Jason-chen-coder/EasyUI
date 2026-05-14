import 'dart:convert';

import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/gen/easy_ui_localizations.dart';

class EasyI18nInputModel with ChangeNotifier {
  EasyI18nInputModel({
    required this.locale,
    required this.l10n,
    required bool readOnly,
    this.maxLength = TextFieldHelper.nameMaxLen,
    this.labelText = '',
  }) {
    _readOnly = readOnly;
    _languageCode = locale.toLanguageTag();
  }

  /// 当前语言环境
  final Locale locale;

  /// 本地化资源
  final EasyUiLocalizations l10n;

  /// 组件中用到的属性（确保输入框状态和drawer状态一致）
  /// 是否只读
  bool _readOnly = false;
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    _readOnly = value;
    notifyListeners();
  }

  /// 最大输入长度
  final int? maxLength;

  /// 标签
  final String labelText;

  String _languageCode = '';
  String get languageCode => _languageCode;
  set languageCode(String value) {
    _languageCode = value;
    notifyListeners();
  }

  Map<String, String> _i18nValues = {};
  Map<String, String> get i18nValues => _i18nValues;

  String get i18nJson {
    try {
      return jsonEncode(_i18nValues);
    } catch (e) {
      return '';
    }
  }

  set i18nValues(Map<String, String> value) {
    final v = Map<String, String>.from(value);
    _i18nValues = v;
    notifyListeners();
  }

  void setI18nValue(String locale, String value) {
    _i18nValues[locale] = value.trim();
    notifyListeners();
  }

  void setI18nValueFromJson(String json) {
    try {
      final Map<String, dynamic> map;
      map = json.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(json)) : {};
      _i18nValues = map.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      _i18nValues = {locale.languageCode: json};
    }
    textEditingController.text = textFieldConfig.value;
    notifyListeners();
  }

  final textEditingController = TextEditingController();

  /// 当前正在编辑的语言code和对应的值
  ({String code, String value}) get textFieldConfig =>
      _i18nValues[locale.languageCode] != null
          ? (
            code: locale.languageCode,
            value: _i18nValues[locale.languageCode]!,
          )
          : _i18nValues.isEmpty
          ? (code: locale.languageCode, value: '')
          : (code: _i18nValues.keys.first, value: _i18nValues.values.first);

  String? validateTextFieldValue() {
    final value = textFieldConfig.value;
    if (value.trim().isEmpty) {
      return l10n.pleaseEnter('$labelText (${textFieldConfig.code})');
    }
    return null;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
