import 'package:flutter/material.dart';
import 'package:quote_canvas/ui/app_colors.dart';

class QInteractiveBookmarkButton extends StatelessWidget {
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
    this.activeColor = AppColors.navy100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? activeColor : inactiveColor,
        size: size,
      ),
    );
  }
}