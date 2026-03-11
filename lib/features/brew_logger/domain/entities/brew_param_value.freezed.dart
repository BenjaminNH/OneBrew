// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_param_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewParamValue {

 int get id; int get brewRecordId; int get paramId; double? get valueNumber; String? get valueText;
/// Create a copy of BrewParamValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewParamValueCopyWith<BrewParamValue> get copyWith => _$BrewParamValueCopyWithImpl<BrewParamValue>(this as BrewParamValue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewParamValue&&(identical(other.id, id) || other.id == id)&&(identical(other.brewRecordId, brewRecordId) || other.brewRecordId == brewRecordId)&&(identical(other.paramId, paramId) || other.paramId == paramId)&&(identical(other.valueNumber, valueNumber) || other.valueNumber == valueNumber)&&(identical(other.valueText, valueText) || other.valueText == valueText));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewRecordId,paramId,valueNumber,valueText);

@override
String toString() {
  return 'BrewParamValue(id: $id, brewRecordId: $brewRecordId, paramId: $paramId, valueNumber: $valueNumber, valueText: $valueText)';
}


}

/// @nodoc
abstract mixin class $BrewParamValueCopyWith<$Res>  {
  factory $BrewParamValueCopyWith(BrewParamValue value, $Res Function(BrewParamValue) _then) = _$BrewParamValueCopyWithImpl;
@useResult
$Res call({
 int id, int brewRecordId, int paramId, double? valueNumber, String? valueText
});




}
/// @nodoc
class _$BrewParamValueCopyWithImpl<$Res>
    implements $BrewParamValueCopyWith<$Res> {
  _$BrewParamValueCopyWithImpl(this._self, this._then);

  final BrewParamValue _self;
  final $Res Function(BrewParamValue) _then;

/// Create a copy of BrewParamValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brewRecordId = null,Object? paramId = null,Object? valueNumber = freezed,Object? valueText = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewRecordId: null == brewRecordId ? _self.brewRecordId : brewRecordId // ignore: cast_nullable_to_non_nullable
as int,paramId: null == paramId ? _self.paramId : paramId // ignore: cast_nullable_to_non_nullable
as int,valueNumber: freezed == valueNumber ? _self.valueNumber : valueNumber // ignore: cast_nullable_to_non_nullable
as double?,valueText: freezed == valueText ? _self.valueText : valueText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewParamValue].
extension BrewParamValuePatterns on BrewParamValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewParamValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewParamValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewParamValue value)  $default,){
final _that = this;
switch (_that) {
case _BrewParamValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewParamValue value)?  $default,){
final _that = this;
switch (_that) {
case _BrewParamValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int brewRecordId,  int paramId,  double? valueNumber,  String? valueText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewParamValue() when $default != null:
return $default(_that.id,_that.brewRecordId,_that.paramId,_that.valueNumber,_that.valueText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int brewRecordId,  int paramId,  double? valueNumber,  String? valueText)  $default,) {final _that = this;
switch (_that) {
case _BrewParamValue():
return $default(_that.id,_that.brewRecordId,_that.paramId,_that.valueNumber,_that.valueText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int brewRecordId,  int paramId,  double? valueNumber,  String? valueText)?  $default,) {final _that = this;
switch (_that) {
case _BrewParamValue() when $default != null:
return $default(_that.id,_that.brewRecordId,_that.paramId,_that.valueNumber,_that.valueText);case _:
  return null;

}
}

}

/// @nodoc


class _BrewParamValue implements BrewParamValue {
  const _BrewParamValue({required this.id, required this.brewRecordId, required this.paramId, this.valueNumber, this.valueText});
  

@override final  int id;
@override final  int brewRecordId;
@override final  int paramId;
@override final  double? valueNumber;
@override final  String? valueText;

/// Create a copy of BrewParamValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewParamValueCopyWith<_BrewParamValue> get copyWith => __$BrewParamValueCopyWithImpl<_BrewParamValue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewParamValue&&(identical(other.id, id) || other.id == id)&&(identical(other.brewRecordId, brewRecordId) || other.brewRecordId == brewRecordId)&&(identical(other.paramId, paramId) || other.paramId == paramId)&&(identical(other.valueNumber, valueNumber) || other.valueNumber == valueNumber)&&(identical(other.valueText, valueText) || other.valueText == valueText));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewRecordId,paramId,valueNumber,valueText);

@override
String toString() {
  return 'BrewParamValue(id: $id, brewRecordId: $brewRecordId, paramId: $paramId, valueNumber: $valueNumber, valueText: $valueText)';
}


}

/// @nodoc
abstract mixin class _$BrewParamValueCopyWith<$Res> implements $BrewParamValueCopyWith<$Res> {
  factory _$BrewParamValueCopyWith(_BrewParamValue value, $Res Function(_BrewParamValue) _then) = __$BrewParamValueCopyWithImpl;
@override @useResult
$Res call({
 int id, int brewRecordId, int paramId, double? valueNumber, String? valueText
});




}
/// @nodoc
class __$BrewParamValueCopyWithImpl<$Res>
    implements _$BrewParamValueCopyWith<$Res> {
  __$BrewParamValueCopyWithImpl(this._self, this._then);

  final _BrewParamValue _self;
  final $Res Function(_BrewParamValue) _then;

/// Create a copy of BrewParamValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brewRecordId = null,Object? paramId = null,Object? valueNumber = freezed,Object? valueText = freezed,}) {
  return _then(_BrewParamValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewRecordId: null == brewRecordId ? _self.brewRecordId : brewRecordId // ignore: cast_nullable_to_non_nullable
as int,paramId: null == paramId ? _self.paramId : paramId // ignore: cast_nullable_to_non_nullable
as int,valueNumber: freezed == valueNumber ? _self.valueNumber : valueNumber // ignore: cast_nullable_to_non_nullable
as double?,valueText: freezed == valueText ? _self.valueText : valueText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
