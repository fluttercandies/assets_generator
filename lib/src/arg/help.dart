import 'package:args/args.dart';
import 'arg.dart';

class Help extends Argument {
  @override
  String get abbr => 'h';

  @override
  dynamic get defaultsTo => false;

  @override
  String get help => 'Help usage';

  @override
  String get name => 'help';

  @override
  bool value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as bool;
    }
    return defaultsTo as bool;
  }
}
