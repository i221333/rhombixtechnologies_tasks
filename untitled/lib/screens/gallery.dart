import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/provider.dart';
import '../widgets/card.dart';
import '../utils/theme.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Digital Painting', '3D Art', 'Photography',
    'Illustration', 'Abstract', 'Pixel Art', 'Vector Art',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Immersive Floating AppBar
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            expandedHeight: 120.0,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                'Explore',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // 2. Persistent Search & Filter Header
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(theme),
                const SizedBox(height: 12),
                _buildCategoryList(),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 3. Grid Display
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.artworks.isEmpty) {
                return _buildEmptyState(theme);
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemBuilder: (context, index) {
                    return ArtworkCard(artwork: provider.artworks[index]);
                  },
                  childCount: provider.artworks.length,
                ),
              );
            },
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => context.read<AppProvider>().searchArtworks(val),
        decoration: InputDecoration(
          hintText: 'Search for inspiration...',
          hintStyle: const TextStyle(color: Colors.white24),
          prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          fillColor: theme.cardColor,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final theme = Theme.of(context); // Add this line here
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                category == 'All'
                    ? context.read<AppProvider>().loadArtworks()
                    : context.read<AppProvider>().loadArtworksByCategory(category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.gradients['midnight'] : null,
                  color: isSelected ? null : theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white10,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 80, color: theme.colorScheme.primary.withOpacity(0.2)),
            const SizedBox(height: 24),
            const Text(
              'The gallery is quiet...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const Text('Upload your masterpiece to start.', style: TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}