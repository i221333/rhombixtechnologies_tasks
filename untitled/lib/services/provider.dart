import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/artwork.dart';
import '../models/comment.dart';
import '../services/database.dart';

class AppProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  User? _currentUser;
  List<Artwork> _artworks = [];
  List<User> _artists = [];
  bool _isLoading = false;

  // Sync state: These Sets prevent the "hot reload" requirement
  Set<int> _favoriteIds = {};
  Set<int> _followingIds = {};

  User? get currentUser => _currentUser;
  List<Artwork> get artworks => _artworks;
  List<User> get artists => _artists;
  bool get isLoading => _isLoading;

  // --- Authentication ---

  Future<bool> login(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _db.getUserByUsername(username);
      if (_currentUser == null) {
        final userId = await _db.createUser(User(
          username: username,
          email: '$username@artgallery.com',
          bio: 'Art enthusiast and creator',
        ));
        _currentUser = await _db.getUserById(userId);
      }

      // Load sync state after login
      if (_currentUser != null) {
        await _syncLocalState();
      }

      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _syncLocalState() async {
    if (_currentUser == null) return;
    final favs = await _db.getFavoriteArtworks(_currentUser!.id!);
    final following = await _db.getFollowing(_currentUser!.id!); // Ensure this exists in DB Helper

    _favoriteIds = favs.map((a) => a.id!).toSet();
    _followingIds = following.map((u) => u.id!).toSet();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _artworks = [];
    _favoriteIds.clear();
    _followingIds.clear();
    notifyListeners();
  }

  // --- Artworks ---

  Future<void> loadArtworks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _artworks = await _db.getAllArtworks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadArtworksByCategory(String category) async {
    _isLoading = true;
    notifyListeners();
    try {
      _artworks = await _db.getArtworksByCategory(category);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchArtworks(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (query.isEmpty) {
        _artworks = await _db.getAllArtworks();
      } else {
        _artworks = await _db.searchArtworks(query);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createArtwork({
    required String title,
    required String imagePath,
    String? description,
    required String category,
  }) async {
    if (_currentUser == null) return false;
    try {
      final artwork = Artwork(
        title: title,
        description: description,
        imagePath: imagePath,
        artistId: _currentUser!.id!,
        category: category,
      );
      await _db.createArtwork(artwork);
      await loadArtworks(); // Refresh list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> likeArtwork(int artworkId) async {
    try {
      await _db.likeArtwork(artworkId);
      // OPTIMISTIC UPDATE: Increment likes in memory immediately
      final index = _artworks.indexWhere((a) => a.id == artworkId);
      if (index != -1) {
        _artworks[index] = _artworks[index].copyWith(
          likes: _artworks[index].likes + 1,
        );
        notifyListeners();
      }
    } catch (e) { /* error handling */ }
  }

  Future<void> deleteArtwork(int artworkId) async {
    try {
      await _db.deleteArtwork(artworkId);
      _artworks.removeWhere((a) => a.id == artworkId);
      notifyListeners();
    } catch (e) { /* error handling */ }
  }

  // --- Favorites (FIXED for Hot Reload & Bool Error) ---

  // Synchronous check for UI (Resolves boolean type error)
  bool isFavorite(int artworkId) => _favoriteIds.contains(artworkId);

  Future<void> toggleFavorite(int artworkId) async {
    if (_currentUser == null) return;

    final wasFavorite = _favoriteIds.contains(artworkId);

    // 1. Instant UI Feedback
    if (wasFavorite) _favoriteIds.remove(artworkId);
    else _favoriteIds.add(artworkId);
    notifyListeners();

    try {
      // 2. Persistent Update
      if (wasFavorite) {
        await _db.removeFavorite(_currentUser!.id!, artworkId);
      } else {
        await _db.addFavorite(_currentUser!.id!, artworkId);
      }
    } catch (e) {
      // Rollback if DB fails
      if (wasFavorite) _favoriteIds.add(artworkId);
      else _favoriteIds.remove(artworkId);
      notifyListeners();
    }
  }

  Future<List<Artwork>> getFavorites() async {
    if (_currentUser == null) return [];
    return await _db.getFavoriteArtworks(_currentUser!.id!);
  }

  // --- Comments ---

  Future<List<Comment>> getComments(int artworkId) async {
    return await _db.getCommentsByArtwork(artworkId);
  }

  Future<void> addComment(int artworkId, String content) async {
    if (_currentUser == null) return;
    try {
      final comment = Comment(
        artworkId: artworkId,
        userId: _currentUser!.id!,
        content: content,
      );
      await _db.createComment(comment);
      notifyListeners(); // Refresh detail screen
    } catch (e) { /* error handling */ }
  }

  // --- Users/Artists ---

  Future<void> loadArtists() async {
    try {
      _artists = await _db.getAllUsers();
      notifyListeners();
    } catch (e) { /* error handling */ }
  }

  Future<User?> getUserById(int id) async => await _db.getUserById(id);

  Future<List<Artwork>> getArtistArtworks(int artistId) async {
    return await _db.getArtworksByArtist(artistId);
  }

  // Synchronous check for UI
  bool isFollowing(int artistId) => _followingIds.contains(artistId);

  Future<void> toggleFollow(int artistId) async {
    if (_currentUser == null) return;

    final wasFollowing = _followingIds.contains(artistId);

    // Instant UI Feedback
    if (wasFollowing) _followingIds.remove(artistId);
    else _followingIds.add(artistId);
    notifyListeners();

    try {
      if (wasFollowing) {
        await _db.unfollowUser(_currentUser!.id!, artistId);
      } else {
        await _db.followUser(_currentUser!.id!, artistId);
      }
    } catch (e) {
      if (wasFollowing) _followingIds.add(artistId);
      else _followingIds.remove(artistId);
      notifyListeners();
    }
  }

  // --- Update Profile ---

  Future<void> updateProfile({String? bio, String? profileImage}) async {
    if (_currentUser == null) return;
    try {
      final updatedUser = _currentUser!.copyWith(
        bio: bio,
        profileImage: profileImage,
      );
      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) { /* error handling */ }
  }
}