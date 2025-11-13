import 'arg.dart';

class UseKeyName extends Argument<bool> {
  @override
  String? get abbr => null;

  @override
  bool get defaultsTo => false;

  @override
  String get help =>
      'Whether to use keyName style (packages/{package}/...) for asset paths';

  @override
  String get name => 'use-key-name';
}
