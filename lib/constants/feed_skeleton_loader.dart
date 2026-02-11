import 'package:flutter/material.dart';

// ============================================================
// SHIMMER ENGINE (reuse from your existing shimmer_widget.dart)
// Drop this import if you already have the core engine:
//   import '../../../shared/shimmer_widget.dart';
// ============================================================

class ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShimmerWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

// ============================================================
// FEED SKELETON LOADER — Top-level entry point
// Usage: replace CircularProgressIndicator in FeedLoadingIndicator with:
//        FeedSkeletonLoader()
// ============================================================

class FeedSkeletonLoader extends StatelessWidget {
  /// Number of post card skeletons to render (mirrors typical viewport fill)
  final int itemCount;

  const FeedSkeletonLoader({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: itemCount,
        itemBuilder: (context, index) => _PostCardSkeleton(index: index),
      ),
    );
  }
}

// ============================================================
// POST CARD SKELETON
// Mirrors PostCard layout:
//   • Header  — avatar · name · timestamp · overflow menu
//   • Body    — text lines (2–3)
//   • Image   — every other card has a media block (like YT thumbnails)
//   • Footer  — Like · Comment · Share action row
// ============================================================

class _PostCardSkeleton extends StatelessWidget {
  final int index;

  const _PostCardSkeleton({required this.index});

  /// Alternate: even-index cards have a media block, odd ones are text-only.
  /// This gives the feed the same visual rhythm YouTube uses.
  bool get _hasMedia => index.isEven;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──────────────────────────────────
          _PostHeaderSkeleton(),

          // ── Text body ────────────────────────────────────
          _PostTextSkeleton(),

          // ── Media block (conditional) ─────────────────────
          if (_hasMedia) ...[const SizedBox(height: 10), _PostMediaSkeleton()],

          // ── Action row ───────────────────────────────────
          PostActionRowSkeleton(),

          // Divider between cards
          const Divider(height: 1, thickness: 0.8, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }
}

// ── Header: avatar + name/timestamp + overflow dot ───────────
class _PostHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circle avatar
          const SkeletonContainer(
            width: 44,
            height: 44,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          const SizedBox(width: 10),

          // Name + timestamp stacked
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username line
                SkeletonContainer(
                  width: 130,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 5),
                // Timestamp / subtitle line
                SkeletonContainer(
                  width: 80,
                  height: 11,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Overflow menu dots (three vertical dots)
          SkeletonContainer(
            width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}

// ── Body: 2–3 lines of post text ─────────────────────────────
class _PostTextSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width line
          SkeletonContainer(
            width: double.infinity,
            height: 13,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 7),
          // Second full-width line
          SkeletonContainer(
            width: double.infinity,
            height: 13,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 7),
          // Partial last line — gives a natural paragraph feel
          SkeletonContainer(
            width: 220,
            height: 13,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

// ── Media: 16:9 image block (YouTube-style thumbnail) ─────────
class _PostMediaSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 16:9 ratio
    final mediaHeight = (screenWidth - 28) * 9 / 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SkeletonContainer(
        width: double.infinity,
        height: mediaHeight,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// ── Footer: Like · Comment · Share ───────────────────────────
class PostActionRowSkeleton extends StatelessWidget {
  const PostActionRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Row(
        children: [
          // Like button (icon + count)
          _ActionChipSkeleton(iconWidth: 20, labelWidth: 32),
          const SizedBox(width: 22),
          // Comment button
          _ActionChipSkeleton(iconWidth: 20, labelWidth: 28),
          const SizedBox(width: 22),
          // Share button
          _ActionChipSkeleton(iconWidth: 20, labelWidth: 36),
          const Spacer(),
          // Bookmark / save icon on the right (like YT save)
          SkeletonContainer(
            width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class _ActionChipSkeleton extends StatelessWidget {
  final double iconWidth;
  final double labelWidth;

  const _ActionChipSkeleton({
    required this.iconWidth,
    required this.labelWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonContainer(
          width: iconWidth,
          height: iconWidth,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(width: 5),
        SkeletonContainer(
          width: labelWidth,
          height: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

// ============================================================
// STORIES / HORIZONTAL AVATAR ROW SKELETON (optional top strip)
// Matches the stories bar seen in Instagram/Facebook-style feeds.
// Include above FeedSkeletonLoader if your FeedScreen has stories.
// ============================================================

class StoriesBarSkeleton extends StatelessWidget {
  final int count;

  const StoriesBarSkeleton({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Container(
        height: 96,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => _StoryItemSkeleton(isFirst: i == 0),
        ),
      ),
    );
  }
}

class _StoryItemSkeleton extends StatelessWidget {
  final bool isFirst;

  const _StoryItemSkeleton({this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Story ring + avatar
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 5),
        SkeletonContainer(
          width: 44,
          height: 10,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

// ============================================================
// FULL FEED SCREEN SKELETON
// Drop-in replacement for FeedLoadingIndicator in feed_screen.dart:
//
//   // Before:
//   class FeedLoadingIndicator extends StatelessWidget {
//     Widget build(context) => Center(child: CircularProgressIndicator(...));
//   }
//
//   // After:
//   class FeedLoadingIndicator extends StatelessWidget {
//     Widget build(context) => const FullFeedSkeletonScreen();
//   }
// ============================================================

class FullFeedSkeletonScreen extends StatelessWidget {
  const FullFeedSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Optional stories strip — remove if unused
        StoriesBarSkeleton(),
        Divider(height: 1, color: Color(0xFFF0F0F0)),

        // Post cards
        Expanded(child: FeedSkeletonLoader(itemCount: 4)),
      ],
    );
  }
}
