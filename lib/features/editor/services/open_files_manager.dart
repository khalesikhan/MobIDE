import '../models/open_file.dart';

class OpenFilesManager {

  static final List<OpenFile> openFiles = [];

  static OpenFile? activeFile;

  static int version = 0;

  static void openFile(OpenFile file) {

    final exists = openFiles.any(
      (item) => item.path == file.path,
    );

    if (!exists) {
      openFiles.add(file);
    }

    activeFile = file;

    version++;
  }

  static void closeFile(String path) {

    openFiles.removeWhere(
      (file) => file.path == path,
    );

    if (activeFile?.path == path) {

      activeFile =
          openFiles.isNotEmpty
              ? openFiles.first
              : null;
    }

    version++;
  }
}