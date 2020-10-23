import 'arg.dart';
import 'arg_parser.dart';

class Output extends Argument {
  @override
  String get abbr => 'o';

  @override
  dynamic get defaultsTo => 'lib';

  @override
  String get help => 'The path of const Class';

  @override
  String get name => 'out';

  @override
  String get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as String;
    }
    return defaultsTo as String;
  }
}
