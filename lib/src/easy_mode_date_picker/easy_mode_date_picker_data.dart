// 日期选择模式枚举
enum ModeDatePicker { day, week, month, year, custom }

// 选择结果模型
class DatePickerResult {
  final DateTime startDate;
  final DateTime endDate;
  final ModeDatePicker mode;

  DatePickerResult({
    required this.startDate,
    required this.endDate,
    required this.mode,
  });

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'mode': mode.toString().split('.').last,
    };
  }
}

enum ViewType { decade, year, month, day }
