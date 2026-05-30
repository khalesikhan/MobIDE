import 'package:flutter/material.dart';

import '../services/open_files_manager.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();

    loadActiveFile();
  }

  void loadActiveFile() {
    final activeFile =
        OpenFilesManager.activeFile;

    controller.text =
        activeFile?.content ??
        '// No file opened';
  }

  @override
  Widget build(BuildContext context) {

    loadActiveFile();

    return Container(
      color: const Color(0xFF1E1E1E),

      child: TextField(
        controller: controller,

        expands: true,
        maxLines: null,
        minLines: null,

        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          fontFamily: 'monospace',
        ),

        cursorColor: Colors.blue,

        decoration: const InputDecoration(
          border: InputBorder.none,

          contentPadding:
              EdgeInsets.all(12),
        ),
      ),
    );
  }
}