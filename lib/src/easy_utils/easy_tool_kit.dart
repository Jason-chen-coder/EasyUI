import 'package:flutter/foundation.dart';

class TextFieldHelper {
  const TextFieldHelper._();

  static const int nameMaxLen = 64;
}

class ErrorHandler {
  const ErrorHandler._();

  static const ErrorHandler instance = ErrorHandler._();

  void logInfo(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(message, error, stackTrace);
  }

  void logWarn(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(message, error, stackTrace);
  }

  void logError(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(message, error, stackTrace);
  }

  void logSuccess(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(message, error, stackTrace);
  }

  void logToLocal(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(message, error, stackTrace);
  }

  void _log(Object? message, Object? error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint(message?.toString());
      if (error != null) {
        debugPrint(error.toString());
      }
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
