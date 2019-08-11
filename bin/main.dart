import 'package:assets_generator/assets_generator.dart';
import 'package:build_runner_core/build_runner_core.dart';

main(List<String> arguments) {
  var packageGraph = arguments.isEmpty
      ? PackageGraph.forThisPackage()
      : PackageGraph.forPath(arguments.first);

  var type = arguments.length == 2
      ? GenerateType.values[int.parse(arguments[1])]
      : GenerateType.directory;

  if (packageGraph != null) {
    var root = packageGraph.root;
    for (var item in packageGraph.allPackages.values) {
      generateAssets(packageGraph: item, rootPath: root.path, type: type);
    }
  }
}
