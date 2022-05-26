import 'arg.dart';

class Package extends Argument<bool> {
  @override
  String? get abbr => null;

  @override
  bool get defaultsTo => false;

  @override
  String get help =>
      'Whether is it a package, if it is true, it will generate package name in Assets Class';

  @override
  String get name => 'package';
}
