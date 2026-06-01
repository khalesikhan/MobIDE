import 'package:flutter/material.dart';

import '../projects/models/project_file.dart';
import '../projects/project_explorer_service.dart';
import '../editor/services/file_opener_service.dart';

class ExplorerPanel extends StatefulWidget {
  const ExplorerPanel({super.key});

  @override
  State<ExplorerPanel> createState() =>
      _ExplorerPanelState();
}

class _ExplorerPanelState
    extends State<ExplorerPanel> {
  final ProjectExplorerService
      explorerService =
      ProjectExplorerService();

  final FileOpenerService
      fileOpenerService =
      FileOpenerService();

  List<ProjectFile> files = [];

  @override
  void initState() {
    super.initState();

    loadProjectFiles();
  }

  Future<void> loadProjectFiles() async {
    final result =
        await explorerService.loadFiles(
      '/storage/emulated/0/FlutterProjects/MobIDE/lib',
    );

    setState(() {
      files = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF252526),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'EXPLORER',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children:
                  files.map((file) {
                return buildNode(file);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNode(
    ProjectFile file,
  ) {
    if (file.isDirectory) {
      return ExpansionTile(
        title: Text(
          file.name,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        leading: const Icon(
          Icons.folder,
          color: Colors.amber,
        ),

        children:
            file.children.map((child) {
          return Padding(
            padding:
                const EdgeInsets.only(
              left: 12,
            ),
            child: buildNode(child),
          );
        }).toList(),
      );
    }

    return ListTile(
      dense: true,

      leading: const Icon(
        Icons.insert_drive_file,
        color: Colors.lightBlue,
      ),

      title: Text(
        file.name,
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),

      onTap: () {
        fileOpenerService.openFile(
          file.path,
        );
      },
    );
  }
}