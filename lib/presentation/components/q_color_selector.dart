import 'package:flutter/material.dart';
import 'package:quote_canvas/ui/app_colors.dart';

class QColorSelector extends StatefulWidget {
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;
  final Color? initialColor;
  final double borderWidth;
  final Color selectedBorderColor;

  const QColorSelector({
    Key? key,
    required this.colors,
    required this.onColorSelected,
    this.initialColor,
    this.borderWidth = 2.0,
    this.selectedBorderColor = AppColors.navy100,
  }) : super(key: key);

  @override
  _QColorSelectorState createState() => _QColorSelectorState();
}

class _QColorSelectorState extends State<QColorSelector> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor ?? widget.colors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.colors.length, (index) {
        final color = widget.colors[index];
        final isSelected = _selectedColor == color;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
              widget.onColorSelected(color);
            },
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.selectedBorderColor,
                              width: widget.borderWidth,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}