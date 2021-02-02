import 'arg.dart';

class ConstArray extends Argument<bool> {
  @override
  String get abbr => null;

  @override
  bool get defaultsTo => false;

  @override
  String get help => 'Whether generate the array of all the consts';

  @override
  String get name => 'const-array';
}
