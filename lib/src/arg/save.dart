import 'arg.dart';
import 'arg_parser.dart';

class Save extends Argument {
  @override
  String get abbr => 's';

  @override
  dynamic get defaultsTo => false;

  @override
  String get help =>
      'Whether save the arguments into the local\nIt will execute the local arguments if run "agen" without any arguments';

  @override
  String get name => 'save';

  @override
  bool get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as bool;
    }
    return defaultsTo as bool;
  }
}
