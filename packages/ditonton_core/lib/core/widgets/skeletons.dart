import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox(
      {super.key,
      required this.height,
      required this.width,
      this.borderRadius = 8});

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1200),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class MovieListTileSkeleton extends StatelessWidget {
  const MovieListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: 120, width: 80, borderRadius: 8),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, width: 200),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 140),
                SizedBox(height: 8),
                ShimmerBox(height: 12, width: double.infinity),
                SizedBox(height: 6),
                ShimmerBox(height: 12, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TvListTileSkeleton extends StatelessWidget {
  const TvListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: 150, width: 100, borderRadius: 8),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, width: 220),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 180),
                SizedBox(height: 8),
                ShimmerBox(height: 12, width: double.infinity),
                SizedBox(height: 6),
                ShimmerBox(height: 12, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalPosterSkeletonList extends StatelessWidget {
  const HorizontalPosterSkeletonList(
      {super.key,
      this.itemCount = 6,
      this.itemWidth = 120,
      this.itemHeight = 180});

  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight + 20,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) =>
            ShimmerBox(height: itemHeight, width: itemWidth, borderRadius: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: itemCount,
      ),
    );
  }
}

class DetailPageSkeleton extends StatelessWidget {
  const DetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: ShimmerBox(height: 320, width: 220, borderRadius: 12)),
          SizedBox(height: 16),
          ShimmerBox(height: 22, width: 220),
          SizedBox(height: 10),
          ShimmerBox(height: 16, width: 160),
          SizedBox(height: 16),
          ShimmerBox(height: 40, width: double.infinity, borderRadius: 8),
          SizedBox(height: 20),
          ShimmerBox(height: 14, width: double.infinity),
          SizedBox(height: 8),
          ShimmerBox(height: 14, width: double.infinity),
          SizedBox(height: 8),
          ShimmerBox(height: 14, width: 240),
          SizedBox(height: 24),
          ShimmerBox(height: 18, width: 180),
          SizedBox(height: 12),
          ShimmerBox(height: 160, width: double.infinity, borderRadius: 8),
        ],
      ),
    );
  }
}
