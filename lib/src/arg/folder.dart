import 'arg.dart';
import 'arg_parser.dart';

class Folder extends Argument {
  @override
  String get abbr => 'f';

  @override
  dynamic get defaultsTo => 'assets';

  @override
  String get help => 'The root folder of assets';

  @override
  String get name => 'folder';

  @override
  String get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as String;
    }
    return defaultsTo as String;
  }
}
