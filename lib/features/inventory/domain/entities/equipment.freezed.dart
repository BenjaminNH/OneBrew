// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Equipment {

/// Unique identifier.
 int get id;/// Equipment name, unique across the inventory (e.g. "Comandante C40").
 String get name;/// Category label (optional, e.g. "grinder", "dripper", "kettle").
 String? get category;/// Whether this equipment is a grinder that exposes click-range config.
 bool get isGrinder;/// Whether this equipment is archived (soft-deleted).
 bool get isDeleted;/// Minimum grinder click value (e.g. 0). Only relevant when [isGrinder].
 double? get grindMinClick;/// Maximum grinder click value (e.g. 40). Only relevant when [isGrinder].
 double? get grindMaxClick;/// Step size between clicks (e.g. 1.0 for full-click, 0.5 for half-click).
 double? get grindClickStep;/// Unit label for the click display (e.g. "clicks", "格", "数字").
 String? get grindClickUnit;/// Timestamp when this equipment was first added.
 DateTime get addedAt;/// Number of brew records referencing this equipment.
 int get useCount;
/// Create a copy of Equipment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EquipmentCopyWith<Equipment> get copyWith => _$EquipmentCopyWithImpl<Equipment>(this as Equipment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Equipment&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.isGrinder, isGrinder) || other.isGrinder == isGrinder)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.grindMinClick, grindMinClick) || other.grindMinClick == grindMinClick)&&(identical(other.grindMaxClick, grindMaxClick) || other.grindMaxClick == grindMaxClick)&&(identical(other.grindClickStep, grindClickStep) || other.grindClickStep == grindClickStep)&&(identical(other.grindClickUnit, grindClickUnit) || other.grindClickUnit == grindClickUnit)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,isGrinder,isDeleted,grindMinClick,grindMaxClick,grindClickStep,grindClickUnit,addedAt,useCount);

@override
String toString() {
  return 'Equipment(id: $id, name: $name, category: $category, isGrinder: $isGrinder, isDeleted: $isDeleted, grindMinClick: $grindMinClick, grindMaxClick: $grindMaxClick, grindClickStep: $grindClickStep, grindClickUnit: $grindClickUnit, addedAt: $addedAt, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class $EquipmentCopyWith<$Res>  {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) _then) = _$EquipmentCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? category, bool isGrinder, bool isDeleted, double? grindMinClick, double? grindMaxClick, double? grindClickStep, String? grindClickUnit, DateTime addedAt, int useCount
});




}
/// @nodoc
class _$EquipmentCopyWithImpl<$Res>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._self, this._then);

  final Equipment _self;
  final $Res Function(Equipment) _then;

/// Create a copy of Equipment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? isGrinder = null,Object? isDeleted = null,Object? grindMinClick = freezed,Object? grindMaxClick = freezed,Object? grindClickStep = freezed,Object? grindClickUnit = freezed,Object? addedAt = null,Object? useCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isGrinder: null == isGrinder ? _self.isGrinder : isGrinder // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,grindMinClick: freezed == grindMinClick ? _self.grindMinClick : grindMinClick // ignore: cast_nullable_to_non_nullable
as double?,grindMaxClick: freezed == grindMaxClick ? _self.grindMaxClick : grindMaxClick // ignore: cast_nullable_to_non_nullable
as double?,grindClickStep: freezed == grindClickStep ? _self.grindClickStep : grindClickStep // ignore: cast_nullable_to_non_nullable
as double?,grindClickUnit: freezed == grindClickUnit ? _self.grindClickUnit : grindClickUnit // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Equipment].
extension EquipmentPatterns on Equipment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Equipment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Equipment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Equipment value)  $default,){
final _that = this;
switch (_that) {
case _Equipment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Equipment value)?  $default,){
final _that = this;
switch (_that) {
case _Equipment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? category,  bool isGrinder,  bool isDeleted,  double? grindMinClick,  double? grindMaxClick,  double? grindClickStep,  String? grindClickUnit,  DateTime addedAt,  int useCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Equipment() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.isGrinder,_that.isDeleted,_that.grindMinClick,_that.grindMaxClick,_that.grindClickStep,_that.grindClickUnit,_that.addedAt,_that.useCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? category,  bool isGrinder,  bool isDeleted,  double? grindMinClick,  double? grindMaxClick,  double? grindClickStep,  String? grindClickUnit,  DateTime addedAt,  int useCount)  $default,) {final _that = this;
switch (_that) {
case _Equipment():
return $default(_that.id,_that.name,_that.category,_that.isGrinder,_that.isDeleted,_that.grindMinClick,_that.grindMaxClick,_that.grindClickStep,_that.grindClickUnit,_that.addedAt,_that.useCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? category,  bool isGrinder,  bool isDeleted,  double? grindMinClick,  double? grindMaxClick,  double? grindClickStep,  String? grindClickUnit,  DateTime addedAt,  int useCount)?  $default,) {final _that = this;
switch (_that) {
case _Equipment() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.isGrinder,_that.isDeleted,_that.grindMinClick,_that.grindMaxClick,_that.grindClickStep,_that.grindClickUnit,_that.addedAt,_that.useCount);case _:
  return null;

}
}

}

