import 'package:arago_wallet/app/logger/custom_log_printer.dart';
import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: CustomLogPrinter(className));
}
