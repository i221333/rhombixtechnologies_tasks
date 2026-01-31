import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/user.dart';
import '../services/provider.dart'; // Ensure this matches your file path
import '../widgets/card.dart';
import '../utils/theme.dart';

class ArtistProfileScreen extends StatelessWidget {
  final User artist;
  const ArtistProfileScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();
    final isFollowing = provider.isFollowing(artist.id!);
    final isOwnProfile = provider.currentUser?.id == artist.id;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Immersive Header
          _buildSliverAppBar(theme),

          // 2. Profile Details & Stats
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  _buildAvatar(theme),
                  const SizedBox(height: 16),
                  Text(
                    artist.username,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  if (artist.bio != null) _buildBio(theme),
                  const SizedBox(height: 24),
                  _buildStatsRow(theme),
                  const SizedBox(height: 32),
                  if (!isOwnProfile) _buildFollowButton(context, isFollowing, theme),
                  const SizedBox(height: 40),
                  _buildSectionTitle(theme, 'GALLERY'),
                ],
              ),
            ),
          ),

          // 3. Artist's Artwork Feed
          FutureBuilder(
            future: provider.getArtistArtworks(artist.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final artworks = snapshot.data ?? [];
              if (artworks.isEmpty) return _buildEmptyState(theme);

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemBuilder: (context, index) => ArtworkCard(
                    artwork: artworks[index],
                    tagPrefix: 'artist_profile_${artist.id}',
                    index: index,
                  ),
                  childCount: artworks.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.gradients['midnight']),
          child: Center(
            child: Icon(Icons.palette_rounded,
                size: 120, color: Colors.white.withOpacity(0.05)),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Hero(
      tag: 'avatar-${artist.id}',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 55,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Text(
            artist.username[0].toUpperCase(),
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBio(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Text(
        artist.bio!,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white60, height: 1.5),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _statItem('Works', '24'),
        _verticalDivider(),
        _statItem('Followers', '1.2k'),
        _verticalDivider(),
        _statItem('Following', '84'),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(height: 24, width: 1, color: Colors.white10);

  Widget _buildFollowButton(BuildContext context, bool isFollowing, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          context.read<AppProvider>().toggleFollow(artist.id!);
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: isFollowing ? null : AppTheme.gradients['midnight'],
            color: isFollowing ? theme.cardTheme.color : null,
            borderRadius: BorderRadius.circular(16),
            border: isFollowing ? Border.all(color: Colors.white10) : null,
          ),
          child: Center(
            child: Text(
              isFollowing ? 'FOLLOWING' : 'FOLLOW ARTIST',
              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: Colors.white10)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text('No artworks in this collection yet.',
            style: TextStyle(color: Colors.white38)),
      ),
    );
  }
}