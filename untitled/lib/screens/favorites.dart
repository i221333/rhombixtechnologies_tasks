import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/provider.dart';
import '../widgets/card.dart';
import '../utils/theme.dart';
import '../models/artwork.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Artwork>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future once to prevent re-fetching on every rebuild
    _favoritesFuture = context.read<AppProvider>().getFavorites();
  }

  // Method to refresh the list manually if needed
  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = context.read<AppProvider>().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // We listen to the provider to know WHEN to refresh,
    // but we use the stored future for the UI.
    context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'COLLECTION',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 2,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Saved Masterpieces',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refreshFavorites,
            icon: const Icon(Icons.auto_awesome_mosaic_rounded, size: 20),
            color: Colors.white30,
          ),
        ],
      ),
      body: FutureBuilder<List<Artwork>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return _buildEmptyState(theme);
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ArtworkCard(
                artwork: favorites[index],
                tagPrefix: 'favs',
                index: index,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icon with your theme's primary color
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.gradients['midnight']?.withOpacity(0.1),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 50,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Empty Collection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start exploring and heart the pieces that inspire you. They will be kept safe here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Potential logic to switch Tab index back to Gallery
                HapticFeedback.lightImpact();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 48),
                backgroundColor: theme.cardTheme.color,
              ),
              child: const Text('EXPLORE ART'),
            ),
          ],
        ),
      ),
    );
  }
}