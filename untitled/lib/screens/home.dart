import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider.dart';
import '../utils/theme.dart';
import 'gallery.dart';
import 'upload.dart';
import 'favorites.dart';
import 'profile.dart';
import 'artists.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Use a getter for screens to keep the build clean
  final List<Widget> _screens = [
    const GalleryScreen(),
    const ArtistsScreen(),
    const UploadScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      provider.loadArtworks();
      provider.loadArtists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Extend body behind the nav bar for the glass effect
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.explore_rounded, 'Explore'),
                _navItem(1, Icons.palette_rounded, 'Artists'),
                _buildUploadButton(theme),
                _navItem(3, Icons.favorite_rounded, 'Saved'),
                _navItem(4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final theme = Theme.of(context);

    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.white38,
              size: 26,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(ThemeData theme) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          gradient: AppTheme.gradients['midnight'],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}