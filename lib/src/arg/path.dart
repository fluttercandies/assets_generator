import 'package:args/args.dart';
import 'arg.dart';

class Path extends Argument {
  @override
  String get abbr => 'p';

  @override
  dynamic get defaultsTo => '.';

  @override
  String get help => 'Flutter project root path';

  @override
  String get name => 'path';

  @override
  String value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as String;
    }
    return defaultsTo as String;
  }
}
