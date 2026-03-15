// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_rating.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewRating {

/// Unique identifier.
 int get id;/// FK: the brew record this rating belongs to.
 int get brewRecordId;/// Quick score 1–5 (optional).
 int? get quickScore;/// Emoji label for quick feedback (optional, e.g. "😍").
 String? get emoji;/// Acidity score 0–5 (professional mode, optional).
 double? get acidity;/// Sweetness score 0–5 (professional mode, optional).
 double? get sweetness;/// Bitterness score 0–5 (professional mode, optional).
 double? get bitterness;/// Body / mouthfeel score 0–5 (professional mode, optional).
 double? get body;/// Comma-separated (or JSON) flavor tag notes (optional).
 String? get flavorNotes;
/// Create a copy of BrewRating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewRatingCopyWith<BrewRating> get copyWith => _$BrewRatingCopyWithImpl<BrewRating>(this as BrewRating, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewRating&&(identical(other.id, id) || other.id == id)&&(identical(other.brewRecordId, brewRecordId) || other.brewRecordId == brewRecordId)&&(identical(other.quickScore, quickScore) || other.quickScore == quickScore)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.bitterness, bitterness) || other.bitterness == bitterness)&&(identical(other.body, body) || other.body == body)&&(identical(other.flavorNotes, flavorNotes) || other.flavorNotes == flavorNotes));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewRecordId,quickScore,emoji,acidity,sweetness,bitterness,body,flavorNotes);

@override
String toString() {
  return 'BrewRating(id: $id, brewRecordId: $brewRecordId, quickScore: $quickScore, emoji: $emoji, acidity: $acidity, sweetness: $sweetness, bitterness: $bitterness, body: $body, flavorNotes: $flavorNotes)';
}


}

