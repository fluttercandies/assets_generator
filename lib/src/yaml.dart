import 'dart:io';

import 'package:io/ansi.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'arg/type.dart';

const String license = '''

   # GENERATED CODE - DO NOT MODIFY MANUALLY
   # **************************************************************************
   # Auto generated by https://github.com/fluttercandies/assets_generator
   # **************************************************************************

''';

const String assetsStart = '\n   # assets start\n';
const String assetsEnd = '\n   # assets end\n';

class Yaml {
  Yaml(this.yamlFile, this.assets, this.miss, this.formatType);
  final File yamlFile;
  final List<String> assets;
  final List<String> miss;
  final FormatType formatType;

  void write() {
    if (formatType == FormatType.directory) {
      final List<String> directories = <String>[];
      for (final String asset in assets) {
        // resolution image assets miss main asset entry
        // It should define as a file
        if (miss.contains(asset)) {
          directories.add(asset);
        } else {
          final String d = '${dirname(asset)}/';
          if (!directories.contains(d)) {
            directories.add(d);
          }
        }
      }
      assets.clear();
      assets.addAll(directories);
    }

    assets.sort((String a, String b) => a.compareTo(b));

    final StringBuffer pubspecSb = StringBuffer();
    if (assets.isNotEmpty) {
      pubspecSb.write(assetsStart);
      pubspecSb.write(license);
      for (final String asset in assets) {
        pubspecSb.write('   - $asset\n');
      }
      pubspecSb.write(assetsEnd);
    }

    final String newAssets = pubspecSb.toString();

    String yamlString = yamlFile.readAsStringSync();

    final int start = yamlString.indexOf(assetsStart);

    final int end = yamlString.indexOf(assetsEnd);

    if (start > -1 && end > -1) {
      yamlString = yamlString.replaceRange(
        start,
        end + assetsEnd.length,
        newAssets,
      );
    } else {
      final YamlMap yaml = loadYaml(yamlString) as YamlMap;

      if (yaml.containsKey('flutter')) {
        final YamlMap flutter = yaml['flutter'] as YamlMap;
        if (flutter != null && flutter.containsKey('assets')) {
          final YamlList assetsNode = flutter['assets'] as YamlList;
          if (assetsNode != null) {
            final int start =
                assetsNode.nodes.first.span.start.offset - '   - '.length;
            final int end = assetsNode.nodes.last.span.end.offset;

            yamlString = yamlString.replaceRange(
              start,
              end,
              newAssets,
            );
          }
          //Empty
          else {
            final int end =
                yamlString.lastIndexOf('assets:') + 'assets:'.length;
            yamlString = yamlString.replaceRange(end, end, newAssets);
          }
        } else if (flutter != null) {
          final int end = flutter.span.end.offset;
          yamlString =
              yamlString.replaceRange(end, end, '\n  assets:$newAssets');
        }
        //Empty
        else {
          final int end =
              yamlString.lastIndexOf('flutter:') + 'flutter:'.length;
          yamlString =
              yamlString.replaceRange(end, end, '\n  assets:$newAssets');
        }
      } else {
        final int end = yaml.span.end.offset;
        yamlString =
            yamlString.replaceRange(end, end, 'flutter:\n  assets:$newAssets');
      }
    }

    if (assets.isEmpty) {
      yamlString = yamlString.replaceAll('assets:', '');
    }

    yamlFile.writeAsStringSync(yamlString);
    print(green.wrap('${yamlFile.path} is changed automatically.'));
  }
}
