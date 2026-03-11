// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_param_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewParamDefinition {

 int get id; BrewMethod get method; String get name; ParamType get type; String? get unit; bool get isSystem; int get sortOrder;
/// Create a copy of BrewParamDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewParamDefinitionCopyWith<BrewParamDefinition> get copyWith => _$BrewParamDefinitionCopyWithImpl<BrewParamDefinition>(this as BrewParamDefinition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewParamDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,name,type,unit,isSystem,sortOrder);

@override
String toString() {
  return 'BrewParamDefinition(id: $id, method: $method, name: $name, type: $type, unit: $unit, isSystem: $isSystem, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $BrewParamDefinitionCopyWith<$Res>  {
  factory $BrewParamDefinitionCopyWith(BrewParamDefinition value, $Res Function(BrewParamDefinition) _then) = _$BrewParamDefinitionCopyWithImpl;
@useResult
$Res call({
 int id, BrewMethod method, String name, ParamType type, String? unit, bool isSystem, int sortOrder
});




}
/// @nodoc
class _$BrewParamDefinitionCopyWithImpl<$Res>
    implements $BrewParamDefinitionCopyWith<$Res> {
  _$BrewParamDefinitionCopyWithImpl(this._self, this._then);

  final BrewParamDefinition _self;
  final $Res Function(BrewParamDefinition) _then;

/// Create a copy of BrewParamDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? name = null,Object? type = null,Object? unit = freezed,Object? isSystem = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParamType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewParamDefinition].
extension BrewParamDefinitionPatterns on BrewParamDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewParamDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewParamDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewParamDefinition value)  $default,){
final _that = this;
switch (_that) {
case _BrewParamDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewParamDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _BrewParamDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  String name,  ParamType type,  String? unit,  bool isSystem,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewParamDefinition() when $default != null:
return $default(_that.id,_that.method,_that.name,_that.type,_that.unit,_that.isSystem,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  String name,  ParamType type,  String? unit,  bool isSystem,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _BrewParamDefinition():
return $default(_that.id,_that.method,_that.name,_that.type,_that.unit,_that.isSystem,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  BrewMethod method,  String name,  ParamType type,  String? unit,  bool isSystem,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _BrewParamDefinition() when $default != null:
return $default(_that.id,_that.method,_that.name,_that.type,_that.unit,_that.isSystem,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _BrewParamDefinition implements BrewParamDefinition {
  const _BrewParamDefinition({required this.id, required this.method, required this.name, required this.type, this.unit, required this.isSystem, required this.sortOrder});
  

@override final  int id;
@override final  BrewMethod method;
@override final  String name;
@override final  ParamType type;
@override final  String? unit;
@override final  bool isSystem;
@override final  int sortOrder;

/// Create a copy of BrewParamDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewParamDefinitionCopyWith<_BrewParamDefinition> get copyWith => __$BrewParamDefinitionCopyWithImpl<_BrewParamDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewParamDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,name,type,unit,isSystem,sortOrder);

@override
String toString() {
  return 'BrewParamDefinition(id: $id, method: $method, name: $name, type: $type, unit: $unit, isSystem: $isSystem, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$BrewParamDefinitionCopyWith<$Res> implements $BrewParamDefinitionCopyWith<$Res> {
  factory _$BrewParamDefinitionCopyWith(_BrewParamDefinition value, $Res Function(_BrewParamDefinition) _then) = __$BrewParamDefinitionCopyWithImpl;
@override @useResult
$Res call({
 int id, BrewMethod method, String name, ParamType type, String? unit, bool isSystem, int sortOrder
});




}
/// @nodoc
class __$BrewParamDefinitionCopyWithImpl<$Res>
    implements _$BrewParamDefinitionCopyWith<$Res> {
  __$BrewParamDefinitionCopyWithImpl(this._self, this._then);

  final _BrewParamDefinition _self;
  final $Res Function(_BrewParamDefinition) _then;

/// Create a copy of BrewParamDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? name = null,Object? type = null,Object? unit = freezed,Object? isSystem = null,Object? sortOrder = null,}) {
  return _then(_BrewParamDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParamType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
