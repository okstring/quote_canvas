import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/ui/app_colors.dart';
import 'package:quote_canvas/ui/app_text_styles.dart';

class QQuoteCard extends StatelessWidget {
  final Quote quote;
  final Color cardBackgroundColor;
  final Color textColor;

  const QQuoteCard({super.key, required this.quote, this.cardBackgroundColor = AppColors.peal40, this.textColor = AppColors.richBlack});

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
          color: cardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                Text('Quote Canvas', style: AppTextStyles.smallTextRegular(color: AppColors.gray3),),
                const Icon(Icons.format_quote, size: 34, color: AppColors.gray3,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width - paddingValue * 4,
                          ),
                          child: Text(
                            quote.content,
                            style: AppTextStyles.cardTitle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '- ${quote.author}',
                  style: AppTextStyles.authorText(),
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
