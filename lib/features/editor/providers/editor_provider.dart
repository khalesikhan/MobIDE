import 'package:flutter/foundation.dart';

import '../models/open_file.dart';
import '../../../shared/services/file_service.dart';

class EditorProvider extends ChangeNotifier {
  final List<OpenFile> _openFiles = [];
  final FileService _fileService = FileService();

  int _activeIndex = -1;

  List<OpenFile> get openFiles => _openFiles;

  int get activeIndex => _activeIndex;

  OpenFile? get activeFile {
    if (_activeIndex < 0 || _activeIndex >= _openFiles.length) {
      return null;
    }

    return _openFiles[_activeIndex];
  }

  void openFile(OpenFile file) {
    final existingIndex = _openFiles.indexWhere(
      (f) => f.path == file.path,
    );

    if (existingIndex != -1) {
      _activeIndex = existingIndex;
      notifyListeners();
      return;
    }

    _openFiles.add(file);
    _activeIndex = _openFiles.length - 1;

    notifyListeners();
  }

  void setActiveTab(int index) {
    if (index < 0 || index >= _openFiles.length) {
      return;
    }

    _activeIndex = index;
    notifyListeners();
  }

  void closeTab(int index) {
    if (index < 0 || index >= _openFiles.length) {
      return;
    }

    _openFiles.removeAt(index);

    if (_openFiles.isEmpty) {
      _activeIndex = -1;
    } else if (_activeIndex >= _openFiles.length) {
      _activeIndex = _openFiles.length - 1;
    }

    notifyListeners();
  }
  
  void closeAllTabs() {
  _openFiles.clear();

  _activeIndex = -1;

  notifyListeners();
}

  bool isTabDirty(int index) {
    if (index < 0 || index >= _openFiles.length) {
      return false;
    }

    return _openFiles[index].isDirty;
  }
   
   bool hasDirtyFiles() {
  return _openFiles.any(
    (file) => file.isDirty,
  );
}
   
  void updateContent(String content) {
    if (_activeIndex < 0 || _activeIndex >= _openFiles.length) {
      return;
    }

    final current = _openFiles[_activeIndex];

    _openFiles[_activeIndex] = current.copyWith(
      content: content,
      isDirty: true,
    );

    notifyListeners();
  }

  Future<void> saveCurrentFile() async {
    if (_activeIndex < 0 || _activeIndex >= _openFiles.length) {
      return;
    }

    final current = _openFiles[_activeIndex];

    await _fileService.writeFile(
      path: current.path,
      content: current.content,
    );

    _openFiles[_activeIndex] = current.copyWith(isDirty: false);

    notifyListeners();
  }
  
  Future<void> saveAllFiles() async {
  for (int i = 0; i < _openFiles.length; i++) {
    final file = _openFiles[i];

    await _fileService.writeFile(
      path: file.path,
      content: file.content,
    );

    _openFiles[i] = file.copyWith(
      isDirty: false,
    );
  }

  notifyListeners();
}
  
  void markSaved() {
    if (_activeIndex < 0 || _activeIndex >= _openFiles.length) {
      return;
    }

    final current = _openFiles[_activeIndex];

    _openFiles[_activeIndex] = current.copyWith(isDirty: false);

    notifyListeners();
  }
}