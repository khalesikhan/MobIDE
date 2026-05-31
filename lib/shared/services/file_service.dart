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

  // Create File
  Future<File> createFile(String path) async {
    final file = File(path);

    return await file.create(recursive: true);
  }

  // Create Folder
  Future<Directory> createFolder(String path) async {
    final directory = Directory(path);

    return await directory.create(recursive: true);
  }

  // List Directory
  Future<List<FileSystemEntity>> listDirectory(
    String path,
  ) async {
    final directory = Directory(path);

    return directory.listSync();
  }
}