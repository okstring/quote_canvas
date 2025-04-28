import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quote_canvas/ui/app_colors.dart';

class QInteractiveBookmarkButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isBookmarked;
  final double size;
  final Color inactiveColor;
  final Color activeColor;

  const QInteractiveBookmarkButton({
    Key? key,
    required this.onPressed,
    required this.isBookmarked,
    this.size = 30.0,
    this.inactiveColor = AppColors.richBlack,
    this.activeColor = const Color(0xFF4CAF50),
  });

  @override
  _QInteractiveBookmarkButtonState createState() =>
      _QInteractiveBookmarkButtonState();
}

class _QInteractiveBookmarkButtonState extends State<QInteractiveBookmarkButton>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _dragController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _dragYAnimation;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);

    _dragController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOutQuart)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25.0,
      ),
    ]).animate(_mainController);

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -4.0,
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -4.0,
          end: 2.0,
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 2.0,
          end: -1.0,
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
    ]).animate(_mainController);

    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.1,
          end: -0.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.05,
          end: 0.02,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.02,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25.0,
      ),
    ]).animate(_mainController);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dragYAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOutBack),
    );

    if (widget.isBookmarked) {
      _mainController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(QInteractiveBookmarkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBookmarked != widget.isBookmarked) {
      if (widget.isBookmarked) {
        _mainController.forward();
      } else {
        _mainController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  void _onDragStart() {
    if (!isDragging) {
      setState(() {
        isDragging = true;
      });
      _dragController.forward();
    }
  }

  void _onDragEnd() {
    if (isDragging) {
      setState(() {
        isDragging = false;
      });
      _dragController.reverse();
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null && details.primaryDelta! < -20.0) {
      _onDragEnd();
      _toggleBookmark();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      onVerticalDragStart: (_) => _onDragStart(),
      onVerticalDragEnd: (_) => _onDragEnd(),
      onVerticalDragUpdate: _onDragUpdate,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _dragController,
        ]),
        builder: (context, child) {
          final Color currentColor =
              widget.isBookmarked ? widget.activeColor : widget.inactiveColor;

          final IconData currentIcon =
              widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border;

          final double finalScale =
              widget.isBookmarked
                  ? _sizeAnimation.value *
                      (widget.isBookmarked ? _pulseAnimation.value : 1.0)
                  : _sizeAnimation.value;

          return Transform.translate(
            offset: Offset(
              0,
              _bounceAnimation.value + (isDragging ? _dragYAnimation.value : 0),
            ),
            child: Transform.rotate(
              angle: _rotateAnimation.value * math.pi,
              child: Container(
                decoration:
                    widget.isBookmarked
                        ? BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: currentColor.withAlpha(
                                (255 * 0.1).toInt(),
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        )
                        : null,
                child: Transform.scale(
                  scale: finalScale,
                  child: Icon(
                    currentIcon,
                    color: currentColor,
                    size: widget.size,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
