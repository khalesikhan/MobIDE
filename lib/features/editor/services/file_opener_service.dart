import 'dart:io';

import '../models/open_file.dart';
import 'open_files_manager.dart';

class FileOpenerService {

  Future<void> openFile(
    String path,
  ) async {

    final file = File(path);

    if (!await file.exists()) {
      return;
    }

    final content =
        await file.readAsString();

    final openFile = OpenFile(
      path: path,
      name: path.split('/').last,
      content: content,
    );

    OpenFilesManager.openFile(
      openFile,
    );
  }
}
