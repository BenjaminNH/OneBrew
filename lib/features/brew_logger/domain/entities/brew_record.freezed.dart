// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brew_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrewRecord {

/// Unique identifier (matches the Drift table PK).
 int get id;/// Timestamp of the brew session.
 DateTime get brewDate;/// Name of the coffee bean used (FK to Bean.name).
 String get beanName;/// Optional FK to equipment (grinder) used.
 int? get equipmentId;/// Brew method classification for this record.
 BrewMethod get brewMethod;/// Which grind-mode was used for this brew.
 GrindMode get grindMode;/// Grinder click value when [grindMode] == [GrindMode.equipment].
 double? get grindClickValue;/// Coarse label when [grindMode] == [GrindMode.simple].
/// e.g. "medium-fine", "coarse".
 String? get grindSimpleLabel;/// Particle size (μm) when [grindMode] == [GrindMode.pro].
 int? get grindMicrons;/// Coffee dose in grams.
 double get coffeeWeightG;/// Water weight in grams.
 double get waterWeightG;/// Water temperature in °C (optional).
 double? get waterTempC;/// Total brew duration in seconds.
 int get brewDurationS;/// Bloom (pre-infusion) time in seconds (optional).
 int? get bloomTimeS;/// Pour method description (optional).
 String? get pourMethod;/// Water type / source description (optional).
 String? get waterType;/// Room temperature in °C (optional).
 double? get roomTempC;/// Free-text notes (optional).
 String? get notes;/// Record creation timestamp.
 DateTime get createdAt;/// Record last-update timestamp.
 DateTime get updatedAt;
/// Create a copy of BrewRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrewRecordCopyWith<BrewRecord> get copyWith => _$BrewRecordCopyWithImpl<BrewRecord>(this as BrewRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrewRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.brewDate, brewDate) || other.brewDate == brewDate)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.equipmentId, equipmentId) || other.equipmentId == equipmentId)&&(identical(other.brewMethod, brewMethod) || other.brewMethod == brewMethod)&&(identical(other.grindMode, grindMode) || other.grindMode == grindMode)&&(identical(other.grindClickValue, grindClickValue) || other.grindClickValue == grindClickValue)&&(identical(other.grindSimpleLabel, grindSimpleLabel) || other.grindSimpleLabel == grindSimpleLabel)&&(identical(other.grindMicrons, grindMicrons) || other.grindMicrons == grindMicrons)&&(identical(other.coffeeWeightG, coffeeWeightG) || other.coffeeWeightG == coffeeWeightG)&&(identical(other.waterWeightG, waterWeightG) || other.waterWeightG == waterWeightG)&&(identical(other.waterTempC, waterTempC) || other.waterTempC == waterTempC)&&(identical(other.brewDurationS, brewDurationS) || other.brewDurationS == brewDurationS)&&(identical(other.bloomTimeS, bloomTimeS) || other.bloomTimeS == bloomTimeS)&&(identical(other.pourMethod, pourMethod) || other.pourMethod == pourMethod)&&(identical(other.waterType, waterType) || other.waterType == waterType)&&(identical(other.roomTempC, roomTempC) || other.roomTempC == roomTempC)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,brewDate,beanName,equipmentId,brewMethod,grindMode,grindClickValue,grindSimpleLabel,grindMicrons,coffeeWeightG,waterWeightG,waterTempC,brewDurationS,bloomTimeS,pourMethod,waterType,roomTempC,notes,createdAt,updatedAt]);

