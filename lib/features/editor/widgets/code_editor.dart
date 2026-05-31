import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/editor_provider.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  final TextEditingController controller =
      TextEditingController();

  String currentPath = '';

  @override
  Widget build(BuildContext context) {
    final editorProvider =
        context.watch<EditorProvider>();

    final activeFile =
        editorProvider.activeFile;

    if (activeFile == null) {
      return Container(
        color: const Color(0xFF1E1E1E),
        child: const Center(
          child: Text(
            'No file opened',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      );
    }

    if (currentPath != activeFile.path) {
      currentPath = activeFile.path;

      controller.text = activeFile.content;

      controller.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: controller.text.length,
        ),
      );
    }

    return Container(
      color: const Color(0xFF1E1E1E),

      child: TextField(
        controller: controller,

        expands: true,
        minLines: null,
        maxLines: null,

        onChanged: (value) {
          editorProvider.updateContent(value);
        },

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