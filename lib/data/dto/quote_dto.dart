import 'package:json_annotation/json_annotation.dart';

part 'quote_dto.g.dart';

@JsonSerializable()
class QuoteDto {
  final String? id;
  final String? content;
  final String? author;
  final String? createdAt;
  final String? favoriteDate;
  final bool? isFavorite;
  final bool? isPreviouslyShown;
  final String? language;

  QuoteDto({
    this.id,
    this.content,
    this.author,
    this.createdAt,
    this.favoriteDate,
    this.isFavorite,
    this.isPreviouslyShown,
    this.language,
  });

  factory QuoteDto.fromJson(Map<String, dynamic> json) =>
      _$QuoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteDtoToJson(this);

  factory QuoteDto.fromMap(Map<String, dynamic> map) {
    return QuoteDto(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      createdAt: map['created_at'],
      favoriteDate: map['favorite_date'],
      isFavorite: map['is_favorite'] == 1,
      isPreviouslyShown: map['is_previously_shown'] == 1,
      language: map['language'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'created_at': createdAt,
      'favorite_date': favoriteDate,
      'is_favorite': isFavorite == true ? 1 : 0,
      'is_previously_shown': isPreviouslyShown == true ? 1 : 0,
      'language': language,
    };
  }

  QuoteDto copyWith({
    String? id,
    String? content,
    String? author,
    String? createdAt,
    String? favoriteDate,
    bool? isFavorite,
    bool? isPreviouslyShown,
    String? language,
  }) {
    return QuoteDto(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      favoriteDate: favoriteDate ?? this.favoriteDate,
      isFavorite: isFavorite ?? this.isFavorite,
      isPreviouslyShown: isPreviouslyShown ?? this.isPreviouslyShown,
      language: language ?? this.language,
    );
  }
}