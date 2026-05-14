import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'easy_ui_localizations_en.dart';
import 'easy_ui_localizations_ru.dart';
import 'easy_ui_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of EasyUiLocalizations
/// returned by `EasyUiLocalizations.of(context)`.
///
/// Applications need to include `EasyUiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/easy_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: EasyUiLocalizations.localizationsDelegates,
///   supportedLocales: EasyUiLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the EasyUiLocalizations.supportedLocales
/// property.
abstract class EasyUiLocalizations {
  EasyUiLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static EasyUiLocalizations of(BuildContext context) {
    return Localizations.of<EasyUiLocalizations>(context, EasyUiLocalizations)!;
  }

  static const LocalizationsDelegate<EasyUiLocalizations> delegate = _EasyUiLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @filterFields.
  ///
  /// In zh, this message translates to:
  /// **'字段筛选'**
  String get filterFields;

  /// No description provided for @loadImageFailed.
  ///
  /// In zh, this message translates to:
  /// **'图片加载失败'**
  String get loadImageFailed;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @pickAll.
  ///
  /// In zh, this message translates to:
  /// **'选择全部'**
  String get pickAll;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @loadFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get loadFailed;

  /// No description provided for @pleasSelectDateTime.
  ///
  /// In zh, this message translates to:
  /// **'请选择日期时间'**
  String get pleasSelectDateTime;

  /// No description provided for @to.
  ///
  /// In zh, this message translates to:
  /// **'至'**
  String get to;

  /// No description provided for @pleaseSelectTimeRange.
  ///
  /// In zh, this message translates to:
  /// **'请选择时间范围'**
  String get pleaseSelectTimeRange;

  /// No description provided for @selectDateTime.
  ///
  /// In zh, this message translates to:
  /// **'选择日期时间'**
  String get selectDateTime;

  /// No description provided for @selectTimeRange.
  ///
  /// In zh, this message translates to:
  /// **'选择时间范围'**
  String get selectTimeRange;

  /// No description provided for @weekMon.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get weekMon;

  /// No description provided for @weekTue.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get weekTue;

  /// No description provided for @weekWed.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get weekWed;

  /// No description provided for @weekThu.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get weekThu;

  /// No description provided for @weekFri.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get weekFri;

  /// No description provided for @weekSat.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get weekSat;

  /// No description provided for @weekSun.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get weekSun;

  /// No description provided for @selectTime.
  ///
  /// In zh, this message translates to:
  /// **'选择时间'**
  String get selectTime;

  /// No description provided for @startTime.
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In zh, this message translates to:
  /// **'结束时间'**
  String get endTime;

  /// No description provided for @hour.
  ///
  /// In zh, this message translates to:
  /// **'时'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In zh, this message translates to:
  /// **'分'**
  String get minute;

  /// No description provided for @second.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get second;

  /// No description provided for @selectDate.
  ///
  /// In zh, this message translates to:
  /// **'选择日期'**
  String get selectDate;

  /// No description provided for @pleaseSelect.
  ///
  /// In zh, this message translates to:
  /// **'请选择'**
  String get pleaseSelect;

  /// No description provided for @startDate.
  ///
  /// In zh, this message translates to:
  /// **'开始日期'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In zh, this message translates to:
  /// **'结束日期'**
  String get endDate;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get clear;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @years.
  ///
  /// In zh, this message translates to:
  /// **'{years}年'**
  String years(int years);

  /// No description provided for @months.
  ///
  /// In zh, this message translates to:
  /// **'{months}月'**
  String months(int months);

  /// No description provided for @dataMissed.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get dataMissed;

  /// No description provided for @reload.
  ///
  /// In zh, this message translates to:
  /// **'重新加载'**
  String get reload;

  /// No description provided for @totalRecords.
  ///
  /// In zh, this message translates to:
  /// **'共{total}条'**
  String totalRecords(int total);

  /// No description provided for @itemsPerPage.
  ///
  /// In zh, this message translates to:
  /// **'{pageSize}条/页'**
  String itemsPerPage(int pageSize);

  /// No description provided for @errorToastTitle.
  ///
  /// In zh, this message translates to:
  /// **'错误提示'**
  String get errorToastTitle;

  /// No description provided for @okToastTitle.
  ///
  /// In zh, this message translates to:
  /// **'温馨提示'**
  String get okToastTitle;

