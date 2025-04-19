// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Quote {

 String get id; String get content; String get author; DateTime get createdAt; DateTime? get favoriteDate; bool get isFavorite; bool get isPreviouslyShown; QuoteLanguage get language;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.favoriteDate, favoriteDate) || other.favoriteDate == favoriteDate)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isPreviouslyShown, isPreviouslyShown) || other.isPreviouslyShown == isPreviouslyShown)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,author,createdAt,favoriteDate,isFavorite,isPreviouslyShown,language);

@override
String toString() {
  return 'Quote(id: $id, content: $content, author: $author, createdAt: $createdAt, favoriteDate: $favoriteDate, isFavorite: $isFavorite, isPreviouslyShown: $isPreviouslyShown, language: $language)';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 String id, String content, String author, DateTime createdAt, DateTime? favoriteDate, bool isFavorite, bool isPreviouslyShown, QuoteLanguage language
});




}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? author = null,Object? createdAt = null,Object? favoriteDate = freezed,Object? isFavorite = null,Object? isPreviouslyShown = null,Object? language = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,favoriteDate: freezed == favoriteDate ? _self.favoriteDate : favoriteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isPreviouslyShown: null == isPreviouslyShown ? _self.isPreviouslyShown : isPreviouslyShown // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as QuoteLanguage,
  ));
}

}


/// @nodoc


class _Quote implements Quote {
  const _Quote({required this.id, required this.content, required this.author, required this.createdAt, this.favoriteDate, this.isFavorite = false, this.isPreviouslyShown = false, this.language = QuoteLanguage.english});
  

@override final  String id;
@override final  String content;
@override final  String author;
@override final  DateTime createdAt;
@override final  DateTime? favoriteDate;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isPreviouslyShown;
@override@JsonKey() final  QuoteLanguage language;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.favoriteDate, favoriteDate) || other.favoriteDate == favoriteDate)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isPreviouslyShown, isPreviouslyShown) || other.isPreviouslyShown == isPreviouslyShown)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,author,createdAt,favoriteDate,isFavorite,isPreviouslyShown,language);

@override
String toString() {
  return 'Quote(id: $id, content: $content, author: $author, createdAt: $createdAt, favoriteDate: $favoriteDate, isFavorite: $isFavorite, isPreviouslyShown: $isPreviouslyShown, language: $language)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, String author, DateTime createdAt, DateTime? favoriteDate, bool isFavorite, bool isPreviouslyShown, QuoteLanguage language
});




}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? author = null,Object? createdAt = null,Object? favoriteDate = freezed,Object? isFavorite = null,Object? isPreviouslyShown = null,Object? language = null,}) {
  return _then(_Quote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,favoriteDate: freezed == favoriteDate ? _self.favoriteDate : favoriteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isPreviouslyShown: null == isPreviouslyShown ? _self.isPreviouslyShown : isPreviouslyShown // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as QuoteLanguage,
  ));
}


}

// dart format on