/// @nodoc


class _Equipment implements Equipment {
  const _Equipment({required this.id, required this.name, this.category, required this.isGrinder, this.isDeleted = false, this.grindMinClick, this.grindMaxClick, this.grindClickStep, this.grindClickUnit, required this.addedAt, required this.useCount});
  

/// Unique identifier.
@override final  int id;
/// Equipment name, unique across the inventory (e.g. "Comandante C40").
@override final  String name;
/// Category label (optional, e.g. "grinder", "dripper", "kettle").
@override final  String? category;
/// Whether this equipment is a grinder that exposes click-range config.
@override final  bool isGrinder;
/// Whether this equipment is archived (soft-deleted).
@override@JsonKey() final  bool isDeleted;
/// Minimum grinder click value (e.g. 0). Only relevant when [isGrinder].
@override final  double? grindMinClick;
/// Maximum grinder click value (e.g. 40). Only relevant when [isGrinder].
@override final  double? grindMaxClick;
/// Step size between clicks (e.g. 1.0 for full-click, 0.5 for half-click).
@override final  double? grindClickStep;
/// Unit label for the click display (e.g. "clicks", "格", "数字").
@override final  String? grindClickUnit;
/// Timestamp when this equipment was first added.
@override final  DateTime addedAt;
/// Number of brew records referencing this equipment.
@override final  int useCount;

/// Create a copy of Equipment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EquipmentCopyWith<_Equipment> get copyWith => __$EquipmentCopyWithImpl<_Equipment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Equipment&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.isGrinder, isGrinder) || other.isGrinder == isGrinder)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.grindMinClick, grindMinClick) || other.grindMinClick == grindMinClick)&&(identical(other.grindMaxClick, grindMaxClick) || other.grindMaxClick == grindMaxClick)&&(identical(other.grindClickStep, grindClickStep) || other.grindClickStep == grindClickStep)&&(identical(other.grindClickUnit, grindClickUnit) || other.grindClickUnit == grindClickUnit)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,isGrinder,isDeleted,grindMinClick,grindMaxClick,grindClickStep,grindClickUnit,addedAt,useCount);

@override
String toString() {
  return 'Equipment(id: $id, name: $name, category: $category, isGrinder: $isGrinder, isDeleted: $isDeleted, grindMinClick: $grindMinClick, grindMaxClick: $grindMaxClick, grindClickStep: $grindClickStep, grindClickUnit: $grindClickUnit, addedAt: $addedAt, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class _$EquipmentCopyWith<$Res> implements $EquipmentCopyWith<$Res> {
  factory _$EquipmentCopyWith(_Equipment value, $Res Function(_Equipment) _then) = __$EquipmentCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? category, bool isGrinder, bool isDeleted, double? grindMinClick, double? grindMaxClick, double? grindClickStep, String? grindClickUnit, DateTime addedAt, int useCount
});




}
/// @nodoc
class __$EquipmentCopyWithImpl<$Res>
    implements _$EquipmentCopyWith<$Res> {
  __$EquipmentCopyWithImpl(this._self, this._then);

  final _Equipment _self;
  final $Res Function(_Equipment) _then;

/// Create a copy of Equipment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? isGrinder = null,Object? isDeleted = null,Object? grindMinClick = freezed,Object? grindMaxClick = freezed,Object? grindClickStep = freezed,Object? grindClickUnit = freezed,Object? addedAt = null,Object? useCount = null,}) {
  return _then(_Equipment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isGrinder: null == isGrinder ? _self.isGrinder : isGrinder // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,grindMinClick: freezed == grindMinClick ? _self.grindMinClick : grindMinClick // ignore: cast_nullable_to_non_nullable
as double?,grindMaxClick: freezed == grindMaxClick ? _self.grindMaxClick : grindMaxClick // ignore: cast_nullable_to_non_nullable
as double?,grindClickStep: freezed == grindClickStep ? _self.grindClickStep : grindClickStep // ignore: cast_nullable_to_non_nullable
as double?,grindClickUnit: freezed == grindClickUnit ? _self.grindClickUnit : grindClickUnit // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
