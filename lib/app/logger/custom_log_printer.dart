import 'package:logger/logger.dart';

class CustomLogPrinter extends LogPrinter {
  CustomLogPrinter(this.className);
  final String className;

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level]!;
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level]!;
    final String message = '$emoji | $className | ${event.message}';
    return [color(message)];
  }
}
