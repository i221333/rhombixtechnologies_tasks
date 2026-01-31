import '../services/database.dart';
import '../models/user.dart';
import '../models/artwork.dart';
import '../models/comment.dart';

/// Utility class to seed the database with sample data for testing
/// Call SampleDataSeeder.seedDatabase() to populate with demo data
class SampleDataSeeder {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  static Future<void> seedDatabase() async {
    // Clear existing data (optional)
    await _clearDatabase();

    // Create sample users
    final user1Id = await _createUser(
      username: 'digital_painter',
      email: 'painter@artgallery.com',
      bio: 'Professional digital artist specializing in fantasy art and character design',
    );

    final user2Id = await _createUser(
      username: 'photo_master',
      email: 'photo@artgallery.com',
      bio: 'Nature and landscape photographer capturing the beauty of our world',
    );

    final user3Id = await _createUser(
      username: '3d_artist',
      email: '3d@artgallery.com',
      bio: '3D artist creating stunning renders and animations with Blender',
    );

    final user4Id = await _createUser(
      username: 'abstract_creator',
      email: 'abstract@artgallery.com',
      bio: 'Abstract artist exploring colors, shapes, and emotions',
    );

    // Create sample artworks
    // User 1 - Digital Painter
    await _createArtwork(
      artistId: user1Id,
      title: 'Dragon Guardian',
      description: 'A majestic dragon protecting an ancient castle at sunset',
      category: 'Digital Painting',
      medium: 'Procreate',
      likes: 42,
    );

    await _createArtwork(
      artistId: user1Id,
      title: 'Enchanted Forest',
      description: 'Mystical forest with glowing mushrooms and fairy lights',
      category: 'Digital Painting',
      medium: 'Photoshop',
      likes: 38,
    );

    await _createArtwork(
      artistId: user1Id,
      title: 'Cyberpunk Street',
      description: 'Neon-lit street in a futuristic city',
      category: 'Digital Painting',
      medium: 'Procreate',
      likes: 55,
    );

    // User 2 - Photographer
    final artwork1 = await _createArtwork(
      artistId: user2Id,
      title: 'Mountain Sunrise',
      description: 'Golden hour at the peaks of the Rocky Mountains',
      category: 'Photography',
      medium: 'Photography',
      likes: 67,
    );

    await _createArtwork(
      artistId: user2Id,
      title: 'Ocean Waves',
      description: 'Powerful waves crashing against coastal rocks',
      category: 'Photography',
      medium: 'Photography',
      likes: 45,
    );

    await _createArtwork(
      artistId: user2Id,
      title: 'Desert Dunes',
      description: 'Endless sand dunes under a clear blue sky',
      category: 'Photography',
      medium: 'Photography',
      likes: 51,
    );

    // User 3 - 3D Artist
    await _createArtwork(
      artistId: user3Id,
      title: 'Sci-Fi Spacecraft',
      description: 'Detailed 3D model of a futuristic spaceship',
      category: '3D Art',
      medium: 'Blender',
      likes: 73,
    );

    await _createArtwork(
      artistId: user3Id,
      title: 'Fantasy Castle',
      description: '3D architectural visualization of a medieval castle',
      category: '3D Art',
      medium: 'Blender',
      likes: 61,
    );

    // User 4 - Abstract Artist
    await _createArtwork(
      artistId: user4Id,
      title: 'Color Explosion',
      description: 'Abstract composition of vibrant colors and shapes',
      category: 'Abstract',
      medium: 'Digital',
      likes: 34,
    );

    await _createArtwork(
      artistId: user4Id,
      title: 'Geometric Dreams',
      description: 'Minimalist geometric patterns in pastel colors',
      category: 'Abstract',
      medium: 'Illustrator',
      likes: 29,
    );

    // Add some comments
    await _createComment(
      artworkId: artwork1,
      userId: user1Id,
      content: 'Absolutely stunning capture! The lighting is perfect.',
    );

