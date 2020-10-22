import 'package:args/args.dart';
import 'arg.dart';

class Type extends Argument {
  @override
  String get abbr => 't';

  @override
  dynamic get defaultsTo => 'd';

  @override
  String get help =>
      '''The type of format in pubsepec.yaml \n"d" means directory "- assets/images/" \n"f" means file      "- assets/images/xxx.jpg" ''';

  @override
  String get name => 'type';

  @override
  String value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as String;
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
