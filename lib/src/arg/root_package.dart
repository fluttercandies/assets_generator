import 'arg.dart';

class RootPackage extends Argument<String?> {
  @override
  String? get abbr => null;

  @override
  String? get defaultsTo => null;

  @override
  String get help =>
      'Specify which package should be treated as the root project (by package name)';

  @override
  String get name => 'root-package';
}
