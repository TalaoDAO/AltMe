import 'package:logger/logger.dart';

class CustomLogPrinter extends LogPrinter {
  CustomLogPrinter(this.className);
  final String className;

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level]!;
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level]!;
    final String message = '$emoji | $className | ${event.message}';
    return [
      color(message),
      if (event.error != null)
        color('$emoji | $className | error: ${event.error}'),
      // The first frames locate the failure; the rest is framework noise.
      if (event.stackTrace != null)
        for (final frame in event.stackTrace.toString().split('\n').take(8))
          if (frame.isNotEmpty) color('$emoji | $className |   $frame'),
    ];
  }
}
