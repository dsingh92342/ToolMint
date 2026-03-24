class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isSynced;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      isSynced: true,
    );
  }
}
