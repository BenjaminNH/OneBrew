// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewSummary {

/// The brew record's unique identifier.
 int get id;/// Timestamp of the brew session.
 DateTime get brewDate;/// Name of the coffee bean used.
 String get beanName;/// Roaster name (if the bean has one recorded).
 String? get roaster;/// Total brew duration in seconds.
 int get brewDurationS;/// Coffee dose in grams.
 double get coffeeWeightG;/// Water weight in grams.
 double get waterWeightG;/// Quick score (1–5) from the associated rating, if any.
 int? get quickScore;/// Emoji label from the associated rating, if any.
 String? get emoji;/// Whether the brew was created in quick mode.
 bool get isQuickMode;/// Free-text notes, if any.
 String? get notes;
/// Create a copy of BrewSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewSummaryCopyWith<BrewSummary> get copyWith => _$BrewSummaryCopyWithImpl<BrewSummary>(this as BrewSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.brewDate, brewDate) || other.brewDate == brewDate)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.roaster, roaster) || other.roaster == roaster)&&(identical(other.brewDurationS, brewDurationS) || other.brewDurationS == brewDurationS)&&(identical(other.coffeeWeightG, coffeeWeightG) || other.coffeeWeightG == coffeeWeightG)&&(identical(other.waterWeightG, waterWeightG) || other.waterWeightG == waterWeightG)&&(identical(other.quickScore, quickScore) || other.quickScore == quickScore)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isQuickMode, isQuickMode) || other.isQuickMode == isQuickMode)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewDate,beanName,roaster,brewDurationS,coffeeWeightG,waterWeightG,quickScore,emoji,isQuickMode,notes);

