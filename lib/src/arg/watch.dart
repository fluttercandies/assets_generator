import 'package:args/args.dart';
import 'arg.dart';

class Watch extends Argument {
  @override
  String get abbr => 'w';

  @override
  dynamic get defaultsTo => true;

  @override
  String get help => 'Continue to monitor changes of assets';

  @override
  String get name => 'watch';

  @override
  bool value(ArgResults results) {
    if (results.wasParsed(name)) {
      return results[name] as bool;
    }
    return defaultsTo as bool;
  }
}
