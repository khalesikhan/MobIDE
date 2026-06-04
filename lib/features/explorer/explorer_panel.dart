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

final ProjectExplorerService explorerService =
ProjectExplorerService();

final FileOpenerService fileOpenerService =
FileOpenerService();

final FileService fileService =
FileService();

List<ProjectFile> files = [];

List<ProjectFile> filteredFiles = [];

final TextEditingController
    searchController =
        TextEditingController();

@override
void initState() {
super.initState();
loadProjectFiles();
}
@override
void dispose() {
  searchController.dispose();
  super.dispose();
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
  filteredFiles = result;
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
          hintText: 'example.dart',  
        ),  
      ),  
      actions: [  
        TextButton(  
          onPressed: () {  
            Navigator.pop(context);  
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

void filterFiles(
  String query,
) {
  if (query.trim().isEmpty) {
    setState(() {
      filteredFiles = files;
    });
    return;
  }

  final lowerQuery =
      query.toLowerCase();

  setState(() {
    filteredFiles = files.where(
      (file) {
        return file.name
            .toLowerCase()
            .contains(lowerQuery);
      },
    ).toList();
  });
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
          hintText: 'folder_name',  
        ),  
      ),  
      actions: [  
        TextButton(  
          onPressed: () {  
            Navigator.pop(context);  
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

Future<void> renameNode(
ProjectFile file,
) async {
final controller =
TextEditingController(
text: file.name,
);

final newName =  
    await showDialog<String>(  
  context: context,  
  builder: (context) {  
    return AlertDialog(  
      title: Text(  
        file.isDirectory  
            ? 'Rename Folder'  
            : 'Rename File',  
      ),  
      content: TextField(  
        controller: controller,  
        autofocus: true,  
      ),  
      actions: [  
        TextButton(  
          onPressed: () {  
            Navigator.pop(context);  
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
            'Rename',  
          ),  
        ),  
      ],  
    );  
  },  
);  

if (newName == null ||  
    newName.isEmpty ||  
    newName == file.name) {  
  return;  
}  

final parentPath =  
    file.path.substring(  
  0,  
  file.path.lastIndexOf('/'),  
);  

final newPath =  
    '$parentPath/$newName';  

await fileService.renamePath(  
  oldPath: file.path,  
  newPath: newPath,  
);  

await loadProjectFiles();

}
Future<void> deleteNode(
ProjectFile file,
) async {
final confirmed =
await showDialog<bool>(
context: context,
builder: (context) {
return AlertDialog(
title: const Text(
'Delete',
),
content: Text(
file.isDirectory
? 'Delete folder "${file.name}"?'
: 'Delete file "${file.name}"?',
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
'Delete',
),
),
],
);
},
);

if (confirmed != true) {  
  return;  
}  

await fileService.deletePath(  
  file.path,  
);  

await loadProjectFiles();

}
Future<void> createFileInFolder(
  ProjectFile folder,
) async {
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
            hintText: 'example.dart',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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
      '${folder.path}/$fileName';

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

Future<void> createFolderInFolder(
  ProjectFile folder,
) async {
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
            hintText: 'folder_name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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

  final path =
      '${folder.path}/$folderName';

  await fileService.createFolder(
    path,
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

Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
  ),
  child: TextField(
    controller: searchController,
    onChanged: filterFiles,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: const InputDecoration(
      hintText: 'Search...',
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      prefixIcon: Icon(
        Icons.search,
        color: Colors.white54,
      ),
      border: OutlineInputBorder(),
      isDense: true,
    ),
  ),
),
const SizedBox(
  height: 8,
),

Expanded(
child: ListView(
children:
filteredFiles
.map(buildNode).toList(),
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
      title: Row(
        children: [
          Expanded(
            child: Text(
              file.name,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 16,
              color: Colors.white54,
            ),
            tooltip: 'Rename',
            onPressed: () {
              renameNode(file);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 16,
              color: Colors.redAccent,
            ),
            tooltip: 'Delete',
            onPressed: () {
              deleteNode(file);
            },
          ),
          IconButton(
  icon: const Icon(
    Icons.note_add,
    size: 16,
    color: Colors.green,
  ),
  tooltip: 'New File',
  onPressed: () {
  createFileInFolder(file);
},
),
IconButton(
  icon: const Icon(
    Icons.create_new_folder,
    size: 16,
    color: Colors.lightGreen,
  ),
  tooltip: 'New Folder',
  onPressed: () {
    createFolderInFolder(file);
  },
),
        ],
      ),
      children: file.children
          .map(
            (child) => Padding(
              padding: const EdgeInsets.only(
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
    title: Row(
      children: [
        Expanded(
          child: Text(
            file.name,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
            size: 16,
            color: Colors.white54,
          ),
          tooltip: 'Rename',
          onPressed: () {
            renameNode(file);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            size: 16,
            color: Colors.redAccent,
          ),
          tooltip: 'Delete',
          onPressed: () {
            deleteNode(file);
          },
        ),
      ],
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