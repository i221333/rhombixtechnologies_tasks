import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/provider.dart';
import '../models/user.dart';
import '../utils/theme.dart';
import 'artist_profile.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'COMMUNITY',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 2,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Featured Creators',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final artists = provider.artists;

          if (artists.isEmpty) {
            return _buildEmptyState(theme);
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: artists.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              return _ArtistCard(artist: artists[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Opacity(
        opacity: 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on_rounded, size: 64),
            const SizedBox(height: 16),
            Text('The community is growing...', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ArtistCard extends StatelessWidget {
  final User artist;
  const _ArtistCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // We select only the following status to minimize rebuilds
    final isFollowing = context.select<AppProvider, bool>(
            (p) => p.isFollowing(artist.id!)
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: ListTile(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ArtistProfileScreen(artist: artist)),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        // 1. Hero Avatar
        leading: Hero(
          tag: 'avatar-${artist.id}',
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.gradients['midnight'],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Text(
                artist.username[0].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        // 2. Information
        title: Text(
          artist.username,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            artist.bio ?? "Independent Artist",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ),
        // 3. Optimized Follow Button
        trailing: _FollowButton(
          isFollowing: isFollowing,
          onTap: () {
            HapticFeedback.lightImpact();
            context.read<AppProvider>().toggleFollow(artist.id!);
          },
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;

  const _FollowButton({required this.isFollowing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isFollowing ? null : AppTheme.gradients['midnight'],
          color: isFollowing ? Colors.white.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            color: isFollowing ? Colors.white38 : Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}