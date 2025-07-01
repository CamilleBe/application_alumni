import 'dart:developer';

import 'package:ekod_alumni/src/exceptions/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * This can be replaced with a call to a crash reporting tool
    log('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool
    log('$exception');
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) {
  return ErrorLogger();
}
