import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/provider.dart';
import '../widgets/card.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    // Guard clause for unauthenticated state
    if (user == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: Text("Please Log In to view your studio.")),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Dynamic Header with Stretch Effect
          _buildSliverAppBar(context, user, theme),

          // 2. Profile Details & Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  if (user.bio != null && user.bio!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                      child: Text(
                        user.bio!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildStatsRow(theme),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, theme),
                  const SizedBox(height: 40),
                  _buildSectionTitle(theme, 'MY STUDIO'),
                ],
              ),
            ),
          ),

          // 3. Artist's Personal Grid
          FutureBuilder(
            future: provider.getArtistArtworks(user.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final artworks = snapshot.data ?? [];

              if (artworks.isEmpty) {
                return _buildEmptyStudioState(theme);
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemBuilder: (context, index) {
                    return ArtworkCard(
                      artwork: artworks[index],
                      tagPrefix: 'profile', // Unique Hero tag prefix
                      index: index,
                    );
                  },
                  childCount: artworks.length,
                ),
              );
            },
          ),

          // Bottom Spacing for Floating Nav Bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSliverAppBar(BuildContext context, user, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white70),
          onPressed: () => _confirmLogout(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative Background Glow
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Gradient Border Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.gradients['midnight'],
                  ),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: theme.cardTheme.color,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.username.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  user.email,
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.white38),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Works', '14'),
        _buildDivider(),
        _buildStatItem('Followers', '2.4K'),
        _buildDivider(),
        _buildStatItem('Following', '412'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white30)),
      ],
    );
  }

  Widget _buildDivider() => Container(height: 20, width: 1, color: Colors.white10);

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_rounded, size: 18),
              onPressed: () => _showEditProfileDialog(context),
              label: const Text('Edit Bio'),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.share_rounded, size: 20, color: Colors.white70),
              onPressed: () {
                HapticFeedback.lightImpact();
                // Share logic here
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
        ],
      ),
    );
  }

  Widget _buildEmptyStudioState(ThemeData theme) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.palette_outlined, size: 64),
              const SizedBox(height: 16),
              const Text('Studio Empty', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('Your uploads will appear here.', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  void _confirmLogout(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to re-enter your username to access your studio.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AppProvider>().logout();
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final provider = context.read<AppProvider>();
    final bioController = TextEditingController(text: provider.currentUser?.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Studio Bio'),
        content: TextField(
          controller: bioController,
          maxLines: 3,
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(hintText: 'Tell your story...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateProfile(bio: bioController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}