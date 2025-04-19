// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Settings {

 bool get isDarkMode; bool get enableNotifications; TimeOfDay? get notificationTime; QuoteLanguage get language; bool get isAppFirstLaunch;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications)&&(identical(other.notificationTime, notificationTime) || other.notificationTime == notificationTime)&&(identical(other.language, language) || other.language == language)&&(identical(other.isAppFirstLaunch, isAppFirstLaunch) || other.isAppFirstLaunch == isAppFirstLaunch));
}


@override
int get hashCode => Object.hash(runtimeType,isDarkMode,enableNotifications,notificationTime,language,isAppFirstLaunch);

@override
String toString() {
  return 'Settings(isDarkMode: $isDarkMode, enableNotifications: $enableNotifications, notificationTime: $notificationTime, language: $language, isAppFirstLaunch: $isAppFirstLaunch)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 bool isDarkMode, bool enableNotifications, TimeOfDay? notificationTime, QuoteLanguage language, bool isAppFirstLaunch
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDarkMode = null,Object? enableNotifications = null,Object? notificationTime = freezed,Object? language = null,Object? isAppFirstLaunch = null,}) {
  return _then(_self.copyWith(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,notificationTime: freezed == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as QuoteLanguage,isAppFirstLaunch: null == isAppFirstLaunch ? _self.isAppFirstLaunch : isAppFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _Settings implements Settings {
  const _Settings({required this.isDarkMode, required this.enableNotifications, this.notificationTime, required this.language, required this.isAppFirstLaunch});
  

@override final  bool isDarkMode;
@override final  bool enableNotifications;
@override final  TimeOfDay? notificationTime;
@override final  QuoteLanguage language;
@override final  bool isAppFirstLaunch;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications)&&(identical(other.notificationTime, notificationTime) || other.notificationTime == notificationTime)&&(identical(other.language, language) || other.language == language)&&(identical(other.isAppFirstLaunch, isAppFirstLaunch) || other.isAppFirstLaunch == isAppFirstLaunch));
}


@override
int get hashCode => Object.hash(runtimeType,isDarkMode,enableNotifications,notificationTime,language,isAppFirstLaunch);

@override
String toString() {
  return 'Settings(isDarkMode: $isDarkMode, enableNotifications: $enableNotifications, notificationTime: $notificationTime, language: $language, isAppFirstLaunch: $isAppFirstLaunch)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isDarkMode, bool enableNotifications, TimeOfDay? notificationTime, QuoteLanguage language, bool isAppFirstLaunch
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDarkMode = null,Object? enableNotifications = null,Object? notificationTime = freezed,Object? language = null,Object? isAppFirstLaunch = null,}) {
  return _then(_Settings(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,notificationTime: freezed == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as QuoteLanguage,isAppFirstLaunch: null == isAppFirstLaunch ? _self.isAppFirstLaunch : isAppFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
