import 'package:args/args.dart';
import 'arg.dart';

class Save extends Argument {
  @override
  String get abbr => 's';

  @override
  dynamic get defaultsTo => false;

  @override
  String get help =>
      'Save the arguments into local.\nIt will execute local arguments \nif run "agen" without any arguments';

  @override
  String get name => 'save';

  @override
  bool value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as bool;
    }
    return defaultsTo as bool;
  }
}
