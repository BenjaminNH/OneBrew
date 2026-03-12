// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_method_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewMethodConfig {

 int get id; BrewMethod get method; String get displayName; bool get isEnabled;
/// Create a copy of BrewMethodConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewMethodConfigCopyWith<BrewMethodConfig> get copyWith => _$BrewMethodConfigCopyWithImpl<BrewMethodConfig>(this as BrewMethodConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewMethodConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,displayName,isEnabled);

@override
String toString() {
  return 'BrewMethodConfig(id: $id, method: $method, displayName: $displayName, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $BrewMethodConfigCopyWith<$Res>  {
  factory $BrewMethodConfigCopyWith(BrewMethodConfig value, $Res Function(BrewMethodConfig) _then) = _$BrewMethodConfigCopyWithImpl;
@useResult
$Res call({
 int id, BrewMethod method, String displayName, bool isEnabled
});




}
/// @nodoc
class _$BrewMethodConfigCopyWithImpl<$Res>
    implements $BrewMethodConfigCopyWith<$Res> {
  _$BrewMethodConfigCopyWithImpl(this._self, this._then);

  final BrewMethodConfig _self;
  final $Res Function(BrewMethodConfig) _then;

/// Create a copy of BrewMethodConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? displayName = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewMethodConfig].
extension BrewMethodConfigPatterns on BrewMethodConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewMethodConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewMethodConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewMethodConfig value)  $default,){
final _that = this;
switch (_that) {
case _BrewMethodConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewMethodConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BrewMethodConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  String displayName,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewMethodConfig() when $default != null:
return $default(_that.id,_that.method,_that.displayName,_that.isEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  String displayName,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _BrewMethodConfig():
return $default(_that.id,_that.method,_that.displayName,_that.isEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  BrewMethod method,  String displayName,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _BrewMethodConfig() when $default != null:
return $default(_that.id,_that.method,_that.displayName,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _BrewMethodConfig implements BrewMethodConfig {
  const _BrewMethodConfig({required this.id, required this.method, required this.displayName, required this.isEnabled});
  

@override final  int id;
@override final  BrewMethod method;
@override final  String displayName;
@override final  bool isEnabled;

/// Create a copy of BrewMethodConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewMethodConfigCopyWith<_BrewMethodConfig> get copyWith => __$BrewMethodConfigCopyWithImpl<_BrewMethodConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewMethodConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,displayName,isEnabled);

@override
String toString() {
  return 'BrewMethodConfig(id: $id, method: $method, displayName: $displayName, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$BrewMethodConfigCopyWith<$Res> implements $BrewMethodConfigCopyWith<$Res> {
  factory _$BrewMethodConfigCopyWith(_BrewMethodConfig value, $Res Function(_BrewMethodConfig) _then) = __$BrewMethodConfigCopyWithImpl;
@override @useResult
$Res call({
 int id, BrewMethod method, String displayName, bool isEnabled
});




}
/// @nodoc
class __$BrewMethodConfigCopyWithImpl<$Res>
    implements _$BrewMethodConfigCopyWith<$Res> {
  __$BrewMethodConfigCopyWithImpl(this._self, this._then);

  final _BrewMethodConfig _self;
  final $Res Function(_BrewMethodConfig) _then;

/// Create a copy of BrewMethodConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? displayName = null,Object? isEnabled = null,}) {
  return _then(_BrewMethodConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