    await _createComment(
      artworkId: artwork1,
      userId: user3Id,
      content: 'This is breathtaking. Where was this taken?',
    );

    await _createComment(
      artworkId: artwork1,
      userId: user4Id,
      content: 'The composition is incredible. Love the golden hour colors!',
    );

    // Add some follows
    await _db.followUser(user1Id, user2Id); // user1 follows user2
    await _db.followUser(user1Id, user3Id); // user1 follows user3
    await _db.followUser(user2Id, user1Id); // user2 follows user1
    await _db.followUser(user2Id, user3Id); // user2 follows user3
    await _db.followUser(user3Id, user1Id); // user3 follows user1
    await _db.followUser(user4Id, user1Id); // user4 follows user1
    await _db.followUser(user4Id, user2Id); // user4 follows user2

    // Add some favorites
    await _db.addFavorite(user1Id, artwork1);
    await _db.addFavorite(user3Id, artwork1);
    await _db.addFavorite(user4Id, artwork1);

    print('✅ Sample data seeded successfully!');
    print('📊 Created:');
    print('   - 4 users');
    print('   - 10 artworks');
    print('   - 3 comments');
    print('   - 7 follows');
    print('   - 3 favorites');
  }

  static Future<int> _createUser({
    required String username,
    required String email,
    String? bio,
  }) async {
    final user = User(
      username: username,
      email: email,
      bio: bio,
    );
    return await _db.createUser(user);
  }

  static Future<int> _createArtwork({
    required int artistId,
    required String title,
    String? description,
    required String category,
    required String medium,
    int likes = 0,
  }) async {
    // Note: In a real app, imagePath would point to an actual image file
    // For demo purposes, using a placeholder path
    final artwork = Artwork(
      title: title,
      description: description,
      imagePath: '', // Replace with actual image paths
      artistId: artistId,
      category: category,
      likes: likes,
    );
    return await _db.createArtwork(artwork);
  }

  static Future<int> _createComment({
    required int artworkId,
    required int userId,
    required String content,
  }) async {
    final comment = Comment(
      artworkId: artworkId,
      userId: userId,
      content: content,
    );
    return await _db.createComment(comment);
  }

  static Future<void> _clearDatabase() async {
    // This will delete all data - use with caution!
    final db = await _db.database;
    await db.delete('comments');
    await db.delete('favorites');
    await db.delete('follows');
    await db.delete('artworks');
    await db.delete('users');
    print('🗑️  Database cleared');
  }

  /// Helper method to print database statistics
  static Future<void> printDatabaseStats() async {
    final users = await _db.getAllUsers();
    final artworks = await _db.getAllArtworks();

    print('\n📊 Database Statistics:');
    print('   Users: ${users.length}');
    print('   Artworks: ${artworks.length}');

    for (var user in users) {
      final userArtworks = await _db.getArtworksByArtist(user.id!);
      final followers = await _db.getFollowers(user.id!);
      final following = await _db.getFollowing(user.id!);

      print('\n👤 ${user.username}:');
      print('   Artworks: ${userArtworks.length}');
      print('   Followers: ${followers.length}');
      print('   Following: ${following.length}');
    }
  }
}

/* USAGE INSTRUCTIONS:

1. Import this file in your main.dart or any screen
2. Call the seeder function when needed:

```dart
import 'utils/sample_data_seeder.dart';

// In your initState or a button press:
await SampleDataSeeder.seedDatabase();

// To view stats:
await SampleDataSeeder.printDatabaseStats();
```

3. IMPORTANT: Before using, update the imagePath in _createArtwork()
   to point to actual placeholder images in your assets folder, or
   modify the code to handle missing images gracefully.

4. You can call seedDatabase() multiple times - it will add more data
   each time (IDs will auto-increment). To start fresh, uncomment
   the _clearDatabase() call at the start of seedDatabase().

*/