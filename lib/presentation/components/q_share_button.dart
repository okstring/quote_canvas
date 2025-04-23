import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quote_canvas/ui/app_colors.dart';

class QShareButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const QShareButton({
    Key? key,
    required this.onPressed,
    this.size = 56.0,
    this.backgroundColor = AppColors.teal100,
    this.iconColor = Colors.white,
  });

  @override
  _QShareButtonState createState() => _QShareButtonState();
}

class _QShareButtonState extends State<QShareButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _iconAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.lightImpact();

    _animationController.reset();
    _animationController.forward();

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _iconAnimation.value,
                child: Icon(
                  Icons.share,
                  color: widget.iconColor,
                  size: widget.size * 0.5,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}