import 'package:flutter/material.dart';

class EditorTabs extends StatelessWidget {
  const EditorTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: const Color(0xFF2D2D2D),

      child: ListView(
        scrollDirection: Axis.horizontal,

        children: [

          _buildTab(
            name: 'main.dart',
            isActive: true,
          ),

          _buildTab(
            name: 'home_screen.dart',
          ),

          _buildTab(
            name: 'app_theme.dart',
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String name,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF2D2D2D),

        border: Border(
          right: BorderSide(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.insert_drive_file,
            size: 16,
            color: Colors.lightBlue,
          ),

          const SizedBox(width: 8),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.close,
            size: 16,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
