// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bean.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Bean {

/// Unique identifier.
 int get id;/// Bean display name, unique across the inventory.
 String get name;/// Roaster / producer (optional).
 String? get roaster;/// Origin / country of origin (optional).
 String? get origin;/// Roast level label (optional, e.g. "Light", "Medium-Dark").
 String? get roastLevel;/// Timestamp when this bean was first added to the inventory.
 DateTime get addedAt;/// Number of brew records referencing this bean (autocomplete weight).
 int get useCount;
/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanCopyWith<Bean> get copyWith => _$BeanCopyWithImpl<Bean>(this as Bean, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.roaster, roaster) || other.roaster == roaster)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,roaster,origin,roastLevel,addedAt,useCount);

@override
String toString() {
  return 'Bean(id: $id, name: $name, roaster: $roaster, origin: $origin, roastLevel: $roastLevel, addedAt: $addedAt, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class $BeanCopyWith<$Res>  {
  factory $BeanCopyWith(Bean value, $Res Function(Bean) _then) = _$BeanCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? roaster, String? origin, String? roastLevel, DateTime addedAt, int useCount
});




}
/// @nodoc
class _$BeanCopyWithImpl<$Res>
    implements $BeanCopyWith<$Res> {
  _$BeanCopyWithImpl(this._self, this._then);

  final Bean _self;
  final $Res Function(Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? roaster = freezed,Object? origin = freezed,Object? roastLevel = freezed,Object? addedAt = null,Object? useCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roaster: freezed == roaster ? _self.roaster : roaster // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,roastLevel: freezed == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Bean].
extension BeanPatterns on Bean {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bean value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bean value)  $default,){
final _that = this;
switch (_that) {
case _Bean():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bean value)?  $default,){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? roaster,  String? origin,  String? roastLevel,  DateTime addedAt,  int useCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name,_that.roaster,_that.origin,_that.roastLevel,_that.addedAt,_that.useCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? roaster,  String? origin,  String? roastLevel,  DateTime addedAt,  int useCount)  $default,) {final _that = this;
switch (_that) {
case _Bean():
return $default(_that.id,_that.name,_that.roaster,_that.origin,_that.roastLevel,_that.addedAt,_that.useCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? roaster,  String? origin,  String? roastLevel,  DateTime addedAt,  int useCount)?  $default,) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name,_that.roaster,_that.origin,_that.roastLevel,_that.addedAt,_that.useCount);case _:
  return null;

}
}

}

/// @nodoc


class _Bean implements Bean {
  const _Bean({required this.id, required this.name, this.roaster, this.origin, this.roastLevel, required this.addedAt, required this.useCount});
  

/// Unique identifier.
@override final  int id;
/// Bean display name, unique across the inventory.
@override final  String name;
/// Roaster / producer (optional).
@override final  String? roaster;
/// Origin / country of origin (optional).
@override final  String? origin;
/// Roast level label (optional, e.g. "Light", "Medium-Dark").
@override final  String? roastLevel;
/// Timestamp when this bean was first added to the inventory.
@override final  DateTime addedAt;
/// Number of brew records referencing this bean (autocomplete weight).
@override final  int useCount;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanCopyWith<_Bean> get copyWith => __$BeanCopyWithImpl<_Bean>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.roaster, roaster) || other.roaster == roaster)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,roaster,origin,roastLevel,addedAt,useCount);

@override
String toString() {
  return 'Bean(id: $id, name: $name, roaster: $roaster, origin: $origin, roastLevel: $roastLevel, addedAt: $addedAt, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class _$BeanCopyWith<$Res> implements $BeanCopyWith<$Res> {
  factory _$BeanCopyWith(_Bean value, $Res Function(_Bean) _then) = __$BeanCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? roaster, String? origin, String? roastLevel, DateTime addedAt, int useCount
});




}
/// @nodoc
class __$BeanCopyWithImpl<$Res>
    implements _$BeanCopyWith<$Res> {
  __$BeanCopyWithImpl(this._self, this._then);

  final _Bean _self;
  final $Res Function(_Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? roaster = freezed,Object? origin = freezed,Object? roastLevel = freezed,Object? addedAt = null,Object? useCount = null,}) {
  return _then(_Bean(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,roaster: freezed == roaster ? _self.roaster : roaster // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,roastLevel: freezed == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
