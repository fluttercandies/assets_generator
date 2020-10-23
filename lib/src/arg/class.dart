import 'arg.dart';
import 'arg_parser.dart';

class Class extends Argument {
  @override
  String get abbr => 'c';

  @override
  dynamic get defaultsTo => 'Assets';

  @override
  String get help => 'The name of const Class';

  @override
  String get name => 'class';

  @override
  String get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as String;
    }
    return defaultsTo as String;
  }

  String go(String rule) {
    String input = value;
    //upperCamelCase
    if (rule == 'ucc') {
      if (input.length > 1) {
        input = input[0].toUpperCase() + input.substring(1);
        input = input.replaceAllMapped(RegExp(r'_([A-z])'), (Match match) {
          return match.group(0).replaceAll('_', '').toUpperCase();
        }).replaceAll('_', '');
      } else {
        input = input.toUpperCase();
      }
    }
    //lowercase_with_underscores
    else if (rule == 'lwu') {
      if (input.length > 1) {
        input = input[0].toLowerCase() + input.substring(1);
        input = input.replaceAllMapped(RegExp('([a-z])([A-Z])'), (Match match) {
          return match.group(0)[0] + '_' + match.group(0)[1].toLowerCase();
        });
      } else {
        input = input.toLowerCase();
      }
    }

    return input;
  }
}
