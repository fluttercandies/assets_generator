import 'arg.dart';
import 'arg_parser.dart';

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
  bool get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as bool;
    }
    return defaultsTo as bool;
  }
}
