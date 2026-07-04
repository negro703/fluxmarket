import 'package:flutter/material.dart';

/// A staggered animation wrapper that builds a grid of items with
/// sequential fade-in and slide-up animations.
///
/// Each child animates with a slight delay based on its index,
/// creating a cascading entrance effect.
///
/// Usage:
/// ```dart
/// StaggeredGridView(
///   itemCount: products.length,
///   itemBuilder: (context, index) => ProductCard(product: products[index]),
/// )
/// ```
class StaggeredGridView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry padding;
  final double staggerDelayMilliseconds;
  final Duration animationDuration;
  final double slideOffset;

  const StaggeredGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    this.padding = EdgeInsets.zero,
    this.staggerDelayMilliseconds = 80,
    this.animationDuration = const Duration(milliseconds: 400),
    this.slideOffset = 30.0,
  });

  @override
  State<StaggeredGridView> createState() => _StaggeredGridViewState();
}

class _StaggeredGridViewState extends State<StaggeredGridView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Animation<double>> _opacityAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration +
          Duration(
            milliseconds: (widget.itemCount * widget.staggerDelayMilliseconds)
                .toInt(),
          ),
    );

    _buildAnimations();
    _controller.forward();
  }

  @override
  void didUpdateWidget(StaggeredGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount ||
        oldWidget.staggerDelayMilliseconds != widget.staggerDelayMilliseconds ||
        oldWidget.animationDuration != widget.animationDuration ||
        oldWidget.slideOffset != widget.slideOffset) {
      _buildAnimations();
      _controller.reset();
      _controller.forward();
    }
  }

  void _buildAnimations() {
    _opacityAnimations.clear();
    _slideAnimations.clear();

    final totalDurationMs = _controller.duration!.inMilliseconds;

    for (int i = 0; i < widget.itemCount; i++) {
      final delay = i * widget.staggerDelayMilliseconds;
      final startTime = (delay / totalDurationMs).clamp(0.0, 1.0);
      final endTime =
          ((delay + widget.animationDuration.inMilliseconds) / totalDurationMs)
              .clamp(0.0, 1.0);

      _opacityAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(startTime, endTime, curve: Curves.easeOut),
          ),
        ),
      );

      _slideAnimations.add(
        Tween<Offset>(
          begin: Offset(0, widget.slideOffset / 100),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: widget.padding,
          gridDelegate: widget.gridDelegate,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            if (index >= _opacityAnimations.length) {
              return widget.itemBuilder(context, index);
            }
            return Opacity(
              opacity: _opacityAnimations[index].value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  _slideAnimations[index].value.dy * widget.slideOffset,
                ),
                child: widget.itemBuilder(context, index),
              ),
            );
          },
        );
      },
    );
  }
}