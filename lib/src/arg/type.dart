import 'arg.dart';
import 'arg_parser.dart';

class Type extends Argument {
  @override
  String get abbr => 't';

  @override
  dynamic get defaultsTo => 'd';

  @override
  String get help =>
      '''The type in pubsepec.yaml \n"d" means directory "- assets/images/" \n"f" means file      "- assets/images/xxx.jpg" ''';

  @override
  String get name => 'type';

  @override
  String get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as String;
    }
    return defaultsTo as String;
  }

  FormatType type(String value) {
    if (value == 'f') {
      return FormatType.file;
    }
    return FormatType.directory;
  }
}

enum FormatType {
  directory,
  file,
}
