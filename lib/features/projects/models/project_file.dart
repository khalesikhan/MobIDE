class ProjectFile {
  final String path;
  final String name;
  final bool isDirectory;

  final List<ProjectFile> children;

  const ProjectFile({
    required this.path,
    required this.name,
    required this.isDirectory,
    this.children = const [],
  });

  ProjectFile copyWith({
    String? path,
    String? name,
    bool? isDirectory,
    List<ProjectFile>? children,
  }) {
    return ProjectFile(
      path: path ?? this.path,
      name: name ?? this.name,
      isDirectory: isDirectory ?? this.isDirectory,
      children: children ?? this.children,
    );
  }
}