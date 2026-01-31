class Artwork {
  final int? id;
  final String title;
  final String? description;
  final String imagePath;
  final int artistId;
  final String category;
  final int likes;
  final DateTime createdAt;

  Artwork({
    this.id,
    required this.title,
    this.description,
    required this.imagePath,
    required this.artistId,
    required this.category,
    this.likes = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'artistId': artistId,
      'category': category,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String,
      artistId: map['artistId'] as int,
      category: map['category'] as String,
      likes: map['likes'] as int? ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Artwork copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    int? artistId,
    String? category,
    String? medium,
    int? likes,
    DateTime? createdAt,
  }) {
    return Artwork(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      artistId: artistId ?? this.artistId,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}