/// @nodoc
abstract mixin class $BrewRatingCopyWith<$Res>  {
  factory $BrewRatingCopyWith(BrewRating value, $Res Function(BrewRating) _then) = _$BrewRatingCopyWithImpl;
@useResult
$Res call({
 int id, int brewRecordId, int? quickScore, String? emoji, double? acidity, double? sweetness, double? bitterness, double? body, String? flavorNotes
});




}
/// @nodoc
class _$BrewRatingCopyWithImpl<$Res>
    implements $BrewRatingCopyWith<$Res> {
  _$BrewRatingCopyWithImpl(this._self, this._then);

  final BrewRating _self;
  final $Res Function(BrewRating) _then;

/// Create a copy of BrewRating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brewRecordId = null,Object? quickScore = freezed,Object? emoji = freezed,Object? acidity = freezed,Object? sweetness = freezed,Object? bitterness = freezed,Object? body = freezed,Object? flavorNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewRecordId: null == brewRecordId ? _self.brewRecordId : brewRecordId // ignore: cast_nullable_to_non_nullable
as int,quickScore: freezed == quickScore ? _self.quickScore : quickScore // ignore: cast_nullable_to_non_nullable
as int?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as double?,sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as double?,bitterness: freezed == bitterness ? _self.bitterness : bitterness // ignore: cast_nullable_to_non_nullable
as double?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as double?,flavorNotes: freezed == flavorNotes ? _self.flavorNotes : flavorNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewRating].
extension BrewRatingPatterns on BrewRating {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewRating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewRating() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewRating value)  $default,){
final _that = this;
switch (_that) {
case _BrewRating():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewRating value)?  $default,){
final _that = this;
switch (_that) {
case _BrewRating() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int brewRecordId,  int? quickScore,  String? emoji,  double? acidity,  double? sweetness,  double? bitterness,  double? body,  String? flavorNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewRating() when $default != null:
return $default(_that.id,_that.brewRecordId,_that.quickScore,_that.emoji,_that.acidity,_that.sweetness,_that.bitterness,_that.body,_that.flavorNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int brewRecordId,  int? quickScore,  String? emoji,  double? acidity,  double? sweetness,  double? bitterness,  double? body,  String? flavorNotes)  $default,) {final _that = this;
switch (_that) {
case _BrewRating():
return $default(_that.id,_that.brewRecordId,_that.quickScore,_that.emoji,_that.acidity,_that.sweetness,_that.bitterness,_that.body,_that.flavorNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int brewRecordId,  int? quickScore,  String? emoji,  double? acidity,  double? sweetness,  double? bitterness,  double? body,  String? flavorNotes)?  $default,) {final _that = this;
switch (_that) {
case _BrewRating() when $default != null:
return $default(_that.id,_that.brewRecordId,_that.quickScore,_that.emoji,_that.acidity,_that.sweetness,_that.bitterness,_that.body,_that.flavorNotes);case _:
  return null;

}
}

}

/// @nodoc


class _BrewRating implements BrewRating {
  const _BrewRating({required this.id, required this.brewRecordId, this.quickScore, this.emoji, this.acidity, this.sweetness, this.bitterness, this.body, this.flavorNotes});
  

/// Unique identifier.
@override final  int id;
/// FK: the brew record this rating belongs to.
@override final  int brewRecordId;
/// Quick score 1–5 (optional).
@override final  int? quickScore;
/// Emoji label for quick feedback (optional, e.g. "😍").
@override final  String? emoji;
/// Acidity score 0–5 (professional mode, optional).
@override final  double? acidity;
/// Sweetness score 0–5 (professional mode, optional).
@override final  double? sweetness;
/// Bitterness score 0–5 (professional mode, optional).
@override final  double? bitterness;
/// Body / mouthfeel score 0–5 (professional mode, optional).
@override final  double? body;
/// Comma-separated (or JSON) flavor tag notes (optional).
@override final  String? flavorNotes;

/// Create a copy of BrewRating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewRatingCopyWith<_BrewRating> get copyWith => __$BrewRatingCopyWithImpl<_BrewRating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewRating&&(identical(other.id, id) || other.id == id)&&(identical(other.brewRecordId, brewRecordId) || other.brewRecordId == brewRecordId)&&(identical(other.quickScore, quickScore) || other.quickScore == quickScore)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.bitterness, bitterness) || other.bitterness == bitterness)&&(identical(other.body, body) || other.body == body)&&(identical(other.flavorNotes, flavorNotes) || other.flavorNotes == flavorNotes));
}


@override
int get hashCode => Object.hash(runtimeType,id,brewRecordId,quickScore,emoji,acidity,sweetness,bitterness,body,flavorNotes);

@override
String toString() {
  return 'BrewRating(id: $id, brewRecordId: $brewRecordId, quickScore: $quickScore, emoji: $emoji, acidity: $acidity, sweetness: $sweetness, bitterness: $bitterness, body: $body, flavorNotes: $flavorNotes)';
}


}

/// @nodoc
abstract mixin class _$BrewRatingCopyWith<$Res> implements $BrewRatingCopyWith<$Res> {
  factory _$BrewRatingCopyWith(_BrewRating value, $Res Function(_BrewRating) _then) = __$BrewRatingCopyWithImpl;
@override @useResult
$Res call({
 int id, int brewRecordId, int? quickScore, String? emoji, double? acidity, double? sweetness, double? bitterness, double? body, String? flavorNotes
});




}
/// @nodoc
class __$BrewRatingCopyWithImpl<$Res>
    implements _$BrewRatingCopyWith<$Res> {
  __$BrewRatingCopyWithImpl(this._self, this._then);

  final _BrewRating _self;
  final $Res Function(_BrewRating) _then;

/// Create a copy of BrewRating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brewRecordId = null,Object? quickScore = freezed,Object? emoji = freezed,Object? acidity = freezed,Object? sweetness = freezed,Object? bitterness = freezed,Object? body = freezed,Object? flavorNotes = freezed,}) {
  return _then(_BrewRating(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewRecordId: null == brewRecordId ? _self.brewRecordId : brewRecordId // ignore: cast_nullable_to_non_nullable
as int,quickScore: freezed == quickScore ? _self.quickScore : quickScore // ignore: cast_nullable_to_non_nullable
as int?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as double?,sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as double?,bitterness: freezed == bitterness ? _self.bitterness : bitterness // ignore: cast_nullable_to_non_nullable
as double?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as double?,flavorNotes: freezed == flavorNotes ? _self.flavorNotes : flavorNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
