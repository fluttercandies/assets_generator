import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart';

typedef AssetsChanged = void Function();

class Watcher {
  Watcher(this.dirList, this.assetsChanged);

  Watcher.single(Directory dir, this.assetsChanged)
      : dirList = <Directory>[dir];

  /// all of the directory with yaml.
  final List<Directory> dirList;

  final AssetsChanged assetsChanged;

  bool _watching = false;

  /// when the directory is change
  /// refresh the code
  StreamSubscription<FileSystemEvent> _watch(FileSystemEntity file) {
    if (FileSystemEntity.isWatchSupported) {
      return file.watch().listen((FileSystemEvent data) {
        if (data.isDirectory) {
          final Directory directory = Directory(data.path);

          if (data.type == FileSystemEvent.delete) {
            if (watchMap.containsKey(directory)) {
              watchMap[watchMap].cancel();
            }
            dirList.remove(directory);
          }
          //empty directory
          else if (directory.listSync().isEmpty) {
            return;
          }
          //watch new directory
          else {
            _watch(directory);
            dirList.add(directory);
          }
        }
        String msg;
        switch (data.type) {
          case FileSystemEvent.create:
            msg = green.wrap('create');
            break;
          case FileSystemEvent.delete:
            msg = red.wrap('delete');
            break;
          case FileSystemEvent.move:
            msg = yellow.wrap('move');
            break;
          case FileSystemEvent.modify:
            break;
          case FileSystemEvent.all:
            msg = yellow.wrap('operate');
            break;
          default:
        }
        if (msg != null) {
          print('\n$msg ${data.path}.\n');
          assetsChanged?.call();
        }
      });
    }
    return null;
  }

  /// watch all of path
  Future<void> startWatch() async {
    if (_watching) {
      return;
    }
    _watching = true;
    for (final Directory dir in dirList) {
      final StreamSubscription<FileSystemEvent> sub = _watch(dir);
      if (sub != null) {
        sub.onDone(sub.cancel);
      }
      watchMap[dir] = sub;
    }

    print('watching ${dirList.first.path} !\n');
    //print('For a more detailed help message, press "-h". To quit, press "-q".');
  }

  void stopWatch() {
    _watching = false;
    for (final StreamSubscription<FileSystemEvent> v in watchMap.values) {
      v.cancel();
    }

    watchMap.clear();
  }

  Map<FileSystemEntity, StreamSubscription<FileSystemEvent>> watchMap =
      <FileSystemEntity, StreamSubscription<FileSystemEvent>>{};

  void removeAllWatches() {
    for (final StreamSubscription<FileSystemEvent> sub in watchMap.values) {
      sub?.cancel();
    }
  }
}
