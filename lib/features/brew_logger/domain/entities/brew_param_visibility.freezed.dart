// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_param_visibility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewParamVisibility {

 int get id; BrewMethod get method; int get paramId; bool get isVisible;
/// Create a copy of BrewParamVisibility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewParamVisibilityCopyWith<BrewParamVisibility> get copyWith => _$BrewParamVisibilityCopyWithImpl<BrewParamVisibility>(this as BrewParamVisibility, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewParamVisibility&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.paramId, paramId) || other.paramId == paramId)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,paramId,isVisible);

@override
String toString() {
  return 'BrewParamVisibility(id: $id, method: $method, paramId: $paramId, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class $BrewParamVisibilityCopyWith<$Res>  {
  factory $BrewParamVisibilityCopyWith(BrewParamVisibility value, $Res Function(BrewParamVisibility) _then) = _$BrewParamVisibilityCopyWithImpl;
@useResult
$Res call({
 int id, BrewMethod method, int paramId, bool isVisible
});




}
/// @nodoc
class _$BrewParamVisibilityCopyWithImpl<$Res>
    implements $BrewParamVisibilityCopyWith<$Res> {
  _$BrewParamVisibilityCopyWithImpl(this._self, this._then);

  final BrewParamVisibility _self;
  final $Res Function(BrewParamVisibility) _then;

/// Create a copy of BrewParamVisibility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? paramId = null,Object? isVisible = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,paramId: null == paramId ? _self.paramId : paramId // ignore: cast_nullable_to_non_nullable
as int,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewParamVisibility].
extension BrewParamVisibilityPatterns on BrewParamVisibility {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewParamVisibility value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewParamVisibility() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewParamVisibility value)  $default,){
final _that = this;
switch (_that) {
case _BrewParamVisibility():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewParamVisibility value)?  $default,){
final _that = this;
switch (_that) {
case _BrewParamVisibility() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  int paramId,  bool isVisible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewParamVisibility() when $default != null:
return $default(_that.id,_that.method,_that.paramId,_that.isVisible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  BrewMethod method,  int paramId,  bool isVisible)  $default,) {final _that = this;
switch (_that) {
case _BrewParamVisibility():
return $default(_that.id,_that.method,_that.paramId,_that.isVisible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  BrewMethod method,  int paramId,  bool isVisible)?  $default,) {final _that = this;
switch (_that) {
case _BrewParamVisibility() when $default != null:
return $default(_that.id,_that.method,_that.paramId,_that.isVisible);case _:
  return null;

}
}

}

/// @nodoc


class _BrewParamVisibility implements BrewParamVisibility {
  const _BrewParamVisibility({required this.id, required this.method, required this.paramId, required this.isVisible});
  

@override final  int id;
@override final  BrewMethod method;
@override final  int paramId;
@override final  bool isVisible;

/// Create a copy of BrewParamVisibility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewParamVisibilityCopyWith<_BrewParamVisibility> get copyWith => __$BrewParamVisibilityCopyWithImpl<_BrewParamVisibility>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewParamVisibility&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.paramId, paramId) || other.paramId == paramId)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,paramId,isVisible);

@override
String toString() {
  return 'BrewParamVisibility(id: $id, method: $method, paramId: $paramId, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class _$BrewParamVisibilityCopyWith<$Res> implements $BrewParamVisibilityCopyWith<$Res> {
  factory _$BrewParamVisibilityCopyWith(_BrewParamVisibility value, $Res Function(_BrewParamVisibility) _then) = __$BrewParamVisibilityCopyWithImpl;
@override @useResult
$Res call({
 int id, BrewMethod method, int paramId, bool isVisible
});




}
/// @nodoc
class __$BrewParamVisibilityCopyWithImpl<$Res>
    implements _$BrewParamVisibilityCopyWith<$Res> {
  __$BrewParamVisibilityCopyWithImpl(this._self, this._then);

  final _BrewParamVisibility _self;
  final $Res Function(_BrewParamVisibility) _then;

/// Create a copy of BrewParamVisibility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? paramId = null,Object? isVisible = null,}) {
  return _then(_BrewParamVisibility(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as BrewMethod,paramId: null == paramId ? _self.paramId : paramId // ignore: cast_nullable_to_non_nullable
as int,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
