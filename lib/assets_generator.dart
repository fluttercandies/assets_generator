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

      StringBuffer sb = StringBuffer();

      var files = assetsDirectory.listSync(recursive: true);
      if (type == GenerateType.directory) {
        sb.write("    - assets/\n");
      }

      for (FileSystemEntity item in files) {
        if ((type == GenerateType.file &&
                item.statSync().type == FileSystemEntityType.file) ||
            (type == GenerateType.directory &&
                item.statSync().type == FileSystemEntityType.directory)) {
          sb.write(
              "    - ${item.path.replaceAll(path + "/", "").replaceAll("\\", "/")}");
          if (item != files.last) {
            sb.write("\n");
          }
        }
      }

      YamlMap flutter = yaml["flutter"];

      if (flutter != null) {
        YamlList list = flutter["assets"];
        if (list != null) {
          var start = list.span.start.offset;
          var end = list.span.end.offset;
          yamlString = yamlString.replaceRange(
              start - "    ".length, end, sb.toString());
        } else {
          var end = flutter.span.end.offset;
          yamlString =
              yamlString.replaceRange(end, end, "  assets:\n${sb.toString()}");
        }
      } else {
        var end = yaml.span.end.offset;
        yamlString = yamlString.replaceRange(
            end, end, "flutter:\n  assets:\n${sb.toString()}");
      }

      print(
          "auto generate assets configs successfully at ${path}/pubspec.yaml");
      file.writeAsStringSync(yamlString);
    }
  }
}

enum GenerateType { directory, file }
