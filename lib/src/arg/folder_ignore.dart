import 'arg.dart';

class FolderIgnore extends Argument<String?> {
  @override
  String? get abbr => null;

  @override
  String? get defaultsTo => null;

  @override
  String get help => 'The regular to ignore some folders.';

  @override
  String get name => 'folder-ignore';
}
