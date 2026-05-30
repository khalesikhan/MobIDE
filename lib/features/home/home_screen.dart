import 'dart:async';

import 'package:flutter/material.dart';

import '../explorer/explorer_panel.dart';
import '../editor/widgets/editor_tabs.dart';
import '../editor/widgets/code_editor.dart';
import '../editor/services/open_files_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int lastVersion = 0;

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    refreshTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {

        if (lastVersion !=
            OpenFilesManager.version) {

          setState(() {

            lastVersion =
                OpenFilesManager.version;
          });
        }
      },
    );
  }

  @override
  void dispose() {

    refreshTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF1E1E1E),

      body: SafeArea(
        child: Column(
          children: [

            // Top Bar
            Container(
              height: 50,
              color:
                  const Color(0xFF252526),

              child: Row(
                children: const [

                  SizedBox(width: 16),

                  Icon(
                    Icons.code,
                    color:
                        Color(0xFF3794FF),
                  ),

                  SizedBox(width: 10),

                  Text(
                    'MobIDE',

                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [

                  // Activity Bar
                  Container(
                    width: 70,
                    color:
                        const Color(
                            0xFF333333),

                    child: Column(
                      children: const [

                        SizedBox(height: 20),

                        Icon(
                          Icons.folder,
                          color:
                              Colors.white,
                        ),

                        SizedBox(height: 20),

                        Icon(
                          Icons.search,
                          color: Colors
                              .white70,
                        ),

                        SizedBox(height: 20),

                        Icon(
                          Icons.code,
                          color: Colors
                              .white70,
                        ),

                        SizedBox(height: 20),

                        Icon(
                          Icons.settings,
                          color: Colors
                              .white70,
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
                          child:
                              CodeEditor(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 40,
              color:
                  const Color(0xFF007ACC),

              child: Row(
                children: const [

                  SizedBox(width: 16),

                  Text(
                    'Dart',

                    style: TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),

                  Spacer(),

                  Text(
                    'UTF-8',

                    style: TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),

                  SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}