@override
String toString() {
  return 'BrewSummary(id: $id, brewDate: $brewDate, beanName: $beanName, roaster: $roaster, brewDurationS: $brewDurationS, coffeeWeightG: $coffeeWeightG, waterWeightG: $waterWeightG, quickScore: $quickScore, emoji: $emoji, isQuickMode: $isQuickMode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $BrewSummaryCopyWith<$Res>  {
  factory $BrewSummaryCopyWith(BrewSummary value, $Res Function(BrewSummary) _then) = _$BrewSummaryCopyWithImpl;
@useResult
$Res call({
 int id, DateTime brewDate, String beanName, String? roaster, int brewDurationS, double coffeeWeightG, double waterWeightG, int? quickScore, String? emoji, bool isQuickMode, String? notes
});




}
/// @nodoc
class _$BrewSummaryCopyWithImpl<$Res>
    implements $BrewSummaryCopyWith<$Res> {
  _$BrewSummaryCopyWithImpl(this._self, this._then);

  final BrewSummary _self;
  final $Res Function(BrewSummary) _then;

/// Create a copy of BrewSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brewDate = null,Object? beanName = null,Object? roaster = freezed,Object? brewDurationS = null,Object? coffeeWeightG = null,Object? waterWeightG = null,Object? quickScore = freezed,Object? emoji = freezed,Object? isQuickMode = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewDate: null == brewDate ? _self.brewDate : brewDate // ignore: cast_nullable_to_non_nullable
as DateTime,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,roaster: freezed == roaster ? _self.roaster : roaster // ignore: cast_nullable_to_non_nullable
as String?,brewDurationS: null == brewDurationS ? _self.brewDurationS : brewDurationS // ignore: cast_nullable_to_non_nullable
as int,coffeeWeightG: null == coffeeWeightG ? _self.coffeeWeightG : coffeeWeightG // ignore: cast_nullable_to_non_nullable
as double,waterWeightG: null == waterWeightG ? _self.waterWeightG : waterWeightG // ignore: cast_nullable_to_non_nullable
as double,quickScore: freezed == quickScore ? _self.quickScore : quickScore // ignore: cast_nullable_to_non_nullable
as int?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,isQuickMode: null == isQuickMode ? _self.isQuickMode : isQuickMode // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewSummary].
extension BrewSummaryPatterns on BrewSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewSummary value)  $default,){
final _that = this;
switch (_that) {
case _BrewSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BrewSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime brewDate,  String beanName,  String? roaster,  int brewDurationS,  double coffeeWeightG,  double waterWeightG,  int? quickScore,  String? emoji,  bool isQuickMode,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewSummary() when $default != null:
return $default(_that.id,_that.brewDate,_that.beanName,_that.roaster,_that.brewDurationS,_that.coffeeWeightG,_that.waterWeightG,_that.quickScore,_that.emoji,_that.isQuickMode,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime brewDate,  String beanName,  String? roaster,  int brewDurationS,  double coffeeWeightG,  double waterWeightG,  int? quickScore,  String? emoji,  bool isQuickMode,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _BrewSummary():
return $default(_that.id,_that.brewDate,_that.beanName,_that.roaster,_that.brewDurationS,_that.coffeeWeightG,_that.waterWeightG,_that.quickScore,_that.emoji,_that.isQuickMode,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime brewDate,  String beanName,  String? roaster,  int brewDurationS,  double coffeeWeightG,  double waterWeightG,  int? quickScore,  String? emoji,  bool isQuickMode,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _BrewSummary() when $default != null:
return $default(_that.id,_that.brewDate,_that.beanName,_that.roaster,_that.brewDurationS,_that.coffeeWeightG,_that.waterWeightG,_that.quickScore,_that.emoji,_that.isQuickMode,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _BrewSummary implements BrewSummary {
  const _BrewSummary({required this.id, required this.brewDate, required this.beanName, this.roaster, required this.brewDurationS, required this.coffeeWeightG, required this.waterWeightG, this.quickScore, this.emoji, required this.isQuickMode, this.notes});
  

/// The brew record's unique identifier.
@override final  int id;
/// Timestamp of the brew session.
@override final  DateTime brewDate;
/// Name of the coffee bean used.
@override final  String beanName;
/// Roaster name (if the bean has one recorded).
@override final  String? roaster;
/// Total brew duration in seconds.
@override final  int brewDurationS;
/// Coffee dose in grams.
@override final  double coffeeWeightG;
/// Water weight in grams.
@override final  double waterWeightG;
/// Quick score (1–5) from the associated rating, if any.
@override final  int? quickScore;
/// Emoji label from the associated rating, if any.
@override final  String? emoji;
/// Whether the brew was created in quick mode.
@override final  bool isQuickMode;
/// Free-text notes, if any.
@override final  String? notes;

/// Create a copy of BrewSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewSummaryCopyWith<_BrewSummary> get copyWith => __$BrewSummaryCopyWithImpl<_BrewSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.brewDate, brewDate) || other.brewDate == brewDate)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.roaster, roaster) || other.roaster == roaster)&&(identical(other.brewDurationS, brewDurationS) || other.brewDurationS == brewDurationS)&&(identical(other.coffeeWeightG, coffeeWeightG) || other.coffeeWeightG == coffeeWeightG)&&(identical(other.waterWeightG, waterWeightG) || other.waterWeightG == waterWeightG)&&(identical(other.quickScore, quickScore) || other.quickScore == quickScore)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isQuickMode, isQuickMode) || other.isQuickMode == isQuickMode)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewDate,beanName,roaster,brewDurationS,coffeeWeightG,waterWeightG,quickScore,emoji,isQuickMode,notes);

@override
String toString() {
  return 'BrewSummary(id: $id, brewDate: $brewDate, beanName: $beanName, roaster: $roaster, brewDurationS: $brewDurationS, coffeeWeightG: $coffeeWeightG, waterWeightG: $waterWeightG, quickScore: $quickScore, emoji: $emoji, isQuickMode: $isQuickMode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$BrewSummaryCopyWith<$Res> implements $BrewSummaryCopyWith<$Res> {
  factory _$BrewSummaryCopyWith(_BrewSummary value, $Res Function(_BrewSummary) _then) = __$BrewSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime brewDate, String beanName, String? roaster, int brewDurationS, double coffeeWeightG, double waterWeightG, int? quickScore, String? emoji, bool isQuickMode, String? notes
});




}
/// @nodoc
class __$BrewSummaryCopyWithImpl<$Res>
    implements _$BrewSummaryCopyWith<$Res> {
  __$BrewSummaryCopyWithImpl(this._self, this._then);

  final _BrewSummary _self;
  final $Res Function(_BrewSummary) _then;

/// Create a copy of BrewSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brewDate = null,Object? beanName = null,Object? roaster = freezed,Object? brewDurationS = null,Object? coffeeWeightG = null,Object? waterWeightG = null,Object? quickScore = freezed,Object? emoji = freezed,Object? isQuickMode = null,Object? notes = freezed,}) {
  return _then(_BrewSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewDate: null == brewDate ? _self.brewDate : brewDate // ignore: cast_nullable_to_non_nullable
as DateTime,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,roaster: freezed == roaster ? _self.roaster : roaster // ignore: cast_nullable_to_non_nullable
as String?,brewDurationS: null == brewDurationS ? _self.brewDurationS : brewDurationS // ignore: cast_nullable_to_non_nullable
as int,coffeeWeightG: null == coffeeWeightG ? _self.coffeeWeightG : coffeeWeightG // ignore: cast_nullable_to_non_nullable
as double,waterWeightG: null == waterWeightG ? _self.waterWeightG : waterWeightG // ignore: cast_nullable_to_non_nullable
as double,quickScore: freezed == quickScore ? _self.quickScore : quickScore // ignore: cast_nullable_to_non_nullable
as int?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,isQuickMode: null == isQuickMode ? _self.isQuickMode : isQuickMode // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
