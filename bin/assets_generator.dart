import 'dart:io';

import 'package:args/args.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:assets_generator/assets_generator.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';

const String argumentsFile = 'assets_generator_arguments';
const String debugArguments =
    '-p E:/Flutter/FlutterCandies/assets_generator/example -s -t f';
Future<void> main(List<String> arguments) async {
  //arguments = debugArguments.split(' ');
  bool runFromLocal = false;
  if (arguments.isEmpty) {
    final File file = File(join('./', argumentsFile));
    if (file.existsSync()) {
      final String content = file.readAsStringSync();
      arguments = content.split(' ');
      runFromLocal = true;
    }
  }

  final Help help = Help();
  final Path path = Path();
  final Root root = Root();
  final Watch watch = Watch();
  final Type type = Type();
  final Save save = Save();
  final Output output = Output();
  final ArgResults results = parseArgs(arguments);
  if (arguments.isEmpty || help.value(results)) {
    print(green.wrap(parser.usage));
    return;
  }

  final PackageGraph packageGraph =
      await PackageGraph.forPath(path.value(results));

  final bool isWatch = watch.value(results);

  print('generate assets start');
  if (packageGraph != null) {
    final PackageNode rootNode = packageGraph.root;
    for (final PackageNode packageNode in packageGraph.allPackages.values.where(
      (PackageNode packageGraph) =>
          packageGraph.dependencyType == DependencyType.path &&
          packageGraph.path.startsWith(rootNode.path),
    )) {
      Generator(
        packageGraph: packageNode,
        rootName: root.value(results),
        formatType: type.type(type.value(results)),
        watch: isWatch,
        output: output.value(results),
      ).go();
    }
  }
  if (save.value(results) && !runFromLocal) {
    final File file = File(join('./', argumentsFile));
    if (!file.existsSync()) {
      file.createSync();
    }
    String argumentsS = '';
    for (final String item in arguments) {
      argumentsS += '$item ';
    }
    file.writeAsStringSync(argumentsS.trim());
  }
  if (!isWatch) {
    print('generate assets end');
  }
}
