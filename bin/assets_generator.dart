// ignore_for_file: avoid_print

import 'dart:io';
import 'package:assets_generator/assets_generator.dart';
import 'package:assets_generator/src/arg/root_package.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart';

const String argumentsFile = 'assets_generator_arguments';
const String debugArguments = '-p example/ -t f --const-ignore .md';
Future<void> main(List<String> arguments) async {
  //arguments = debugArguments.split(' ');
  //regExpTest();
  bool runFromLocal = false;
  // debug
  // ignore: dead_code
  if (false) {
    final File file = File(join('example', argumentsFile));
    if (file.existsSync()) {
      final String content = file.readAsStringSync() + ' -p example';
      arguments = content.split(' ').map((String e) => e.trim()).toList();
      runFromLocal = true;
    }
  }
  if (arguments.isEmpty) {
    final File file = File(join('./', argumentsFile));
    if (file.existsSync()) {
      final String content = file.readAsStringSync();
      arguments = content.split(' ').map((String e) => e.trim()).toList();
      runFromLocal = true;
    }
  }

  final Help help = Help();
  final Path path = Path();
  final Folder folder = Folder();
  final Watch watch = Watch();
  final Type type = Type();
  final Save save = Save();
  final Output output = Output();
  final Rule rule = Rule();
  final Class class1 = Class();
  final ConstIgnore constIgnore = ConstIgnore();
  final ConstArray constArray = ConstArray();
  final FolderIgnore folderIgnore = FolderIgnore();
  final Package package = Package();
  final ClassPrefix classPrefix = ClassPrefix();
  final GSuffix gSuffix = GSuffix();
  final PackageIgnore packageIgnore = PackageIgnore();
  final UseKeyName useKeyNameFlag = UseKeyName();
  final RootPackage rootPackage = RootPackage();

  parseArgs(arguments);
  if (arguments.isEmpty || help.value!) {
    print(green.wrap(parser.usage));
    return;
  }
  RegExp? folderIgnoreRegExp;
  if (packageIgnore.value != null) {
    folderIgnoreRegExp = RegExp(packageIgnore.value!);
  }

  final PackageGraph packageGraph = path.value != null
      ? await PackageGraph.forPath(path.value!)
      : await PackageGraph.forThisPackage();

  final bool isWatch = watch.value!;

  print('generate assets start');

  final PackageNode rootNode = packageGraph.root;
  for (final PackageNode packageNode in packageGraph.allPackages.values.where(
    (PackageNode packageGraph) =>
        packageGraph.dependencyType == DependencyType.path &&
        packageGraph.path.startsWith(rootNode.path),
  )) {
    if (folderIgnoreRegExp != null &&
        folderIgnoreRegExp.hasMatch(packageNode.name)) {
      continue;
    }
    Generator(
      packageGraph: packageNode,
      folder: folder.value,
      formatType: type.type(type.value),
      watch: isWatch,
      output: output.value,
      rule: rule,
      class1: class1,
      constIgnore:
          constIgnore.value != null ? RegExp(constIgnore.value!) : null,
      constArray: constArray.value,
      folderIgnore:
          folderIgnore.value != null ? RegExp(folderIgnore.value!) : null,
      package: package.value ?? false,
      useKeyName: useKeyNameFlag.value ?? false,
      classPrefix: classPrefix.value ?? false,
      gSuffix: gSuffix.value ?? false,
      rootPackageName: rootPackage.value,
    ).go();
  }

  if (save.value! && !runFromLocal) {
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
