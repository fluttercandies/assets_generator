import 'package:args/args.dart';

final ArgParser parser = ArgParser();

ArgResults parseArgs(List<String> args) {
  return parser.parse(args);
}
