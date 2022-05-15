// ignore_for_file: avoid_print

import 'package:dart_style/dart_style.dart';
import 'package:io/ansi.dart';

final DartFormatter _formatter = DartFormatter();

String formatDart(String input) {
  try {
    return _formatter.format(input);
  } catch (e) {
    print(red.wrap(e.toString()));
  }
  return input;
}
