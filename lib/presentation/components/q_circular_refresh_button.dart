import 'package:flutter/material.dart';

class QCircularRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const QCircularRefreshButton({
    Key? key,
    required this.onPressed,
    this.size = 56.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _CircularRefreshButtonState createState() => _CircularRefreshButtonState();
}

class _CircularRefreshButtonState extends State<QCircularRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    // 애니메이션 시작
    _animationController.reset();
    _animationController.forward();

    // 콜백 함수 호출
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
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Icon(
              Icons.refresh,
              color: widget.iconColor,
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