@override
String toString() {
  return 'BrewRecord(id: $id, brewDate: $brewDate, beanName: $beanName, equipmentId: $equipmentId, brewMethod: $brewMethod, grindMode: $grindMode, grindClickValue: $grindClickValue, grindSimpleLabel: $grindSimpleLabel, grindMicrons: $grindMicrons, coffeeWeightG: $coffeeWeightG, waterWeightG: $waterWeightG, waterTempC: $waterTempC, brewDurationS: $brewDurationS, bloomTimeS: $bloomTimeS, pourMethod: $pourMethod, waterType: $waterType, roomTempC: $roomTempC, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BrewRecordCopyWith<$Res>  {
  factory $BrewRecordCopyWith(BrewRecord value, $Res Function(BrewRecord) _then) = _$BrewRecordCopyWithImpl;
@useResult
$Res call({
 int id, DateTime brewDate, String beanName, int? equipmentId, BrewMethod brewMethod, GrindMode grindMode, double? grindClickValue, String? grindSimpleLabel, int? grindMicrons, double coffeeWeightG, double waterWeightG, double? waterTempC, int brewDurationS, int? bloomTimeS, String? pourMethod, String? waterType, double? roomTempC, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$BrewRecordCopyWithImpl<$Res>
    implements $BrewRecordCopyWith<$Res> {
  _$BrewRecordCopyWithImpl(this._self, this._then);

  final BrewRecord _self;
  final $Res Function(BrewRecord) _then;

/// Create a copy of BrewRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brewDate = null,Object? beanName = null,Object? equipmentId = freezed,Object? brewMethod = null,Object? grindMode = null,Object? grindClickValue = freezed,Object? grindSimpleLabel = freezed,Object? grindMicrons = freezed,Object? coffeeWeightG = null,Object? waterWeightG = null,Object? waterTempC = freezed,Object? brewDurationS = null,Object? bloomTimeS = freezed,Object? pourMethod = freezed,Object? waterType = freezed,Object? roomTempC = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewDate: null == brewDate ? _self.brewDate : brewDate // ignore: cast_nullable_to_non_nullable
as DateTime,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,equipmentId: freezed == equipmentId ? _self.equipmentId : equipmentId // ignore: cast_nullable_to_non_nullable
as int?,brewMethod: null == brewMethod ? _self.brewMethod : brewMethod // ignore: cast_nullable_to_non_nullable
as BrewMethod,grindMode: null == grindMode ? _self.grindMode : grindMode // ignore: cast_nullable_to_non_nullable
as GrindMode,grindClickValue: freezed == grindClickValue ? _self.grindClickValue : grindClickValue // ignore: cast_nullable_to_non_nullable
as double?,grindSimpleLabel: freezed == grindSimpleLabel ? _self.grindSimpleLabel : grindSimpleLabel // ignore: cast_nullable_to_non_nullable
as String?,grindMicrons: freezed == grindMicrons ? _self.grindMicrons : grindMicrons // ignore: cast_nullable_to_non_nullable
as int?,coffeeWeightG: null == coffeeWeightG ? _self.coffeeWeightG : coffeeWeightG // ignore: cast_nullable_to_non_nullable
as double,waterWeightG: null == waterWeightG ? _self.waterWeightG : waterWeightG // ignore: cast_nullable_to_non_nullable
as double,waterTempC: freezed == waterTempC ? _self.waterTempC : waterTempC // ignore: cast_nullable_to_non_nullable
as double?,brewDurationS: null == brewDurationS ? _self.brewDurationS : brewDurationS // ignore: cast_nullable_to_non_nullable
as int,bloomTimeS: freezed == bloomTimeS ? _self.bloomTimeS : bloomTimeS // ignore: cast_nullable_to_non_nullable
as int?,pourMethod: freezed == pourMethod ? _self.pourMethod : pourMethod // ignore: cast_nullable_to_non_nullable
as String?,waterType: freezed == waterType ? _self.waterType : waterType // ignore: cast_nullable_to_non_nullable
as String?,roomTempC: freezed == roomTempC ? _self.roomTempC : roomTempC // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BrewRecord].
extension BrewRecordPatterns on BrewRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrewRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrewRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrewRecord value)  $default,){
final _that = this;
switch (_that) {
case _BrewRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrewRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BrewRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime brewDate,  String beanName,  int? equipmentId,  BrewMethod brewMethod,  GrindMode grindMode,  double? grindClickValue,  String? grindSimpleLabel,  int? grindMicrons,  double coffeeWeightG,  double waterWeightG,  double? waterTempC,  int brewDurationS,  int? bloomTimeS,  String? pourMethod,  String? waterType,  double? roomTempC,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrewRecord() when $default != null:
return $default(_that.id,_that.brewDate,_that.beanName,_that.equipmentId,_that.brewMethod,_that.grindMode,_that.grindClickValue,_that.grindSimpleLabel,_that.grindMicrons,_that.coffeeWeightG,_that.waterWeightG,_that.waterTempC,_that.brewDurationS,_that.bloomTimeS,_that.pourMethod,_that.waterType,_that.roomTempC,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime brewDate,  String beanName,  int? equipmentId,  BrewMethod brewMethod,  GrindMode grindMode,  double? grindClickValue,  String? grindSimpleLabel,  int? grindMicrons,  double coffeeWeightG,  double waterWeightG,  double? waterTempC,  int brewDurationS,  int? bloomTimeS,  String? pourMethod,  String? waterType,  double? roomTempC,  String? notes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BrewRecord():
return $default(_that.id,_that.brewDate,_that.beanName,_that.equipmentId,_that.brewMethod,_that.grindMode,_that.grindClickValue,_that.grindSimpleLabel,_that.grindMicrons,_that.coffeeWeightG,_that.waterWeightG,_that.waterTempC,_that.brewDurationS,_that.bloomTimeS,_that.pourMethod,_that.waterType,_that.roomTempC,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime brewDate,  String beanName,  int? equipmentId,  BrewMethod brewMethod,  GrindMode grindMode,  double? grindClickValue,  String? grindSimpleLabel,  int? grindMicrons,  double coffeeWeightG,  double waterWeightG,  double? waterTempC,  int brewDurationS,  int? bloomTimeS,  String? pourMethod,  String? waterType,  double? roomTempC,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BrewRecord() when $default != null:
return $default(_that.id,_that.brewDate,_that.beanName,_that.equipmentId,_that.brewMethod,_that.grindMode,_that.grindClickValue,_that.grindSimpleLabel,_that.grindMicrons,_that.coffeeWeightG,_that.waterWeightG,_that.waterTempC,_that.brewDurationS,_that.bloomTimeS,_that.pourMethod,_that.waterType,_that.roomTempC,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BrewRecord implements BrewRecord {
  const _BrewRecord({required this.id, required this.brewDate, required this.beanName, this.equipmentId, required this.brewMethod, required this.grindMode, this.grindClickValue, this.grindSimpleLabel, this.grindMicrons, required this.coffeeWeightG, required this.waterWeightG, this.waterTempC, required this.brewDurationS, this.bloomTimeS, this.pourMethod, this.waterType, this.roomTempC, this.notes, required this.createdAt, required this.updatedAt});
  

/// Unique identifier (matches the Drift table PK).
@override final  int id;
/// Timestamp of the brew session.
@override final  DateTime brewDate;
/// Name of the coffee bean used (FK to Bean.name).
@override final  String beanName;
/// Optional FK to equipment (grinder) used.
@override final  int? equipmentId;
/// Brew method classification for this record.
@override final  BrewMethod brewMethod;
/// Which grind-mode was used for this brew.
@override final  GrindMode grindMode;
/// Grinder click value when [grindMode] == [GrindMode.equipment].
@override final  double? grindClickValue;
/// Coarse label when [grindMode] == [GrindMode.simple].
/// e.g. "medium-fine", "coarse".
@override final  String? grindSimpleLabel;
/// Particle size (μm) when [grindMode] == [GrindMode.pro].
@override final  int? grindMicrons;
/// Coffee dose in grams.
@override final  double coffeeWeightG;
/// Water weight in grams.
@override final  double waterWeightG;
/// Water temperature in °C (optional).
@override final  double? waterTempC;
/// Total brew duration in seconds.
@override final  int brewDurationS;
/// Bloom (pre-infusion) time in seconds (optional).
@override final  int? bloomTimeS;
/// Pour method description (optional).
@override final  String? pourMethod;
/// Water type / source description (optional).
@override final  String? waterType;
/// Room temperature in °C (optional).
@override final  double? roomTempC;
/// Free-text notes (optional).
@override final  String? notes;
/// Record creation timestamp.
@override final  DateTime createdAt;
/// Record last-update timestamp.
@override final  DateTime updatedAt;

/// Create a copy of BrewRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrewRecordCopyWith<_BrewRecord> get copyWith => __$BrewRecordCopyWithImpl<_BrewRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrewRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.brewDate, brewDate) || other.brewDate == brewDate)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.equipmentId, equipmentId) || other.equipmentId == equipmentId)&&(identical(other.brewMethod, brewMethod) || other.brewMethod == brewMethod)&&(identical(other.grindMode, grindMode) || other.grindMode == grindMode)&&(identical(other.grindClickValue, grindClickValue) || other.grindClickValue == grindClickValue)&&(identical(other.grindSimpleLabel, grindSimpleLabel) || other.grindSimpleLabel == grindSimpleLabel)&&(identical(other.grindMicrons, grindMicrons) || other.grindMicrons == grindMicrons)&&(identical(other.coffeeWeightG, coffeeWeightG) || other.coffeeWeightG == coffeeWeightG)&&(identical(other.waterWeightG, waterWeightG) || other.waterWeightG == waterWeightG)&&(identical(other.waterTempC, waterTempC) || other.waterTempC == waterTempC)&&(identical(other.brewDurationS, brewDurationS) || other.brewDurationS == brewDurationS)&&(identical(other.bloomTimeS, bloomTimeS) || other.bloomTimeS == bloomTimeS)&&(identical(other.pourMethod, pourMethod) || other.pourMethod == pourMethod)&&(identical(other.waterType, waterType) || other.waterType == waterType)&&(identical(other.roomTempC, roomTempC) || other.roomTempC == roomTempC)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,brewDate,beanName,equipmentId,brewMethod,grindMode,grindClickValue,grindSimpleLabel,grindMicrons,coffeeWeightG,waterWeightG,waterTempC,brewDurationS,bloomTimeS,pourMethod,waterType,roomTempC,notes,createdAt,updatedAt]);

@override
String toString() {
  return 'BrewRecord(id: $id, brewDate: $brewDate, beanName: $beanName, equipmentId: $equipmentId, brewMethod: $brewMethod, grindMode: $grindMode, grindClickValue: $grindClickValue, grindSimpleLabel: $grindSimpleLabel, grindMicrons: $grindMicrons, coffeeWeightG: $coffeeWeightG, waterWeightG: $waterWeightG, waterTempC: $waterTempC, brewDurationS: $brewDurationS, bloomTimeS: $bloomTimeS, pourMethod: $pourMethod, waterType: $waterType, roomTempC: $roomTempC, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BrewRecordCopyWith<$Res> implements $BrewRecordCopyWith<$Res> {
  factory _$BrewRecordCopyWith(_BrewRecord value, $Res Function(_BrewRecord) _then) = __$BrewRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime brewDate, String beanName, int? equipmentId, BrewMethod brewMethod, GrindMode grindMode, double? grindClickValue, String? grindSimpleLabel, int? grindMicrons, double coffeeWeightG, double waterWeightG, double? waterTempC, int brewDurationS, int? bloomTimeS, String? pourMethod, String? waterType, double? roomTempC, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$BrewRecordCopyWithImpl<$Res>
    implements _$BrewRecordCopyWith<$Res> {
  __$BrewRecordCopyWithImpl(this._self, this._then);

  final _BrewRecord _self;
  final $Res Function(_BrewRecord) _then;

/// Create a copy of BrewRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brewDate = null,Object? beanName = null,Object? equipmentId = freezed,Object? brewMethod = null,Object? grindMode = null,Object? grindClickValue = freezed,Object? grindSimpleLabel = freezed,Object? grindMicrons = freezed,Object? coffeeWeightG = null,Object? waterWeightG = null,Object? waterTempC = freezed,Object? brewDurationS = null,Object? bloomTimeS = freezed,Object? pourMethod = freezed,Object? waterType = freezed,Object? roomTempC = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_BrewRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,brewDate: null == brewDate ? _self.brewDate : brewDate // ignore: cast_nullable_to_non_nullable
as DateTime,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,equipmentId: freezed == equipmentId ? _self.equipmentId : equipmentId // ignore: cast_nullable_to_non_nullable
as int?,brewMethod: null == brewMethod ? _self.brewMethod : brewMethod // ignore: cast_nullable_to_non_nullable
as BrewMethod,grindMode: null == grindMode ? _self.grindMode : grindMode // ignore: cast_nullable_to_non_nullable
as GrindMode,grindClickValue: freezed == grindClickValue ? _self.grindClickValue : grindClickValue // ignore: cast_nullable_to_non_nullable
as double?,grindSimpleLabel: freezed == grindSimpleLabel ? _self.grindSimpleLabel : grindSimpleLabel // ignore: cast_nullable_to_non_nullable
as String?,grindMicrons: freezed == grindMicrons ? _self.grindMicrons : grindMicrons // ignore: cast_nullable_to_non_nullable
as int?,coffeeWeightG: null == coffeeWeightG ? _self.coffeeWeightG : coffeeWeightG // ignore: cast_nullable_to_non_nullable
as double,waterWeightG: null == waterWeightG ? _self.waterWeightG : waterWeightG // ignore: cast_nullable_to_non_nullable
as double,waterTempC: freezed == waterTempC ? _self.waterTempC : waterTempC // ignore: cast_nullable_to_non_nullable
as double?,brewDurationS: null == brewDurationS ? _self.brewDurationS : brewDurationS // ignore: cast_nullable_to_non_nullable
as int,bloomTimeS: freezed == bloomTimeS ? _self.bloomTimeS : bloomTimeS // ignore: cast_nullable_to_non_nullable
as int?,pourMethod: freezed == pourMethod ? _self.pourMethod : pourMethod // ignore: cast_nullable_to_non_nullable
as String?,waterType: freezed == waterType ? _self.waterType : waterType // ignore: cast_nullable_to_non_nullable
as String?,roomTempC: freezed == roomTempC ? _self.roomTempC : roomTempC // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
