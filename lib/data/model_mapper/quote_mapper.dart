import 'package:quote_canvas/data/dto/quote_dto.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:uuid/uuid.dart';

extension QuoteMapper on QuoteDto {
  Quote toModel() {
    final _uuid = Uuid();
    final String safeId = id ?? _uuid.v4();
    final String safeContent = content ?? '';
    final String safeAuthor = author ?? '';
    final DateTime safeCreatedAt;

    if (createdAt != null) {
      DateTime? parsedDate = DateTime.tryParse(createdAt ?? '');
      safeCreatedAt = parsedDate ?? DateTime.now();
    } else {
      safeCreatedAt = DateTime.now();
    }

    DateTime? safeFavoriteDate;
    if (favoriteDate != null) {
      safeFavoriteDate = DateTime.tryParse(favoriteDate ?? '');
    }

    return Quote(
      id: safeId,
      content: safeContent,
      author: safeAuthor,
      createdAt: safeCreatedAt,
      favoriteDate: safeFavoriteDate,
      isFavorite: isFavorite ?? false,
      isPreviouslyShown: isPreviouslyShown ?? false,
      language:
          language != null
              ? QuoteLanguage.fromCode(language!)
              : QuoteLanguage.english,
    );
  }
}
