import 'arg.dart';
import 'arg_parser.dart';

class Watch extends Argument {
  @override
  String get abbr => 'w';

  @override
  dynamic get defaultsTo => true;

  @override
  String get help => 'Whether continue to monitor the changes of assets';

  @override
  String get name => 'watch';

  @override
  bool get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as bool;
    }
    return defaultsTo as bool;
  }
}
