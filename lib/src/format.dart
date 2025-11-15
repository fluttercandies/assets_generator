import 'dart:io' as io show File;

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart' show loadYaml;

class _Config {
  const _Config(this.sdk, this.pageWidth);

  final VersionConstraint? sdk;
  final int? pageWidth;
}

/// The formatter will only use the tall-style if the SDK constraint is ^3.7.
DartFormatter _buildDartFormatter({
  required VersionConstraint? sdk,
  required int? pageWidth,
}) {
  // bool useShort = true;
  // if (sdk != null) {
  //   useShort = sdk.allowsAny(VersionConstraint.parse('<3.7.0'));
  // }
  return DartFormatter(
    // languageVersion: useShort
    //     ? Version(3, 6, 0)
    //     : DartFormatter.latestLanguageVersion,
    pageWidth: pageWidth,
    lineEnding: '\n',
  );
}

String formatDart(
  String content,
  String directory,
) {
  try {
    final _Config config = _readConfig(directory);
    final DartFormatter formatter =
        _buildDartFormatter(sdk: config.sdk, pageWidth: config.pageWidth);
    return formatter.format(content);
  } catch (e) {
    return content;
  }
}

_Config _readConfig(String directory) {
  final io.File pubspecFile = io.File(p.join(directory, 'pubspec.yaml'));
  final Map? pubspecSource = pubspecFile.existsSync()
      ? loadYaml(pubspecFile.readAsStringSync()) as Map?
      : null;
  final VersionConstraint? sdk;
  final String? rawSdk = pubspecSource?['environment']?['sdk'] as String?;
  if (rawSdk != null) {
    sdk = VersionConstraint.parse(rawSdk);
  } else {
    sdk = null;
  }

  final io.File analysisFile =
      io.File(p.join(directory, 'analysis_options.yaml'));
  final Map? analysisSource = analysisFile.existsSync()
      ? loadYaml(analysisFile.readAsStringSync()) as Map?
      : null;
  final int? pageWidth = analysisSource?['formatter']?['page_width'] as int?;
  return _Config(sdk, pageWidth);
}
