import 'package:hive/hive.dart';

part 'quote.g.dart';

@HiveType(typeId: 0)
class Quote {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final DateTime? createdAt;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    this.category,
    this.createdAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      author: json['author'] ?? '',
      category: json['category'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    String? category,
    DateTime? createdAt,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
