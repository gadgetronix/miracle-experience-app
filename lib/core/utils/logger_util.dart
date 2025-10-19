import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var logger =
    Logger(printer: PrettyPrinter(methodCount: 0), output: ConsoleOutput());

void timber(dynamic content, {bool usePrint = false}) {
  if (usePrint) {
    if (kDebugMode) {
      print(content);
    }
  } else {
    logger.d(content);
  }
}
