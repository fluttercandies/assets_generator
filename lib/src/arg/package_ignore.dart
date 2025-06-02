import 'arg.dart';

class PackageIgnore extends Argument<String?> {
  @override
  String? get abbr => null;

  @override
  String? get defaultsTo => null;

  @override
  String get help => 'The regular to ignore some packages.';

  @override
  String get name => 'package-ignore';
}
