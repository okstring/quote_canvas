import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:uuid/uuid.dart';

class Quote {
  static final uuid = Uuid();

  final String id;
  final String content;
  final String author;
  final DateTime? createdAt;
  final DateTime? favoriteDate;
  final bool isFavorite;
  final bool isPreviouslyShown;
  final QuoteLanguage language;

  Quote({
    String? id,
    required this.content,
    required this.author,
    DateTime? createdAt,
    this.favoriteDate,
    this.isFavorite = false,
    this.isPreviouslyShown = false,
    this.language = QuoteLanguage.english,
  }) : id = id ?? uuid.v4(),
       createdAt = createdAt;

  factory Quote.fromJson(Map<String, dynamic> json) {
    final languageCode = json['language'] ?? 'en';

    return Quote(
      id: Quote.uuid.v4(),
      content: json['q'] ?? '',
      author: json['a'] ?? '',
      createdAt: DateTime.now(),
      favoriteDate: null,
      isFavorite: false,
      isPreviouslyShown: false,
      language: QuoteLanguage.fromCode(languageCode),
    );
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    final languageCode = map['language'] ?? 'en';

    return Quote(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      favoriteDate:
          map['favorite_date'] != null
              ? DateTime.parse(map['favorite_date'])
              : null,
      isFavorite: map['is_favorite'] == 1,
      isPreviouslyShown: map['is_previously_shown'] == 1,
      language: QuoteLanguage.fromCode(languageCode),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'created_at': createdAt?.toIso8601String(),
      'favorite_date': favoriteDate?.toIso8601String(),
      'is_favorite': isFavorite,
      'is_previously_shown': isPreviouslyShown,
      'language': language.code,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'created_at': createdAt?.toIso8601String(),
      'favorite_date': favoriteDate?.toIso8601String(),
      'is_favorite': isFavorite ? 1 : 0,
      'is_previously_shown': isPreviouslyShown ? 1 : 0,
      'language': language.code,
    };
  }

  Quote copyWith({
    String? id,
    String? content,
    String? author,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? favoriteDate,
    bool? isFavorite,
    bool? isPreviouslyShown,
    QuoteLanguage? language,
  }) {
    return Quote(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          author == other.author &&
          createdAt == other.createdAt &&
          favoriteDate == other.favoriteDate &&
          isFavorite == other.isFavorite &&
          isPreviouslyShown == other.isPreviouslyShown &&
          language == other.language;

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      author.hashCode ^
      createdAt.hashCode ^
      favoriteDate.hashCode ^
      isFavorite.hashCode ^
      isPreviouslyShown.hashCode ^
      language.hashCode;

  @override
  String toString() {
    return 'Quote{id: $id, content: $content, author: $author, createdAt: $createdAt, favoriteDate: $favoriteDate, isFavorite: $isFavorite, isPreviouslyShown: $isPreviouslyShown, language: $language}';
  }

  static final EMPTY = Quote(content: '', author: '');
}
