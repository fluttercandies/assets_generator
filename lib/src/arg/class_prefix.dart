import 'arg.dart';

class ClassPrefix extends Argument<bool> {
  @override
  String? get abbr => null;

  @override
  bool get defaultsTo => false;

  @override
  String get help =>
      'Whether use package name as prefix for the name of const Class';

  @override
  String get name => 'class-prefix';
}
