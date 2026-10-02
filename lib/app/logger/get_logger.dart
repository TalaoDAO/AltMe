import 'package:altme/app/logger/custom_log_printer.dart';
import 'package:logger/logger.dart';

Logger getLogger(String className) {
  final logger = Logger(printer: CustomLogPrinter(className));
  return logger;
}
