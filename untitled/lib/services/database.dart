import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/artwork.dart';
import '../models/comment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('art_gallery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType,
        email $textType,
        bio TEXT,
        profileImage TEXT,
        createdAt $textType
      )
    ''');

    // Artworks table
    await db.execute('''
      CREATE TABLE artworks (
        id $idType,
        title $textType,
        description TEXT,
        imagePath $textType,
        artistId $intType,
        category $textType,
        medium $textType,
        likes $intType,
        createdAt $textType,
        FOREIGN KEY (artistId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Comments table
    await db.execute('''
      CREATE TABLE comments (
        id $idType,
        artworkId $intType,
        userId $intType,
        content $textType,
        createdAt $textType,
        FOREIGN KEY (artworkId) REFERENCES artworks (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id $idType,
        userId $intType,
        artworkId $intType,
        createdAt $textType,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (artworkId) REFERENCES artworks (id) ON DELETE CASCADE
      )
    ''');

    // Follows table
    await db.execute('''
      CREATE TABLE follows (
        id $idType,
        followerId $intType,
        followingId $intType,
        createdAt $textType,
        FOREIGN KEY (followerId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (followingId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // User CRUD operations
  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'username ASC');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Artwork CRUD operations
  Future<int> createArtwork(Artwork artwork) async {
    final db = await database;
    return await db.insert('artworks', artwork.toMap());
  }

  Future<Artwork?> getArtworkById(int id) async {
    final db = await database;
    final maps = await db.query(
      'artworks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Artwork.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Artwork>> getAllArtworks() async {
    final db = await database;
    final result = await db.query('artworks', orderBy: 'createdAt DESC');
    return result.map((map) => Artwork.fromMap(map)).toList();
  }

  Future<List<Artwork>> getArtworksByArtist(int artistId) async {
    final db = await database;
    final result = await db.query(
      'artworks',
      where: 'artistId = ?',
      whereArgs: [artistId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Artwork.fromMap(map)).toList();
  }

  Future<List<Artwork>> searchArtworks(String query) async {
    final db = await database;
    final result = await db.query(
      'artworks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Artwork.fromMap(map)).toList();
  }

  Future<List<Artwork>> getArtworksByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'artworks',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Artwork.fromMap(map)).toList();
  }

  Future<int> updateArtwork(Artwork artwork) async {
    final db = await database;
    return await db.update(
      'artworks',
      artwork.toMap(),
      where: 'id = ?',
      whereArgs: [artwork.id],
    );
  }

  Future<int> deleteArtwork(int id) async {
    final db = await database;
    return await db.delete(
      'artworks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> likeArtwork(int artworkId) async {
    final db = await database;
    final artwork = await getArtworkById(artworkId);
    if (artwork != null) {
      return await db.rawUpdate(
        'UPDATE artworks SET likes = likes + 1 WHERE id = ?',
        [artworkId],
      );
    }
    return 0;
  }

  // Comment operations
  Future<int> createComment(Comment comment) async {
    final db = await database;
    return await db.insert('comments', comment.toMap());
  }

  Future<List<Comment>> getCommentsByArtwork(int artworkId) async {
    final db = await database;
    final result = await db.query(
      'comments',
      where: 'artworkId = ?',
      whereArgs: [artworkId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Comment.fromMap(map)).toList();
  }

  Future<int> deleteComment(int id) async {
    final db = await database;
    return await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Favorites operations
  Future<int> addFavorite(int userId, int artworkId) async {
    final db = await database;
    return await db.insert('favorites', {
      'userId': userId,
      'artworkId': artworkId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> removeFavorite(int userId, int artworkId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'userId = ? AND artworkId = ?',
      whereArgs: [userId, artworkId],
    );
  }

  Future<bool> isFavorite(int userId, int artworkId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'userId = ? AND artworkId = ?',
      whereArgs: [userId, artworkId],
    );
    return result.isNotEmpty;
  }

  Future<List<Artwork>> getFavoriteArtworks(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT artworks.* FROM artworks
      INNER JOIN favorites ON artworks.id = favorites.artworkId
      WHERE favorites.userId = ?
      ORDER BY favorites.createdAt DESC
    ''', [userId]);
    return result.map((map) => Artwork.fromMap(map)).toList();
  }

  // Follow operations
  Future<int> followUser(int followerId, int followingId) async {
    final db = await database;
    return await db.insert('follows', {
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> unfollowUser(int followerId, int followingId) async {
    final db = await database;
    return await db.delete(
      'follows',
      where: 'followerId = ? AND followingId = ?',
      whereArgs: [followerId, followingId],
    );
  }

  Future<bool> isFollowing(int followerId, int followingId) async {
    final db = await database;
    final result = await db.query(
      'follows',
      where: 'followerId = ? AND followingId = ?',
      whereArgs: [followerId, followingId],
    );
    return result.isNotEmpty;
  }

  Future<List<User>> getFollowers(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT users.* FROM users
      INNER JOIN follows ON users.id = follows.followerId
      WHERE follows.followingId = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<List<User>> getFollowing(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT users.* FROM users
      INNER JOIN follows ON users.id = follows.followingId
      WHERE follows.followerId = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}