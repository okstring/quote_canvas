import 'dart:convert';

class Quote {
  final String id;
  final String content;
  final String author;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? favoriteDate;
  final bool isFavorite;
  final bool isPreviouslyShown;

  const Quote({
    required this.id,
    required this.content,
    required this.author,
    this.tags,
    this.createdAt,
    this.favoriteDate,
    this.isFavorite = false,
    this.isPreviouslyShown = false,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      favoriteDate:
          json['favorite_date'] != null
              ? DateTime.parse(json['favorite_date'])
              : null,
      isFavorite: json['is_favorite'] ?? false,
      isPreviouslyShown: json['is_previously_shown'] ?? false,
    );
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      tags:
          map['tags'] != null
              ? List<String>.from(json.decode(map['tags']))
              : null,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      favoriteDate:
          map['favorite_date'] != null
              ? DateTime.parse(map['favorite_date'])
              : null,
      isFavorite: map['is_favorite'] == 1,
      isPreviouslyShown: map['is_previously_shown'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'favorite_date': favoriteDate?.toIso8601String(),
      'is_favorite': isFavorite,
      'is_previously_shown': isPreviouslyShown,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'tags': tags != null ? json.encode(tags) : null,
      'created_at': createdAt?.toIso8601String(),
      'favorite_date': favoriteDate?.toIso8601String(),
      'is_favorite': isFavorite ? 1 : 0,
      'is_previously_shown': isPreviouslyShown ? 1 : 0,
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
  }) {
    return Quote(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      favoriteDate: favoriteDate ?? this.favoriteDate,
      isFavorite: isFavorite ?? this.isFavorite,
      isPreviouslyShown: isPreviouslyShown ?? this.isPreviouslyShown,
    );
  }
}
