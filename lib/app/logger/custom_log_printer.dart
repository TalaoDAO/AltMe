import 'package:logger/logger.dart';

class CustomLogPrinter extends LogPrinter {
  CustomLogPrinter(this.className);
  final String className;

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level]!;
    final emoji = PrettyPrinter.levelEmojis[event.level]!;
    final String message = '$emoji | $className | ${event.message}';
    return [color(message)];
  }
}
