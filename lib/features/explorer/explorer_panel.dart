import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/file_service.dart';
import '../editor/providers/editor_provider.dart';
import '../editor/services/file_opener_service.dart';
import '../projects/models/project_file.dart';
import '../projects/project_explorer_service.dart';

class ExplorerPanel extends StatefulWidget {
  const ExplorerPanel({super.key});

  @override
  State<ExplorerPanel> createState() =>
      _ExplorerPanelState();
}

class _ExplorerPanelState
    extends State<ExplorerPanel> {
  static const String projectRoot =
      '/storage/emulated/0/FlutterProjects/MobIDE/lib';

  final ProjectExplorerService
      explorerService =
      ProjectExplorerService();

  final FileOpenerService
      fileOpenerService =
      FileOpenerService();

  final FileService fileService =
      FileService();

  List<ProjectFile> files = [];

  @override
  void initState() {
    super.initState();
    loadProjectFiles();
  }

  Future<void> loadProjectFiles() async {
    final result =
        await explorerService.loadFiles(
      projectRoot,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      files = result;
    });
  }

  Future<void> createNewFile() async {
    final controller =
        TextEditingController();

    final fileName =
        await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'New File',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration:
                const InputDecoration(
              hintText:
                  'example.dart',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: const Text(
                'Create',
              ),
            ),
          ],
        );
      },
    );

    if (fileName == null ||
        fileName.isEmpty) {
      return;
    }

    final path =
        '$projectRoot/$fileName';

    await fileService.createFile(
      path,
    );

    await loadProjectFiles();

    await fileOpenerService.openFile(
      path: path,
      editorProvider:
          context.read<EditorProvider>(),
    );
  }

  Future<void> createNewFolder() async {
    final controller =
        TextEditingController();

    final folderName =
        await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'New Folder',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration:
                const InputDecoration(
              hintText:
                  'folder_name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: const Text(
                'Create',
              ),
            ),
          ],
        );
      },
    );

    if (folderName == null ||
        folderName.isEmpty) {
      return;
    }

    await fileService.createFolder(
      '$projectRoot/$folderName',
    );

    await loadProjectFiles();
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
          Padding(
            padding:
                const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'EXPLORER',
                    style: TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color:
                        Colors.white70,
                    size: 18,
                  ),
                  tooltip: 'New File',
                  onPressed:
                      createNewFile,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.create_new_folder,
                    color:
                        Colors.white70,
                    size: 18,
                  ),
                  tooltip:
                      'New Folder',
                  onPressed:
                      createNewFolder,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color:
                        Colors.white70,
                    size: 18,
                  ),
                  tooltip: 'Refresh',
                  onPressed:
                      loadProjectFiles,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children:
                  files.map(buildNode).toList(),
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
        leading: const Icon(
          Icons.folder,
          color: Colors.amber,
        ),
        title: Text(
          file.name,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        children: file.children
            .map(
              (child) => Padding(
                padding:
                    const EdgeInsets.only(
                  left: 12,
                ),
                child: buildNode(child),
              ),
            )
            .toList(),
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
      onTap: () async {
        await fileOpenerService.openFile(
          path: file.path,
          editorProvider:
              context.read<EditorProvider>(),
        );
      },
    );
  }
}