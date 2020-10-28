import 'dart:io';

import 'package:assets_generator/assets_generator.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'arg/type.dart';

const String license = '''

{0}# GENERATED CODE - DO NOT MODIFY MANUALLY
{0}# **************************************************************************
{0}# Auto generated by https://github.com/fluttercandies/assets_generator
{0}# **************************************************************************

''';

const String assetsStartConst = '# assets start\n';
const String assetsEndConst = '# assets end\n';
const String space = ' ';

class Yaml {
  Yaml(
    this.yamlFile,
    this.assets,
    this.miss,
    this.formatType,
  );
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

    String yamlString = yamlFile.readAsStringSync();

    //make sure that there are no '# assets start' and '# assets end'
    yamlString = yamlString
        .replaceAll(assetsStartConst, '')
        .replaceAll(assetsEndConst, '')
        .trim();

    final List<String> lines = yamlString.split('\n');

    final YamlMap yaml = loadYaml(yamlString) as YamlMap;

    final String indent = getIndent(yaml);

    final String assetsStart = '\n$indent$assetsStartConst';
    final String assetsEnd = '\n$indent$assetsEndConst';
    final StringBuffer pubspecSb = StringBuffer();
    if (assets.isNotEmpty) {
      pubspecSb.write(assetsStart);
      pubspecSb.write(license.replaceAll('{0}', indent));
      for (final String asset in assets) {
        pubspecSb.write('${indent * 2}- $asset\n');
      }
      pubspecSb.write(assetsEnd);
    }

    final String newAssets = pubspecSb.toString();

    final String assetsNodeS = indent + 'assets:\n' + newAssets;
    if (yaml.containsKey('flutter')) {
      final YamlMap flutter = yaml['flutter'] as YamlMap;
      if (flutter != null) {
        if (flutter.containsKey('assets')) {
          final YamlList assetsNode = flutter['assets'] as YamlList;
          final String assetsLine =
              lines.firstWhere((String element) => element.contains('assets:'));
          final int start = yamlString.indexOf(assetsLine);
          if (assetsNode != null) {
            final int end = assetsNode.nodes.last.span.end.offset;
            yamlString = yamlString.replaceRange(
              start,
              end,
              assetsNodeS,
            );
          }
          //Empty assets
          else {
            yamlString = yamlString.replaceRange(
                start, start + assetsLine.length, '\n' + assetsNodeS);
          }
        }
        //miss assets:
        else {
          final int end = flutter.span.end.offset;
          yamlString = yamlString.replaceRange(end, end, '\n' + assetsNodeS);
        }
      }
      //Empty flutter
      else {
        final int end = yamlString.lastIndexOf('flutter:') + 'flutter:'.length;
        yamlString = yamlString.replaceRange(end, end, '\n' + assetsNodeS);
      }
    }
    //miss flutter:
    else {
      final int end = yaml.span.end.offset;
      yamlString =
          yamlString.replaceRange(end, end, '\nflutter:\n$assetsNodeS');
    }

    if (assets.isEmpty) {
      //make sure that there are no 'assets:'
      yamlString = yamlString.replaceAll('assets:', '').trim();
    }

    yamlFile.writeAsStringSync(yamlString);
    print(green.wrap('${yamlFile.path} is changed automatically.'));
  }
}

String getIndent(YamlMap yamlMap) {
  if (yamlMap.containsKey('flutter')) {
    final YamlMap flutter = yamlMap['flutter'] as YamlMap;
    if (flutter != null && flutter.nodes.keys.first is YamlNode) {
      final FileSpan fileSpan = flutter.nodes.keys.first.span as FileSpan;
      return space * fileSpan.start.column;
    }
  }
  return space * 2;
}
