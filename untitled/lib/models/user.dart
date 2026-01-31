class User {
  final int? id;
  final String username;
  final String email;
  final String? bio;
  final String? profileImage;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.bio,
    this.profileImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String?,
      profileImage: map['profileImage'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? bio,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}