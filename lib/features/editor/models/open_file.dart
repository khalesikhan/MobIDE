class OpenFile {
  final String path;
  final String name;
  final String content;
  final bool isDirty;

  const OpenFile({
    required this.path,
    required this.name,
    required this.content,
    this.isDirty = false,
  });

  OpenFile copyWith({
    String? path,
    String? name,
    String? content,
    bool? isDirty,
  }) {
    return OpenFile(
      path: path ?? this.path,
      name: name ?? this.name,
      content: content ?? this.content,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}