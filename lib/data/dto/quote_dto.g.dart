// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteDto _$QuoteDtoFromJson(Map<String, dynamic> json) => QuoteDto(
  id: json['id'] as String?,
  content: json['content'] as String?,
  author: json['author'] as String?,
  createdAt: json['createdAt'] as String?,
  favoriteDate: json['favoriteDate'] as String?,
  isFavorite: json['isFavorite'] as bool?,
  isPreviouslyShown: json['isPreviouslyShown'] as bool?,
  language: json['language'] as String?,
);

Map<String, dynamic> _$QuoteDtoToJson(QuoteDto instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'author': instance.author,
  'createdAt': instance.createdAt,
  'favoriteDate': instance.favoriteDate,
  'isFavorite': instance.isFavorite,
  'isPreviouslyShown': instance.isPreviouslyShown,
  'language': instance.language,
};
