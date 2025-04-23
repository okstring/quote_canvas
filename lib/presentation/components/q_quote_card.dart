import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class QQuoteCard extends StatefulWidget {
  final Quote quote;
  final Color cardBackgroundColor;
  final Color textColor;

  const QQuoteCard({super.key, required this.quote, required this.cardBackgroundColor, required this.textColor});

  @override
  State<QQuoteCard> createState() => _QQuoteCardState();
}

class _QQuoteCardState extends State<QQuoteCard> {
  @override
  Widget build(BuildContext context) {
    final double paddingValue = 16;

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Card(
          elevation: 5,
          color: widget.cardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Quote Canvas', style: AppTextStyles.smallTextRegular(color: widget.textColor == AppColors.white ? AppColors.gray1 : AppColors.gray3),),
                Icon(Icons.format_quote, size: 34, color: widget.textColor == AppColors.white ? AppColors.gray1 : AppColors.gray3,),
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final TextStyle baseStyle = AppTextStyles.cardTitle();

                        final TextSpan textSpan = TextSpan(
                          text: widget.quote.content,
                          style: baseStyle,
                        );

                        final TextPainter textPainter = TextPainter(
                          text: textSpan,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                        );

                        final availableWidth = constraints.maxWidth;
                        final availableHeight = constraints.maxHeight * 0.8;

                        textPainter.layout(maxWidth: availableWidth);

                        double textScaleFactor = 1.0;
                        if (textPainter.height > availableHeight || textPainter.width > availableWidth) {
                          double heightScale = availableHeight / textPainter.height;
                          double widthScale = availableWidth / textPainter.width;
                          textScaleFactor = heightScale < widthScale ? heightScale : widthScale;
                        }

                        return Text(
                          widget.quote.content,
                          style: baseStyle.copyWith(
                            fontSize: baseStyle.fontSize! * textScaleFactor,
                            color: widget.textColor
                          ),
                          textAlign: TextAlign.center,
                          // maxLines 제거
                          // overflow 제거
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  '- ${widget.quote.author}',
                  style: AppTextStyles.authorText(color: widget.textColor),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}