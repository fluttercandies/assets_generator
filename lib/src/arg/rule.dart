import 'arg.dart';
import 'arg_parser.dart';

class Rule extends Argument {
  @override
  String get abbr => 'r';

  @override
  dynamic get defaultsTo => 'lwu';

  @override
  String get help =>
      'The rule for the names of assets\' consts\n"lwu"(lowercase_with_underscores) : "assets_images_xxx_jpg" \n"uwu"(uppercase_with_underscores) : "ASSETS_IMAGES_XXX_JPG" \n"lcc"(lowerCamelCase)             : "assetsImagesXxxJpg" \n';

  @override
  String get name => 'rule';

  @override
  String get value {
    if (argResults.wasParsed(name)) {
      return argResults[name] as String;
    }

    return defaultsTo as String;
  }

  String go(String input) {
    //uppercase_with_underscores
    if (value == 'uwu') {
      return input.toUpperCase();
    }
    //lowerCamelCase
    else if (value == 'lcc') {
      return input.replaceAllMapped(RegExp(r'_([A-z])'), (Match match) {
        return match.group(0).replaceAll('_', '').toUpperCase();
      }).replaceAll('_', '');
    }
    //lowercase_with_underscores
    else {
      return input.toLowerCase();
    }
  }
}

void regExpTest() {
  // const String string = '{name : aName, hobby : [fishing, playing_guitar]}';
  // final String newString =
  //     string.replaceAllMapped(RegExp(r'\b\w+\b'), (Match match) {
  //   return '"${match.group(0)}"';
  // });

  // //{"name" : "aName", "hobby" : ["fishing", "playing_guitar"]}
  // print(newString);

  // const String string = 'assets_images_xxx_jpg';

  // final String newString =
  //     string.replaceAllMapped(RegExp('_([A-z])'), (Match match) {
  //   return match.group(0).replaceAll('_', '').toUpperCase();
  // });

  // //assetsImagesXxxJpg
  // print(newString);

  const String string = 'assetsImagesXxxJpg';

  final String newString =
      string.replaceAllMapped(RegExp('([a-z])([A-Z])'), (Match match) {
    return match.group(0)[0] + '_' + match.group(0)[1].toLowerCase();
  });

  // assets_images_xxx_jpg
  print(newString);
}
