# Digital Art Gallery - Flutter App

A comprehensive digital art gallery application built with Flutter, Dart, and SQLite. Users can showcase their artwork, explore other artists' creations, and engage with the community through likes, comments, and favorites.

## Features

### Core Functionality
- **User Authentication**: Simple login/signup system
- **Artwork Upload**: Upload artwork with title, description, category, and medium
- **Gallery Browse**: Explore all artworks in a beautiful masonry grid layout
- **Search & Filter**: Search by title/description and filter by category
- **Artist Profiles**: View artist profiles with their complete portfolio
- **Social Features**:
  - Like artworks
  - Comment on artworks
  - Favorite artworks for quick access
  - Follow/unfollow artists

### Technical Features
- **Local Database**: SQLite database using sqflite package
- **State Management**: Provider pattern for reactive UI
- **Image Handling**: Image picker for camera/gallery selection
- **Responsive UI**: Material Design 3 with custom styling
- **Offline Support**: All data stored locally in SQLite

## Database Schema

### Users Table
- id (Primary Key)
- username
- email
- bio
- profileImage
- createdAt

### Artworks Table
- id (Primary Key)
- title
- description
- imagePath
- artistId (Foreign Key → users.id)
- category
- likes
- createdAt

### Comments Table
- id (Primary Key)
- artworkId (Foreign Key → artworks.id)
- userId (Foreign Key → users.id)
- content
- createdAt

### Favorites Table
- id (Primary Key)
- userId (Foreign Key → users.id)
- artworkId (Foreign Key → artworks.id)
- createdAt

### Follows Table
- id (Primary Key)
- followerId (Foreign Key → users.id)
- followingId (Foreign Key → users.id)
- createdAt

## Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Steps

1. **Clone the repository**
   ```bash
   cd digital_art_gallery
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Android permissions**
   
   Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   ```

4. **Create assets directory**
   ```bash
   mkdir -p assets/images
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── user.dart                      # User model
│   ├── artwork.dart                   # Artwork model
│   └── comment.dart                   # Comment model
├── database/
│   └── database_helper.dart           # SQLite database operations
├── providers/
│   └── app_provider.dart              # State management provider
├── screens/
│   ├── login_screen.dart              # Login/signup screen
│   ├── home_screen.dart               # Main screen with navigation
│   ├── gallery_screen.dart            # Browse artworks
│   ├── upload_screen.dart             # Upload new artwork
│   ├── artwork_detail_screen.dart     # Artwork details & comments
│   ├── favorites_screen.dart          # User's favorite artworks
│   ├── artists_screen.dart            # Browse artists
│   ├── artist_profile_screen.dart     # Artist profile page
│   └── profile_screen.dart            # User's own profile
└── widgets/
    └── artwork_card.dart              # Reusable artwork card widget
```

## Key Packages Used

- **sqflite**: SQLite database
- **path**: File path utilities
- **provider**: State management
- **image_picker**: Image selection from camera/gallery
- **flutter_staggered_grid_view**: Masonry grid layout
- **intl**: Date formatting
- **google_fonts**: Custom fonts

## Usage Guide

### First Launch
1. Enter any username to login/create account
2. The app creates a new user if username doesn't exist

### Uploading Artwork
1. Navigate to the Upload tab
2. Tap to select an image (camera or gallery)
3. Fill in title, description, category, and medium
4. Tap "Upload Artwork"

### Browsing Gallery
1. Use the Explore tab to view all artworks
2. Search using the search bar
3. Filter by category using chips
4. Tap any artwork to view details

### Interacting with Artworks
- **Like**: Tap the heart icon in detail view
- **Favorite**: Tap the heart icon in app bar
- **Comment**: Use the comment box at the bottom
- **View Artist**: Tap artist name to view profile

### Following Artists
1. Navigate to Artists tab
2. Tap any artist to view profile
3. Tap "Follow" button
4. View their complete portfolio

## Database Operations

The `DatabaseHelper` class provides comprehensive CRUD operations:

### User Operations
- `createUser(User user)`
- `getUserById(int id)`
- `getUserByUsername(String username)`
- `getAllUsers()`
- `updateUser(User user)`

### Artwork Operations
- `createArtwork(Artwork artwork)`
- `getArtworkById(int id)`
- `getAllArtworks()`
- `getArtworksByArtist(int artistId)`
- `searchArtworks(String query)`
- `getArtworksByCategory(String category)`
- `updateArtwork(Artwork artwork)`
- `deleteArtwork(int id)`
- `likeArtwork(int artworkId)`

### Comment Operations
- `createComment(Comment comment)`
- `getCommentsByArtwork(int artworkId)`
- `deleteComment(int id)`

### Favorite Operations
- `addFavorite(int userId, int artworkId)`
- `removeFavorite(int userId, int artworkId)`
- `isFavorite(int userId, int artworkId)`
- `getFavoriteArtworks(int userId)`

### Follow Operations
- `followUser(int followerId, int followingId)`
- `unfollowUser(int followerId, int followingId)`
- `isFollowing(int followerId, int followingId)`
- `getFollowers(int userId)`
- `getFollowing(int userId)`

## 🎥 Demo Video

Watch the full demo: [Drive Link](https://drive.google.com/file/d/1kA2qlxXb66L4D34FJ-nC5puWdWnQoV75/view?usp=drive_link)
