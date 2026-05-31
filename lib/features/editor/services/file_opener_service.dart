import 'dart:io';

import '../models/open_file.dart';
import '../providers/editor_provider.dart';

class FileOpenerService {
  Future<void> openFile({
    required String path,
    required EditorProvider editorProvider,
  }) async {
    final file = File(path);

    if (!await file.exists()) {
      return;
    }

    final content = await file.readAsString();

    final openFile = OpenFile(
      path: path,
      name: path.split('/').last,
      content: content,
    );

    editorProvider.openFile(openFile);
  }
}