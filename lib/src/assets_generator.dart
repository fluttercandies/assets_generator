import 'dart:io';
import 'package:assets_generator/assets_generator.dart';
import 'package:assets_generator/src/format.dart';
import 'package:assets_generator/src/watcher.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';
import 'arg/rule.dart';
import 'arg/type.dart';
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

  void go() {
    if (watch) {
      final Watcher watcher = Watcher(_go(), () {
        _go();
      });
      watcher.startWatch();
    } else {
      _go();
    }
  }

  List<Directory> _go() {
    final String path = packageGraph!.path;
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

    // resolution image assets miss main asset entry
    final List<String> miss = checkResolutionImageAssets(assets);

    assets.sort((String a, String b) => a.compareTo(b));

    generateConstsFile(assets);

    Yaml(yamlFile, assets, miss, formatType).write();

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

  void generateConstsFile(List<String> assets) {
    final String path = packageGraph!.path;
    final String? fileName = class1!.go('lwu');

    final File file = File(join(path, output, '$fileName.dart'));

    if (file.existsSync()) {
      file.deleteSync(recursive: true);
    }

    if (assets.isEmpty) {
      return;
    }

    file.createSync(recursive: true);

    file.writeAsStringSync(
      formatDart(
        Template(
          assets,
          packageGraph,
          rule,
          class1,
          constIgnore,
          constArray,
        ).toString(),
      ),
    );
  }

  List<String> checkResolutionImageAssets(List<String> assets) {
    // miss main asset entry
    final List<String> miss = <String>[];
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
          miss.add(r);
        }
        assets.remove(asset);
      }
    }
    return miss;
  }
}
