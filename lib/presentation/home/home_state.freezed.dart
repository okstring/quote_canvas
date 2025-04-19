// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 bool get isLoading; String? get errorMessage; Quote get currentQuote; Settings get settings; DateTime? get lastUpdateTime;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentQuote, currentQuote) || other.currentQuote == currentQuote)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,currentQuote,settings,lastUpdateTime);

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, errorMessage: $errorMessage, currentQuote: $currentQuote, settings: $settings, lastUpdateTime: $lastUpdateTime)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, Quote currentQuote, Settings settings, DateTime? lastUpdateTime
});


$QuoteCopyWith<$Res> get currentQuote;$SettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? currentQuote = null,Object? settings = null,Object? lastUpdateTime = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentQuote: null == currentQuote ? _self.currentQuote : currentQuote // ignore: cast_nullable_to_non_nullable
as Quote,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,lastUpdateTime: freezed == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get currentQuote {
  
  return $QuoteCopyWith<$Res>(_self.currentQuote, (value) {
    return _then(_self.copyWith(currentQuote: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsCopyWith<$Res> get settings {
  
  return $SettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.isLoading = false, this.errorMessage = null, required this.currentQuote, required this.settings, this.lastUpdateTime = null});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String? errorMessage;
@override final  Quote currentQuote;
@override final  Settings settings;
@override@JsonKey() final  DateTime? lastUpdateTime;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentQuote, currentQuote) || other.currentQuote == currentQuote)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,currentQuote,settings,lastUpdateTime);

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, errorMessage: $errorMessage, currentQuote: $currentQuote, settings: $settings, lastUpdateTime: $lastUpdateTime)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, Quote currentQuote, Settings settings, DateTime? lastUpdateTime
});


@override $QuoteCopyWith<$Res> get currentQuote;@override $SettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? currentQuote = null,Object? settings = null,Object? lastUpdateTime = freezed,}) {
  return _then(_HomeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentQuote: null == currentQuote ? _self.currentQuote : currentQuote // ignore: cast_nullable_to_non_nullable
as Quote,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,lastUpdateTime: freezed == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get currentQuote {
  
  return $QuoteCopyWith<$Res>(_self.currentQuote, (value) {
    return _then(_self.copyWith(currentQuote: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsCopyWith<$Res> get settings {
  
  return $SettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
