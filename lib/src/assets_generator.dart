import 'dart:io';
import 'package:assets_generator/assets_generator.dart';
import 'package:assets_generator/src/format.dart';
import 'package:assets_generator/src/watcher.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'arg/rule.dart';
import 'arg/type.dart';
import 'template.dart';

class Generator {
  Generator({
    this.packageGraph,
    this.formatType = FormatType.directory,
    this.folder = 'assets',
    this.watch = true,
    this.output = 'lib',
    this.rule,
    this.class1,
  });

  final PackageNode packageGraph;
  final String folder;
  final FormatType formatType;
  final bool watch;
  final String output;
  final Rule rule;
  final Class class1;

  void go() {
    if (watch) {
      final Watcher watcher = Watcher(_go(), () {
        _go();
      });
      watcher.startWatch();
    }
  }

  List<Directory> _go() {
    final String path = packageGraph.path;
    final File yamlFile = File(join(path, 'pubspec.yaml'));
    if (!yamlFile.existsSync()) {
      throw Exception('$path is not a Flutter project.');
    }
    final Directory assetsDirectory = Directory(join(path, folder));
    if (!assetsDirectory.existsSync()) {
      assetsDirectory.createSync();
    }

    final List<Directory> dirList = <Directory>[];
    final List<String> assets = <String>[];
    findAssets(assetsDirectory, assets, dirList);
    final StringBuffer pubspecSb = StringBuffer();

    generateFile(assets);

    if (formatType == FormatType.directory) {
      final List<String> directories = <String>[];
      for (final String asset in assets) {
        final String d = '${dirname(asset)}/';
        if (!directories.contains(d)) {
          directories.add(d);
        }
      }
      assets.clear();
      assets.addAll(directories);
    }
    if (assets.isNotEmpty) {
      print(green.wrap('find following assets: '));
    }
    for (final String asset in assets) {
      print(green.wrap(asset));
      pubspecSb.write('   - $asset\n');
    }
    overrideYaml(yamlFile, pubspecSb.toString());
    return dirList;
  }

  void findAssets(
    Directory directory,
    List<String> assets,
    List<Directory> dirList,
  ) {
    dirList.add(directory);

    for (final FileSystemEntity item in directory.listSync()) {
      final FileStat fileStat = item.statSync();
      if (fileStat.type == FileSystemEntityType.directory) {
        findAssets(
          Directory(item.path),
          assets,
          dirList,
        );
      } else if (fileStat.type == FileSystemEntityType.file) {
        if (basename(item.path) != '.DS_Store') {
          assets.add(item.path
              .replaceAll('${packageGraph.path}$separator', '')
              .replaceAll(separator, '/'));
        }
      }
    }
  }

  void overrideYaml(File yamlFile, String newAssets) {
    if (newAssets == null || newAssets.isEmpty) {
      return;
    }
    String yamlString = yamlFile.readAsStringSync();
    final YamlMap yaml = loadYaml(yamlString) as YamlMap;

    if (yaml.containsKey('flutter')) {
      final YamlMap flutter = yaml['flutter'] as YamlMap;
      if (flutter != null && flutter.containsKey('assets')) {
        final YamlList assetsNode = flutter['assets'] as YamlList;
        if (assetsNode != null) {
          final int start =
              assetsNode.nodes.first.span.start.offset - '   - '.length;
          final int end = assetsNode.span.end.offset;
          yamlString = yamlString.replaceRange(
            start,
            end,
            newAssets,
          );
        }
        //Empty
        else {
          final int end = yamlString.lastIndexOf('assets:') + 'assets:'.length;
          yamlString = yamlString.replaceRange(end, end, '\n$newAssets');
        }
      } else if (flutter != null) {
        final int end = flutter.span.end.offset;
        yamlString =
            yamlString.replaceRange(end, end, '\n  assets:\n$newAssets');
      }
      //Empty
      else {
        final int end = yamlString.lastIndexOf('flutter:') + 'flutter:'.length;
        yamlString =
            yamlString.replaceRange(end, end, '\n  assets:\n$newAssets');
      }
    } else {
      final int end = yaml.span.end.offset;
      yamlString =
          yamlString.replaceRange(end, end, 'flutter:\n  assets:\n$newAssets');
    }
    yamlFile.writeAsStringSync(yamlString);
    print(green.wrap('${yamlFile.path} is changed automatically.'));
  }

  void generateFile(List<String> assets) {
    if (assets == null || assets.isEmpty) {
      return;
    }
    final String path = packageGraph.path;
    final String fileName = class1.go('lwu');

    final File file = File(join(path, output, '$fileName.dart'));

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    file.writeAsStringSync(
      formatDart(
        Template(
          assets,
          packageGraph,
          rule,
          class1,
        ).toString(),
      ),
    );
  }
}
