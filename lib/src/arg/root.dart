import 'package:args/args.dart';
import 'arg.dart';

class Root extends Argument {
  @override
  String get abbr => 'r';

  @override
  dynamic get defaultsTo => 'assets';

  @override
  String get help => 'The root directory of assets';

  @override
  String get name => 'root';

  @override
  String value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as String;
    }
    return defaultsTo as String;
  }
}
