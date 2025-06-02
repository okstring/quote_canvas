import 'package:flutter/material.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class HalfSelectableButton extends StatefulWidget {
  final void Function(Color selectedColor) onColorSelected;

  const HalfSelectableButton({super.key, required this.onColorSelected});

  @override
  State<HalfSelectableButton> createState() => _HalfSelectableButtonState();
}

class _HalfSelectableButtonState extends State<HalfSelectableButton> {
  bool isLeftSelected = false;
  bool isRightSelected = true;

  void _onLeftTap() {
    setState(() {
      isLeftSelected = true;
      isRightSelected = false;
    });
    widget.onColorSelected(AppColors.white);
  }

  void _onRightTap() {
    setState(() {
      isLeftSelected = false;
      isRightSelected = true;
    });
    widget.onColorSelected(AppColors.richBlack);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.navy10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // 왼쪽
          Expanded(
            child: GestureDetector(
              onTap: _onLeftTap,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isLeftSelected ? AppColors.navy100 : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'A',
                  style: AppTextStyles.largeTextBold(color: AppColors.white),
                ),
              ),
            ),
          ),
          // 오른쪽
          Expanded(
            child: GestureDetector(
              onTap: _onRightTap,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isRightSelected ? AppColors.navy100 : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'A',
                  style: AppTextStyles.largeTextBold(
                    color: AppColors.richBlack,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
