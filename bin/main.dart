import 'package:assets_generator/assets_generator.dart';
import 'package:build_runner_core/build_runner_core.dart';

main(List<String> arguments) {
  PackageGraph packageGraph;
  var path =
      arguments.firstWhere((x) => x.contains("path="), orElse: () => null);
  if (path != null) {
    path = path.replaceAll("path=", "");
    packageGraph = PackageGraph.forPath(path);
  } else {
    packageGraph = PackageGraph.forThisPackage();
  }

  var type =
      arguments.firstWhere((x) => x.contains("type="), orElse: () => null);
  GenerateType generateType = GenerateType.directory;
  if (type != null) {
    generateType = GenerateType.values[int.parse(type.replaceAll("type=", ""))];
  }

  if (packageGraph != null) {
    var root = packageGraph.root;
    for (var item in packageGraph.allPackages.values) {
      generateAssets(
          packageGraph: item, rootPath: root.path, type: generateType);
    }
  }
}
