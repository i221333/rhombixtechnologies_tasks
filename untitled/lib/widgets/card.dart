import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/artwork.dart';
import '../screens/detail.dart';
import '../utils/theme.dart'; // Import your utility for category colors

class ArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final String tagPrefix;
  final int? index;

  const ArtworkCard({
    super.key,
    required this.artwork,
    this.tagPrefix = 'gallery',
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String heroTag = '${tagPrefix}_${artwork.id}_${index ?? ""}';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Modern touch feedback
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 450),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => ArtworkDetailScreen(
              artwork: artwork,
              heroTag: heroTag,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE SECTION
          Hero(
            tag: heroTag,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.file(
                    File(artwork.imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
                  ),

                  // Top-Left Category Badge (Uses your AppTheme utility)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.getCategoryColor(artwork.category).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        artwork.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Bottom Gradient Overlay for readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Likes indicator in overlay
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_rounded, size: 14, color: Colors.pinkAccent),
                        const SizedBox(width: 4),
                        Text(
                          '${artwork.likes}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // INFO SECTION
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.white.withOpacity(0.02),
        child: const Icon(Icons.image_not_supported_outlined, color: Colors.white10),
      ),
    );
  }
}