import 'package:build_runner_core/build_runner_core.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

void generateAssets(
    {PackageNode packageGraph,
    String rootPath,
    GenerateType type = GenerateType.directory}) {
  if (packageGraph != null &&
      packageGraph.dependencyType == DependencyType.path &&
      packageGraph.path.startsWith(rootPath)) {
    final path = packageGraph.path;
    Directory assetsDirectory = Directory("$path/assets");

    if (assetsDirectory.existsSync()) {
      final File file = File("$path/pubspec.yaml");
      if (!file.existsSync()) {
        throw Exception("Can't find $path/pubspec.yaml");
      }
      String yamlString = file.readAsStringSync();
      final YamlMap yaml = loadYaml(yamlString);

      YamlMap flutter = yaml["flutter"];

      if (flutter != null) {
        StringBuffer sb = StringBuffer();

        var files = assetsDirectory.listSync(recursive: true);
        sb.write("assets:\n");
        for (FileSystemEntity item in files) {
          if ((type == GenerateType.file &&
                  item.statSync().type == FileSystemEntityType.file) ||
              (type == GenerateType.directory &&
                  item.statSync().type == FileSystemEntityType.directory)) {
            sb.write(
                "    - ${item.path.replaceAll(packageGraph.path + "/", "").replaceAll("\\", "/")}");
            if (item != files.last) {
              sb.write("\n");
            }
          }
        }

        int start = yamlString.indexOf("assets:");

        YamlList list = flutter["assets"];
        if (list != null && list.last != null && start > -1) {
          var lastString = list.last.toString();
          int end = yamlString.indexOf(lastString, start);

          yamlString = yamlString.replaceRange(
              start, end + lastString.length, sb.toString());
        } else {
          yamlString += "\n${sb.toString()}";
        }
        print(
            "auto generate assets configs successfully at ${path}/pubspec.yaml");
        file.writeAsStringSync(yamlString);
        // YamlList list = YamlList.wrap(fileList);

        // Map yamlList = Map();

        // for (var item in flutter.entries) {
        //   if (item.key == "assets") {
        //     yamlList[item.key] = list;
        //   } else {
        //     yamlList[item.key] = item.value;
        //   }
        // }

        // YamlMap test = YamlMap.wrap(yamlList);

        // Map yamlResult = Map();

        // for (var item in yaml.entries) {
        //   if (item.key == "flutter") {
        //     yamlResult[item.key] = test;
        //   } else {
        //     yamlResult[item.key] = item.value;
        //   }
        // }

      }
    }
  }
}

enum GenerateType { file, directory }
