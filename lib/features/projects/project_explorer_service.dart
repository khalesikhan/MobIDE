import 'dart:io';

import 'models/project_file.dart';

class ProjectExplorerService {
  Future<List<ProjectFile>> loadFiles(
    String directoryPath,
  ) async {
    final directory = Directory(
      directoryPath,
    );

    if (!await directory.exists()) {
      return [];
    }

    return _loadDirectory(
      directory,
    );
  }

  List<ProjectFile> _loadDirectory(
    Directory directory,
  ) {
    final entities =
        directory.listSync().toList();

    entities.sort(
      (a, b) {
        final aDir = a is Directory;
        final bDir = b is Directory;

        if (aDir && !bDir) {
          return -1;
        }

        if (!aDir && bDir) {
          return 1;
        }

        final aName =
            a.path.split('/').last.toLowerCase();

        final bName =
            b.path.split('/').last.toLowerCase();

        return aName.compareTo(
          bName,
        );
      },
    );

    return entities.map((entity) {
      final name =
          entity.path.split('/').last;

      if (entity is Directory) {
        return ProjectFile(
          path: entity.path,
          name: name,
          isDirectory: true,
          children: _loadDirectory(
            entity,
          ),
        );
      }

      return ProjectFile(
        path: entity.path,
        name: name,
        isDirectory: false,
      );
    }).toList();
  }
}