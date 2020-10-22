import 'package:args/args.dart';
import 'arg.dart';

class Output extends Argument {
  @override
  String get abbr => 'o';

  @override
  dynamic get defaultsTo => 'lib';

  @override
  String get help => 'The path of "assets.dart"';

  @override
  String get name => 'out';

  @override
  String value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as String;
    }
    return defaultsTo as String;
  }
}
