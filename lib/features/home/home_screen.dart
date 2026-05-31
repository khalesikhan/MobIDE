import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../editor/providers/editor_provider.dart';
import '../editor/widgets/code_editor.dart';
import '../editor/widgets/editor_tabs.dart';
import '../explorer/explorer_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditorProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Container(
                height: 50,
                color: const Color(0xFF252526),
                child: Consumer<EditorProvider>(
                  builder: (
                    context,
                    editorProvider,
                    child,
                  ) {
                    return Row(
                      children: [
                        const SizedBox(width: 16),

                        const Icon(
                          Icons.code,
                          color: Color(0xFF3794FF),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          'MobIDE',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          tooltip: 'Save File',
                          onPressed: () async {
                            await editorProvider
                                .saveCurrentFile();

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'File saved',
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 8),
                      ],
                    );
                  },
                ),
              ),

              Expanded(
                child: Row(
                  children: [
                    // Activity Bar
                    Container(
                      width: 70,
                      color: const Color(0xFF333333),
                      child: Column(
                        children: const [
                          SizedBox(height: 20),

                          Icon(
                            Icons.folder,
                            color: Colors.white,
                          ),

                          SizedBox(height: 20),

                          Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),

                          SizedBox(height: 20),

                          Icon(
                            Icons.code,
                            color: Colors.white70,
                          ),

                          SizedBox(height: 20),

                          Icon(
                            Icons.settings,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),

                    const ExplorerPanel(),

                    Expanded(
                      child: Column(
                        children: const [
                          EditorTabs(),

                          Expanded(
                            child: CodeEditor(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //