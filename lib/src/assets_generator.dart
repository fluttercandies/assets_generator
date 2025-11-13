// ignore_for_file: avoid_print

import 'dart:io';
import 'package:assets_generator/assets_generator.dart';
import 'package:assets_generator/src/format.dart';
import 'package:assets_generator/src/watcher.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';
import 'template.dart';
import 'yaml.dart';

class Generator {
  Generator({
    this.packageGraph,
    this.formatType = FormatType.directory,
    this.folder = 'assets',
    this.watch = true,
    this.output = 'lib',
    this.rule,
    this.class1,
    this.constIgnore,
    this.constArray = false,
    this.folderIgnore,
    this.package = false,
    this.useKeyName = false,
    this.classPrefix = false,
    this.gSuffix = false,
    this.rootPackageName,
  });

  final PackageNode? packageGraph;
  final String? folder;
  final FormatType formatType;
  final bool watch;
  final String? output;
  final Rule? rule;
  final Class? class1;
  final RegExp? constIgnore;
  final bool? constArray;
  final RegExp? folderIgnore;
  final bool package;
  final bool useKeyName;
  final bool classPrefix;
  final bool gSuffix;
  final String? rootPackageName;

  Future<void> go() async {
    if (watch) {
      final Watcher watcher = Watcher(await _go(), () {
        _go();
      });
      watcher.startWatch();
    } else {
      _go();
    }
  }

  Future<List<Directory>> _go() async {
    final String path = packageGraph!.path;
    final File yamlFile = File(join(path, 'pubspec.yaml'));
    if (!yamlFile.existsSync()) {
      throw Exception('$path is not a Flutter project.');
    }
    final Directory assetsDirectory = Directory(join(path, folder));
    if (!assetsDirectory.existsSync() || assetsDirectory.listSync().isEmpty) {
      return <Directory>[];
      //  assetsDirectory.createSync();
    }

    final List<Directory> dirList = <Directory>[];
    final List<String> assets = <String>[];

    findAssets(assetsDirectory, assets, dirList);

    // resolution image assets miss main asset entry
    final Map<String, String> miss = checkResolutionImageAssets(assets);

    assets.sort((String a, String b) => a.compareTo(b));

    await generateConstsFile(assets, miss);

    Yaml(yamlFile, assets, miss.keys.toList(), formatType).write();

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
      if (folderIgnore != null && folderIgnore!.hasMatch(item.path)) {
        continue;
      } else if (fileStat.type == FileSystemEntityType.directory) {
        findAssets(
          Directory(item.path),
          assets,
          dirList,
        );
      } else if (fileStat.type == FileSystemEntityType.file) {
        if (basename(item.path) != '.DS_Store') {
          assets.add(item.path
              .replaceAll('${packageGraph!.path}$separator', '')
              .replaceAll(separator, '/'));
        }
      }
    }
  }

  Future<void> generateConstsFile(
    List<String> assets,
    Map<String, String> miss,
  ) async {
    final String path = packageGraph!.path;
    String? fileName = class1!.go('lwu', classPrefix ? packageGraph!.name : '');

    if (gSuffix) {
      fileName = '$fileName.g';
    }

    final File file = File(join(path, output, '$fileName.dart'));

    if (file.existsSync()) {
      file.deleteSync(recursive: true);
    }

    final File previewFile = File(join(path, output, '$fileName.preview.dart'));
    if (previewFile.existsSync()) {
      previewFile.deleteSync(recursive: true);
    }

    if (assets.isEmpty) {
      return;
    }

    file.createSync(recursive: true);

    final Template template = Template(
      assets,
      packageGraph,
      rule,
      class1,
      constIgnore,
      constArray,
      package,
      useKeyName,
      classPrefix,
      rootPackageName,
    );
    file.writeAsStringSync(
      formatDart(
        await template.generateFile(miss, previewFile),
      ),
    );
    if (previewFile.existsSync()) {
      final File gitIgnoreFile = File('$path/.gitignore');
      if (!gitIgnoreFile.existsSync()) {
        gitIgnoreFile.createSync(recursive: true);
      }

      final String line = previewFile.path.replaceAll(path, '');
      String content = await gitIgnoreFile.readAsString();
      if (!content.contains(line)) {
        content += '\n$line';
        await gitIgnoreFile.writeAsString(content);
      }
    }
  }

  Map<String, String> checkResolutionImageAssets(List<String> assets) {
    // miss main asset entry
    final Map<String, String> miss = <String, String>{};
    if (assets.isEmpty) {
      return miss;
    }
    print(green.wrap('find following assets: '));
    // 1.5x,2.0x,3.0x
    final RegExp regExp = RegExp(r'(([0-9]+).([0-9]+)|([0-9]+))x/');
    // check resolution image assets
    final List<String> list = assets.toList();

    for (final String asset in list) {
      print(green.wrap(asset));
      final String r = asset.replaceAllMapped(regExp, (Match match) {
        return '';
      });
      //macth
      if (r != asset) {
        if (!assets.contains(r)) {
          // throw Exception(red
          //     .wrap('miss main asset entry: ${packageGraph.path}$separator$r'));
          assets.add(r);
          miss[r] = asset;
        }
        assets.remove(asset);
      }
    }
    return miss;
  }
}
