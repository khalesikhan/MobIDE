import 'dart:io';

class FileService {
  // Read File
  Future<String> readFile(
    String path,
  ) async {
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
  Future<File> createFile(
    String path,
  ) async {
    final file = File(path);

    return await file.create(
      recursive: true,
    );
  }

  // Create Folder
  Future<Directory> createFolder(
    String path,
  ) async {
    final directory = Directory(path);

    return await directory.create(
      recursive: true,
    );
  }

  // Rename File/Folder
  Future<FileSystemEntity> renamePath({
    required String oldPath,
    required String newPath,
  }) async {
    final type =
        FileSystemEntity.typeSync(
      oldPath,
    );

    if (type ==
        FileSystemEntityType.directory) {
      return await Directory(
        oldPath,
      ).rename(
        newPath,
      );
    }

    return await File(
      oldPath,
    ).rename(
      newPath,
    );
  }

  // Delete File/Folder
  Future<void> deletePath(
    String path,
  ) async {
    final type =
        FileSystemEntity.typeSync(
      path,
    );

    if (type ==
        FileSystemEntityType.directory) {
      await Directory(path).delete(
        recursive: true,
      );
      return;
    }

    await File(path).delete();
  }

  // List Directory
  Future<List<FileSystemEntity>>
      listDirectory(
    String path,
  ) async {
    final directory = Directory(
      path,
    );

    return directory.listSync();
  }
}