import 'package:args/args.dart';
import 'arg_parser.dart';

abstract class Argument {
  Argument() {
    if (defaultsTo is bool) {
      parser.addFlag(name,
          abbr: abbr, help: help, defaultsTo: defaultsTo as bool);
    } else if (defaultsTo is String) {
      parser.addOption(name,
          abbr: abbr, help: help, defaultsTo: defaultsTo as String);
    } else {
      // TODO(zmtzawqlp): not implement for now.
      throw Exception('not implement fill method');
    }
  }

  /// The name of the option that the user passes as an argument.
  String get name;

  /// A single-character string that can be used as a shorthand for this option.
  ///
  /// For example, `abbr: "a"` will allow the user to pass `-a value` or
  /// `-avalue`.
  String get abbr;

  /// A description of this option.
  String get help;

  /// The value this option will have if the user doesn't explicitly pass it in
  dynamic get defaultsTo;

  /// The value this option
  dynamic value(ArgResults results);
}
