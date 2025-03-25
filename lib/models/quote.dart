class Quote {
  final String id;
  final String text;
  final String author;
  final String? category;
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
