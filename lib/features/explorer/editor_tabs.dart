import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/editor_provider.dart';

class EditorTabs extends StatelessWidget {
  const EditorTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final editorProvider =
        context.watch<EditorProvider>();

    final files = editorProvider.openFiles;

    return Container(
      height: 40,
      color: const Color(0xFF2D2D2D),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,

        itemBuilder: (context, index) {
          final file = files[index];

          return _buildTab(
            context: context,
            index: index,
            name: file.isDirty
                ? '${file.name} *'
                : file.name,
            isActive:
                editorProvider.activeIndex ==
                index,
          );
        },
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required int index,
    required String name,
    required bool isActive,
  }) {
    final editorProvider =
        context.read<EditorProvider>();

    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF2D2D2D),

        border: Border(
          right: BorderSide(
            color:
                Colors.black.withOpacity(0.3),
          ),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              editorProvider.setActiveTab(
                index,
              );
            },

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    size: 16,
                    color:
                        Colors.lightBlue,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    name,
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () async {
  if (editorProvider.isTabDirty(
    index,
  )) {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Unsaved Changes',
          ),
          content: const Text(
            'Close without saving?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
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
                  true,
                );
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }
  }

  editorProvider.closeTab(
    index,
  );
},

            child: const Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 8,
              ),

              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}