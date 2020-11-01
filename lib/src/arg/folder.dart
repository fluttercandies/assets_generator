import 'arg.dart';

class Folder extends Argument<String> {
  @override
  String get abbr => 'f';

  @override
  String get defaultsTo => 'assets';

  @override
  String get help => 'The root folder of assets';

  @override
  String get name => 'folder';
}