  /// No description provided for @warningToastTitle.
  ///
  /// In zh, this message translates to:
  /// **'警告提示'**
  String get warningToastTitle;

  /// No description provided for @infoToastTitle.
  ///
  /// In zh, this message translates to:
  /// **'信息提示'**
  String get infoToastTitle;

  /// No description provided for @todayShort.
  ///
  /// In zh, this message translates to:
  /// **'今'**
  String get todayShort;

  /// No description provided for @modeDay.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get modeDay;

  /// No description provided for @modeWeek.
  ///
  /// In zh, this message translates to:
  /// **'周'**
  String get modeWeek;

  /// No description provided for @modeMonth.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get modeMonth;

  /// No description provided for @modeYear.
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get modeYear;

  /// No description provided for @modeCustom.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get modeCustom;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In zh, this message translates to:
  /// **'请选择日期'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectStartOrEndDate.
  ///
  /// In zh, this message translates to:
  /// **'请选择开始/结束日期'**
  String get pleaseSelectStartOrEndDate;

  /// No description provided for @noOptionsYet.
  ///
  /// In zh, this message translates to:
  /// **'暂无选项'**
  String get noOptionsYet;

  /// No description provided for @comingSoonDescription.
  ///
  /// In zh, this message translates to:
  /// **'我们正在打造一款令人惊叹的产品，敬请期待'**
  String get comingSoonDescription;

  /// No description provided for @confirmClose.
  ///
  /// In zh, this message translates to:
  /// **'确认关闭？'**
  String get confirmClose;

  /// No description provided for @unsavedChangesWillBeLost.
  ///
  /// In zh, this message translates to:
  /// **'关闭后未保存的更改将丢失。'**
  String get unsavedChangesWillBeLost;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get ok;

  /// No description provided for @uploadButtonText.
  ///
  /// In zh, this message translates to:
  /// **'点击上传或拖动文件到此'**
  String get uploadButtonText;

  /// No description provided for @typographyParagraphMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get typographyParagraphMore;

  /// No description provided for @typographyParagraphCollapse.
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get typographyParagraphCollapse;

  /// No description provided for @loadError.
  ///
  /// In zh, this message translates to:
  /// **'加载出错'**
  String get loadError;

  /// No description provided for @pleaseEnter.
  ///
  /// In zh, this message translates to:
  /// **'请输入{name}'**
  String pleaseEnter(String name);

  /// No description provided for @cannotEmpty.
  ///
  /// In zh, this message translates to:
  /// **'{name}不能为空'**
  String cannotEmpty(String name);

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @hasCopyToClipboard.
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪切板'**
  String get hasCopyToClipboard;

  /// No description provided for @switchToSystemKeyboard.
  ///
  /// In zh, this message translates to:
  /// **'切换到系统键盘'**
  String get switchToSystemKeyboard;

  /// No description provided for @moveToBottom.
  ///
  /// In zh, this message translates to:
  /// **'移动到底部'**
  String get moveToBottom;

  /// No description provided for @moveToTop.
  ///
  /// In zh, this message translates to:
  /// **'移动到顶部'**
  String get moveToTop;

  /// No description provided for @actionZoomUp.
  ///
  /// In zh, this message translates to:
  /// **'放大'**
  String get actionZoomUp;

  /// No description provided for @actionZoomDown.
  ///
  /// In zh, this message translates to:
  /// **'缩小'**
  String get actionZoomDown;

  /// No description provided for @actionZoomFit.
  ///
  /// In zh, this message translates to:
  /// **'自适应'**
  String get actionZoomFit;

  /// No description provided for @actionBackToTop.
  ///
  /// In zh, this message translates to:
  /// **'回到顶部'**
  String get actionBackToTop;
}

class _EasyUiLocalizationsDelegate extends LocalizationsDelegate<EasyUiLocalizations> {
  const _EasyUiLocalizationsDelegate();

  @override
  Future<EasyUiLocalizations> load(Locale locale) {
    return SynchronousFuture<EasyUiLocalizations>(lookupEasyUiLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_EasyUiLocalizationsDelegate old) => false;
}

EasyUiLocalizations lookupEasyUiLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return EasyUiLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return EasyUiLocalizationsEn();
    case 'ru': return EasyUiLocalizationsRu();
    case 'zh': return EasyUiLocalizationsZh();
  }

  throw FlutterError(
    'EasyUiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
