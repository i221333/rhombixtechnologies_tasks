import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/artwork.dart';
import '../models/user.dart';
import '../models/comment.dart';
import '../services/provider.dart';
import '../utils/theme.dart';

class ArtworkDetailScreen extends StatefulWidget {
  final Artwork artwork;
  final String heroTag;

  const ArtworkDetailScreen({
    super.key,
    required this.artwork,
    required this.heroTag,
  });

  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  final _commentController = TextEditingController();
  User? _artist;

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  Future<void> _loadArtist() async {
    _artist = await context.read<AppProvider>().getUserById(widget.artwork.artistId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();
    final isFav = provider.isFavorite(widget.artwork.id!);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. IMMERSIVE IMAGE HEADER
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.55,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: _buildCircleAction(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
            actions: [
              _buildCircleAction(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    () {
                  HapticFeedback.mediumImpact();
                  provider.toggleFavorite(widget.artwork.id!);
                },
                iconColor: isFav ? Colors.pinkAccent : Colors.white,
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: widget.heroTag,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(widget.artwork.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImageError(theme),
                    ),
                    // Elegant Gradient Fade
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent, Colors.black87],
                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. CONTENT SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(theme),
                  const SizedBox(height: 24),
                  if (_artist != null) _buildArtistCard(theme, _artist!),
                  const SizedBox(height: 32),
                  _buildSectionTitle(theme, 'The Concept'),
                  const SizedBox(height: 12),
                  Text(
                    widget.artwork.description ?? "The artist has left this piece to speak for itself.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.7,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 32),
                  _buildCommentSection(theme, provider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.artwork.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildYearBadge(theme),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _buildSpecChip(Icons.category_rounded, widget.artwork.category, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildYearBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        DateFormat('yyyy').format(widget.artwork.createdAt),
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap, {Color iconColor = Colors.white}) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.black26,
            child: IconButton(
              icon: Icon(icon, color: iconColor, size: 18),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtistCard(ThemeData theme, User artist) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, theme.scaffoldBackgroundColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(artist.username[0].toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        title: Text(artist.username, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Verified Creator', style: TextStyle(fontSize: 11, color: Colors.white38)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white24),
        onTap: () {}, // Navigate to Artist Profile
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        letterSpacing: 1.5,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildCommentSection(ThemeData theme, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Discussion'),
        const SizedBox(height: 20),
        TextField(
          controller: _commentController,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Share your perspective...',
            suffixIcon: IconButton(
              icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary),
              onPressed: () {
                if (_commentController.text.trim().isNotEmpty) {
                  provider.addComment(widget.artwork.id!, _commentController.text);
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Comment List logic follows here...
      ],
    );
  }

  Widget _buildImageError(ThemeData theme) {
    return Container(
      color: theme.cardTheme.color ?? const Color(0xFF1E293B),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: theme.colorScheme.primary.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Artwork file not found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}