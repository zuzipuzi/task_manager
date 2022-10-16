import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: CustomLogger(className));
}

class CustomLogger extends LogPrinter {
  CustomLogger(this.className);

  final String className;

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    return [color!('$emoji $className - ${event.message}')];
  }
}
