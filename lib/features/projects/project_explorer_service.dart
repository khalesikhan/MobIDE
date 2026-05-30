import 'dart:io';

import 'models/project_file.dart';

class ProjectExplorerService {

  Future<List<ProjectFile>> loadFiles(
    String directoryPath,
  ) async {

    final directory = Directory(directoryPath);

    final entities = directory.listSync();

    return entities.map((entity) {

      final name =
          entity.path.split('/').last;

      return ProjectFile(
        path: entity.path,
        name: name,
        isDirectory: entity is Directory,
      );

    }).toList();
  }
}
