import 'dart:io';

class FileService {

  // Read File
  Future<String> readFile(String path) async {

    final file = File(path);

    return await file.readAsString();
  }

  // Write File
  Future<void> writeFile({
    required String path,
    required String content,
  }) async {

    final file = File(path);

    await file.writeAsString(content);
  }

  // List Directory
  Future<List<FileSystemEntity>> listDirectory(
    String path,
  ) async {

    final directory = Directory(path);

    return directory.listSync();
  }
}
