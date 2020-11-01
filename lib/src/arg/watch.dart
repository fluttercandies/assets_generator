import 'arg.dart';

class Watch extends Argument<bool> {
  @override
  String get abbr => 'w';

  @override
  bool get defaultsTo => true;

  @override
  String get help => 'Whether continue to monitor the changes of assets';

  @override
  String get name => 'watch';
}
