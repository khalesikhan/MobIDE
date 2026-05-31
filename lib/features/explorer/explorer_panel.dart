import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../projects/models/project_file.dart';
import '../projects/project_explorer_service.dart';

import '../editor/services/file_opener_service.dart';
import '../editor/providers/editor_provider.dart';

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

    final editorProvider =
        Provider.of<EditorProvider>(
      context,
      listen: false,
    );

    return Container(
      width: 220,
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
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: files.length,

              itemBuilder:
                  (context, index) {

                final file =
                    files[index];

                return ListTile(
                  leading: Icon(
                    file.isDirectory
                        ? Icons.folder
                        : Icons
                            .insert_drive_file,
                    color:
                        file.isDirectory
                            ? Colors.amber
                            : Colors
                                .lightBlue,
                  ),

                  title: Text(
                    file.name,
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),

                  onTap