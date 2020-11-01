import 'arg.dart';

class Output extends Argument<String> {
  @override
  String get abbr => 'o';

  @override
  String get defaultsTo => 'lib';

  @override
  String get help => 'The path of const Class';

  @override
  String get name => 'out';
}
