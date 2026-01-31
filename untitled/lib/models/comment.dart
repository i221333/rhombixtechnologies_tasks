class Comment {
  final int? id;
  final int artworkId;
  final int userId;
  final String content;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.artworkId,
    required this.userId,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artworkId': artworkId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      artworkId: map['artworkId'] as int,
      userId: map['userId'] as int,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}