// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'easy_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class EasyUiLocalizationsRu extends EasyUiLocalizations {
  EasyUiLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get all => 'Все';

  @override
  String get filterFields => 'Фильтруемые поля';

  @override
  String get loadImageFailed => 'Не удалось загрузить изображение';

  @override
  String get close => 'Закрыть';

  @override
  String get pickAll => 'Выделить все';

  @override
  String get retry => 'Повторить';

  @override
  String get loadFailed => 'Не удалось загрузить';

  @override
  String get pleasSelectDateTime => 'Пожалуйста, выберите дату и время';

  @override
  String get to => 'по';

  @override
  String get pleaseSelectTimeRange => 'Пожалуйста, выберите диапазон времени';

  @override
  String get selectDateTime => 'Выбор даты и времени';

  @override
  String get selectTimeRange => 'Выбор диапазона времени';

  @override
  String get weekMon => 'Пнд';

  @override
  String get weekTue => 'Втр';

  @override
  String get weekWed => 'Срд';

  @override
  String get weekThu => 'Чтв';

  @override
  String get weekFri => 'Птн';

  @override
  String get weekSat => 'Сбт';

  @override
  String get weekSun => 'Вск';

  @override
  String get selectTime => 'Выбор времени';

  @override
  String get startTime => 'Время начала';

  @override
  String get endTime => 'Время окончания';

  @override
  String get hour => 'Час';

  @override
  String get minute => 'Минута';

  @override
  String get second => 'Секунда';

  @override
  String get selectDate => 'Выбор даты';

  @override
  String get pleaseSelect => 'Пожалуйста, выберите';

  @override
  String get startDate => 'Дата начала';

  @override
  String get endDate => 'Дата окончания';

  @override
  String get clear => 'Очистить';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String years(int years) {
    return '$years г.';
  }

  @override
  String months(int months) {
    return '$months мес.';
  }

  @override
  String get dataMissed => 'Данные отсутствуют';

  @override
  String get reload => 'Перезагрузить';

  @override
  String totalRecords(int total) {
    return 'Всего $total элементов';
  }

  @override
  String itemsPerPage(int pageSize) {
    return '$pageSize эл./стр.';
  }

  @override
  String get errorToastTitle => 'Ошибка';

  @override
  String get okToastTitle => 'Напоминание';

  @override
  String get warningToastTitle => 'Предупреждение';

  @override
  String get infoToastTitle => 'Информация';

  @override
  String get todayShort => 'Сегодня';

  @override
  String get modeDay => 'День';

  @override
  String get modeWeek => 'Неделя';

  @override
  String get modeMonth => 'Месяц';

  @override
  String get modeYear => 'Год';

  @override
  String get modeCustom => 'Пользовательский';

  @override
  String get pleaseSelectDate => 'Пожалуйста, выберите дату';

  @override
  String get pleaseSelectStartOrEndDate => 'Пожалуйста, выберите дату начала/окончания';

  @override
  String get noOptionsYet => 'Опции пока не доступны';

  @override
  String get comingSoonDescription => 'Мы создаем поразительное продукт — с нетерпением ждите!';

  @override
  String get confirmClose => 'Вы уверены, что хотите закрыть?';

  @override
  String get unsavedChangesWillBeLost => 'После закрытия несохраненные изменения будут потеряны.';

  @override
  String get ok => 'Подтвердить';

  @override
  String get uploadButtonText => 'Нажмите, чтобы загрузить, или перетащите файлы сюда';

  @override
  String get typographyParagraphMore => 'Ещё';

  @override
  String get typographyParagraphCollapse => 'Скрыть';

  @override
  String get loadError => 'Ошибка загрузки';

  @override
  String pleaseEnter(String name) {
    return 'Пожалуйста, введите $name';
  }

  @override
  String cannotEmpty(String name) {
    return '$name не может быть пустым';
  }

  @override
  String get language => 'Язык';

  @override
  String get save => 'Сохранить';

  @override
  String get hasCopyToClipboard => 'Скопировано в буфер обмена';

  @override
  String get switchToSystemKeyboard => 'Переключить на системную клавиатуру';

  @override
  String get moveToBottom => 'Переместить вниз';

  @override
  String get moveToTop => 'Переместить вверх';

  @override
  String get actionZoomUp => 'Увеличить';

  @override
  String get actionZoomDown => 'Уменьшить';

  @override
  String get actionZoomFit => 'Подогнать по размеру';

  @override
  String get actionBackToTop => 'Наверх';
}
