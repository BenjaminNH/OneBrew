// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $BeansTable extends Beans with TableInfo<$BeansTable, Bean> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _roasterMeta = const VerificationMeta(
    'roaster',
  );
  @override
  late final GeneratedColumn<String> roaster = GeneratedColumn<String>(
    'roaster',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roastLevelMeta = const VerificationMeta(
    'roastLevel',
  );
  @override
  late final GeneratedColumn<String> roastLevel = GeneratedColumn<String>(
    'roast_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    roaster,
    origin,
    roastLevel,
    addedAt,
    useCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bean> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('roaster')) {
      context.handle(
        _roasterMeta,
        roaster.isAcceptableOrUnknown(data['roaster']!, _roasterMeta),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('roast_level')) {
      context.handle(
        _roastLevelMeta,
        roastLevel.isAcceptableOrUnknown(data['roast_level']!, _roastLevelMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bean map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bean(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      roaster: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roaster'],
      ),
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      roastLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roast_level'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
    );
  }

  @override
  $BeansTable createAlias(String alias) {
    return $BeansTable(attachedDatabase, alias);
  }
}

class Bean extends DataClass implements Insertable<Bean> {
  /// Auto-incremented primary key.
  final int id;

  /// Bean name, unique across all beans (e.g. "Ethiopia Yirgacheffe").
  final String name;

  /// Roaster / producer name (optional).
  final String? roaster;

  /// Origin / country of origin (optional).
  final String? origin;

  /// Roast level description (optional, e.g. "Light", "Medium").
  final String? roastLevel;

  /// Timestamp when this bean was first added to the inventory.
  final DateTime addedAt;

  /// Number of brew records that reference this bean.
  /// Used for smart autocomplete ordering.
  final int useCount;
  const Bean({
    required this.id,
    required this.name,
    this.roaster,
    this.origin,
    this.roastLevel,
    required this.addedAt,
    required this.useCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || roaster != null) {
      map['roaster'] = Variable<String>(roaster);
    }
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || roastLevel != null) {
      map['roast_level'] = Variable<String>(roastLevel);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['use_count'] = Variable<int>(useCount);
    return map;
  }

  BeansCompanion toCompanion(bool nullToAbsent) {
    return BeansCompanion(
      id: Value(id),
      name: Value(name),
      roaster: roaster == null && nullToAbsent
          ? const Value.absent()
          : Value(roaster),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      roastLevel: roastLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(roastLevel),
      addedAt: Value(addedAt),
      useCount: Value(useCount),
    );
  }

  factory Bean.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bean(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      roaster: serializer.fromJson<String?>(json['roaster']),
      origin: serializer.fromJson<String?>(json['origin']),
      roastLevel: serializer.fromJson<String?>(json['roastLevel']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      useCount: serializer.fromJson<int>(json['useCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'roaster': serializer.toJson<String?>(roaster),
      'origin': serializer.toJson<String?>(origin),
      'roastLevel': serializer.toJson<String?>(roastLevel),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'useCount': serializer.toJson<int>(useCount),
    };
  }

  Bean copyWith({
    int? id,
    String? name,
    Value<String?> roaster = const Value.absent(),
    Value<String?> origin = const Value.absent(),
    Value<String?> roastLevel = const Value.absent(),
    DateTime? addedAt,
    int? useCount,
  }) => Bean(
    id: id ?? this.id,
    name: name ?? this.name,
    roaster: roaster.present ? roaster.value : this.roaster,
    origin: origin.present ? origin.value : this.origin,
    roastLevel: roastLevel.present ? roastLevel.value : this.roastLevel,
    addedAt: addedAt ?? this.addedAt,
    useCount: useCount ?? this.useCount,
  );
  Bean copyWithCompanion(BeansCompanion data) {
    return Bean(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      roaster: data.roaster.present ? data.roaster.value : this.roaster,
      origin: data.origin.present ? data.origin.value : this.origin,
      roastLevel: data.roastLevel.present
          ? data.roastLevel.value
          : this.roastLevel,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bean(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('roaster: $roaster, ')
          ..write('origin: $origin, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('addedAt: $addedAt, ')
          ..write('useCount: $useCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, roaster, origin, roastLevel, addedAt, useCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bean &&
          other.id == this.id &&
          other.name == this.name &&
          other.roaster == this.roaster &&
          other.origin == this.origin &&
          other.roastLevel == this.roastLevel &&
          other.addedAt == this.addedAt &&
          other.useCount == this.useCount);
}

class BeansCompanion extends UpdateCompanion<Bean> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> roaster;
  final Value<String?> origin;
  final Value<String?> roastLevel;
  final Value<DateTime> addedAt;
  final Value<int> useCount;
  const BeansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.roaster = const Value.absent(),
    this.origin = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.useCount = const Value.absent(),
  });
  BeansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.roaster = const Value.absent(),
    this.origin = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.useCount = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Bean> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? roaster,
    Expression<String>? origin,
    Expression<String>? roastLevel,
    Expression<DateTime>? addedAt,
    Expression<int>? useCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (roaster != null) 'roaster': roaster,
      if (origin != null) 'origin': origin,
      if (roastLevel != null) 'roast_level': roastLevel,
      if (addedAt != null) 'added_at': addedAt,
      if (useCount != null) 'use_count': useCount,
    });
  }

  BeansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? roaster,
    Value<String?>? origin,
    Value<String?>? roastLevel,
    Value<DateTime>? addedAt,
    Value<int>? useCount,
  }) {
    return BeansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      roaster: roaster ?? this.roaster,
      origin: origin ?? this.origin,
      roastLevel: roastLevel ?? this.roastLevel,
      addedAt: addedAt ?? this.addedAt,
      useCount: useCount ?? this.useCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (roaster.present) {
      map['roaster'] = Variable<String>(roaster.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (roastLevel.present) {
      map['roast_level'] = Variable<String>(roastLevel.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('roaster: $roaster, ')
          ..write('origin: $origin, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('addedAt: $addedAt, ')
          ..write('useCount: $useCount')
          ..write(')'))
        .toString();
  }
}

class $EquipmentsTable extends Equipments
    with TableInfo<$EquipmentsTable, Equipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGrinderMeta = const VerificationMeta(
    'isGrinder',
  );
  @override
  late final GeneratedColumn<bool> isGrinder = GeneratedColumn<bool>(
    'is_grinder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_grinder" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _grindMinClickMeta = const VerificationMeta(
    'grindMinClick',
  );
  @override
  late final GeneratedColumn<double> grindMinClick = GeneratedColumn<double>(
    'grind_min_click',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindMaxClickMeta = const VerificationMeta(
    'grindMaxClick',
  );
  @override
  late final GeneratedColumn<double> grindMaxClick = GeneratedColumn<double>(
    'grind_max_click',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindClickStepMeta = const VerificationMeta(
    'grindClickStep',
  );
  @override
  late final GeneratedColumn<double> grindClickStep = GeneratedColumn<double>(
    'grind_click_step',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindClickUnitMeta = const VerificationMeta(
    'grindClickUnit',
  );
  @override
  late final GeneratedColumn<String> grindClickUnit = GeneratedColumn<String>(
    'grind_click_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    isGrinder,
    isDeleted,
    grindMinClick,
    grindMaxClick,
    grindClickStep,
    grindClickUnit,
    addedAt,
    useCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Equipment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_grinder')) {
      context.handle(
        _isGrinderMeta,
        isGrinder.isAcceptableOrUnknown(data['is_grinder']!, _isGrinderMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('grind_min_click')) {
      context.handle(
        _grindMinClickMeta,
        grindMinClick.isAcceptableOrUnknown(
          data['grind_min_click']!,
          _grindMinClickMeta,
        ),
      );
    }
    if (data.containsKey('grind_max_click')) {
      context.handle(
        _grindMaxClickMeta,
        grindMaxClick.isAcceptableOrUnknown(
          data['grind_max_click']!,
          _grindMaxClickMeta,
        ),
      );
    }
    if (data.containsKey('grind_click_step')) {
      context.handle(
        _grindClickStepMeta,
        grindClickStep.isAcceptableOrUnknown(
          data['grind_click_step']!,
          _grindClickStepMeta,
        ),
      );
    }
    if (data.containsKey('grind_click_unit')) {
      context.handle(
        _grindClickUnitMeta,
        grindClickUnit.isAcceptableOrUnknown(
          data['grind_click_unit']!,
          _grindClickUnitMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Equipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Equipment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      isGrinder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_grinder'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      grindMinClick: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grind_min_click'],
      ),
      grindMaxClick: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grind_max_click'],
      ),
      grindClickStep: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grind_click_step'],
      ),
      grindClickUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grind_click_unit'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
    );
  }

  @override
  $EquipmentsTable createAlias(String alias) {
    return $EquipmentsTable(attachedDatabase, alias);
  }
}

class Equipment extends DataClass implements Insertable<Equipment> {
  /// Auto-incremented primary key.
  final int id;

  /// Equipment name, unique (e.g. "Comandante C40", "V60").
  final String name;

  /// Category: 'grinder' | 'dripper' | 'kettle' | 'other' (optional).
  final String? category;

  /// Whether this equipment is a grinder.
  /// When true, grind-click fields are shown and the equipment-linked
  /// grind mode becomes available in BrewRecord.
  final bool isGrinder;

  /// Soft delete flag. Deleted equipment stays for historical records
  /// but is hidden from active inventory lists and suggestions.
  final bool isDeleted;

  /// Minimum grind click value for grinders (e.g. 0).
  final double? grindMinClick;

  /// Maximum grind click value for grinders (e.g. 40).
  final double? grindMaxClick;

  /// Step size between clicks (e.g. 1.0 or 0.5 for half-clicks).
  final double? grindClickStep;

  /// Label for the click unit (e.g. "clicks", "格", "数字").
  final String? grindClickUnit;

  /// Timestamp when this equipment was first added.
  final DateTime addedAt;

  /// Number of brew records that reference this equipment.
  final int useCount;
  const Equipment({
    required this.id,
    required this.name,
    this.category,
    required this.isGrinder,
    required this.isDeleted,
    this.grindMinClick,
    this.grindMaxClick,
    this.grindClickStep,
    this.grindClickUnit,
    required this.addedAt,
    required this.useCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_grinder'] = Variable<bool>(isGrinder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || grindMinClick != null) {
      map['grind_min_click'] = Variable<double>(grindMinClick);
    }
    if (!nullToAbsent || grindMaxClick != null) {
      map['grind_max_click'] = Variable<double>(grindMaxClick);
    }
    if (!nullToAbsent || grindClickStep != null) {
      map['grind_click_step'] = Variable<double>(grindClickStep);
    }
    if (!nullToAbsent || grindClickUnit != null) {
      map['grind_click_unit'] = Variable<String>(grindClickUnit);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['use_count'] = Variable<int>(useCount);
    return map;
  }

  EquipmentsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isGrinder: Value(isGrinder),
      isDeleted: Value(isDeleted),
      grindMinClick: grindMinClick == null && nullToAbsent
          ? const Value.absent()
          : Value(grindMinClick),
      grindMaxClick: grindMaxClick == null && nullToAbsent
          ? const Value.absent()
          : Value(grindMaxClick),
      grindClickStep: grindClickStep == null && nullToAbsent
          ? const Value.absent()
          : Value(grindClickStep),
      grindClickUnit: grindClickUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(grindClickUnit),
      addedAt: Value(addedAt),
      useCount: Value(useCount),
    );
  }

  factory Equipment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Equipment(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      isGrinder: serializer.fromJson<bool>(json['isGrinder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      grindMinClick: serializer.fromJson<double?>(json['grindMinClick']),
      grindMaxClick: serializer.fromJson<double?>(json['grindMaxClick']),
      grindClickStep: serializer.fromJson<double?>(json['grindClickStep']),
      grindClickUnit: serializer.fromJson<String?>(json['grindClickUnit']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      useCount: serializer.fromJson<int>(json['useCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'isGrinder': serializer.toJson<bool>(isGrinder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'grindMinClick': serializer.toJson<double?>(grindMinClick),
      'grindMaxClick': serializer.toJson<double?>(grindMaxClick),
      'grindClickStep': serializer.toJson<double?>(grindClickStep),
      'grindClickUnit': serializer.toJson<String?>(grindClickUnit),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'useCount': serializer.toJson<int>(useCount),
    };
  }

  Equipment copyWith({
    int? id,
    String? name,
    Value<String?> category = const Value.absent(),
    bool? isGrinder,
    bool? isDeleted,
    Value<double?> grindMinClick = const Value.absent(),
    Value<double?> grindMaxClick = const Value.absent(),
    Value<double?> grindClickStep = const Value.absent(),
    Value<String?> grindClickUnit = const Value.absent(),
    DateTime? addedAt,
    int? useCount,
  }) => Equipment(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    isGrinder: isGrinder ?? this.isGrinder,
    isDeleted: isDeleted ?? this.isDeleted,
    grindMinClick: grindMinClick.present
        ? grindMinClick.value
        : this.grindMinClick,
    grindMaxClick: grindMaxClick.present
        ? grindMaxClick.value
        : this.grindMaxClick,
    grindClickStep: grindClickStep.present
        ? grindClickStep.value
        : this.grindClickStep,
    grindClickUnit: grindClickUnit.present
        ? grindClickUnit.value
        : this.grindClickUnit,
    addedAt: addedAt ?? this.addedAt,
    useCount: useCount ?? this.useCount,
  );
  Equipment copyWithCompanion(EquipmentsCompanion data) {
    return Equipment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      isGrinder: data.isGrinder.present ? data.isGrinder.value : this.isGrinder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      grindMinClick: data.grindMinClick.present
          ? data.grindMinClick.value
          : this.grindMinClick,
      grindMaxClick: data.grindMaxClick.present
          ? data.grindMaxClick.value
          : this.grindMaxClick,
      grindClickStep: data.grindClickStep.present
          ? data.grindClickStep.value
          : this.grindClickStep,
      grindClickUnit: data.grindClickUnit.present
          ? data.grindClickUnit.value
          : this.grindClickUnit,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Equipment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isGrinder: $isGrinder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('grindMinClick: $grindMinClick, ')
          ..write('grindMaxClick: $grindMaxClick, ')
          ..write('grindClickStep: $grindClickStep, ')
          ..write('grindClickUnit: $grindClickUnit, ')
          ..write('addedAt: $addedAt, ')
          ..write('useCount: $useCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    isGrinder,
    isDeleted,
    grindMinClick,
    grindMaxClick,
    grindClickStep,
    grindClickUnit,
    addedAt,
    useCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Equipment &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.isGrinder == this.isGrinder &&
          other.isDeleted == this.isDeleted &&
          other.grindMinClick == this.grindMinClick &&
          other.grindMaxClick == this.grindMaxClick &&
          other.grindClickStep == this.grindClickStep &&
          other.grindClickUnit == this.grindClickUnit &&
          other.addedAt == this.addedAt &&
          other.useCount == this.useCount);
}

class EquipmentsCompanion extends UpdateCompanion<Equipment> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<bool> isGrinder;
  final Value<bool> isDeleted;
  final Value<double?> grindMinClick;
  final Value<double?> grindMaxClick;
  final Value<double?> grindClickStep;
  final Value<String?> grindClickUnit;
  final Value<DateTime> addedAt;
  final Value<int> useCount;
  const EquipmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.isGrinder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.grindMinClick = const Value.absent(),
    this.grindMaxClick = const Value.absent(),
    this.grindClickStep = const Value.absent(),
    this.grindClickUnit = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.useCount = const Value.absent(),
  });
  EquipmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.isGrinder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.grindMinClick = const Value.absent(),
    this.grindMaxClick = const Value.absent(),
    this.grindClickStep = const Value.absent(),
    this.grindClickUnit = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.useCount = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Equipment> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<bool>? isGrinder,
    Expression<bool>? isDeleted,
    Expression<double>? grindMinClick,
    Expression<double>? grindMaxClick,
    Expression<double>? grindClickStep,
    Expression<String>? grindClickUnit,
    Expression<DateTime>? addedAt,
    Expression<int>? useCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (isGrinder != null) 'is_grinder': isGrinder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (grindMinClick != null) 'grind_min_click': grindMinClick,
      if (grindMaxClick != null) 'grind_max_click': grindMaxClick,
      if (grindClickStep != null) 'grind_click_step': grindClickStep,
      if (grindClickUnit != null) 'grind_click_unit': grindClickUnit,
      if (addedAt != null) 'added_at': addedAt,
      if (useCount != null) 'use_count': useCount,
    });
  }

  EquipmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<bool>? isGrinder,
    Value<bool>? isDeleted,
    Value<double?>? grindMinClick,
    Value<double?>? grindMaxClick,
    Value<double?>? grindClickStep,
    Value<String?>? grindClickUnit,
    Value<DateTime>? addedAt,
    Value<int>? useCount,
  }) {
    return EquipmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isGrinder: isGrinder ?? this.isGrinder,
      isDeleted: isDeleted ?? this.isDeleted,
      grindMinClick: grindMinClick ?? this.grindMinClick,
      grindMaxClick: grindMaxClick ?? this.grindMaxClick,
      grindClickStep: grindClickStep ?? this.grindClickStep,
      grindClickUnit: grindClickUnit ?? this.grindClickUnit,
      addedAt: addedAt ?? this.addedAt,
      useCount: useCount ?? this.useCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isGrinder.present) {
      map['is_grinder'] = Variable<bool>(isGrinder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (grindMinClick.present) {
      map['grind_min_click'] = Variable<double>(grindMinClick.value);
    }
    if (grindMaxClick.present) {
      map['grind_max_click'] = Variable<double>(grindMaxClick.value);
    }
    if (grindClickStep.present) {
      map['grind_click_step'] = Variable<double>(grindClickStep.value);
    }
    if (grindClickUnit.present) {
      map['grind_click_unit'] = Variable<String>(grindClickUnit.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isGrinder: $isGrinder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('grindMinClick: $grindMinClick, ')
          ..write('grindMaxClick: $grindMaxClick, ')
          ..write('grindClickStep: $grindClickStep, ')
          ..write('grindClickUnit: $grindClickUnit, ')
          ..write('addedAt: $addedAt, ')
          ..write('useCount: $useCount')
          ..write(')'))
        .toString();
  }
}

class $BrewRecordsTable extends BrewRecords
    with TableInfo<$BrewRecordsTable, BrewRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brewDateMeta = const VerificationMeta(
    'brewDate',
  );
  @override
  late final GeneratedColumn<DateTime> brewDate = GeneratedColumn<DateTime>(
    'brew_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beanNameMeta = const VerificationMeta(
    'beanName',
  );
  @override
  late final GeneratedColumn<String> beanName = GeneratedColumn<String>(
    'bean_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipments (id)',
    ),
  );
  static const VerificationMeta _brewMethodMeta = const VerificationMeta(
    'brewMethod',
  );
  @override
  late final GeneratedColumn<String> brewMethod = GeneratedColumn<String>(
    'brew_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pour_over'),
  );
  static const VerificationMeta _grindModeMeta = const VerificationMeta(
    'grindMode',
  );
  @override
  late final GeneratedColumn<String> grindMode = GeneratedColumn<String>(
    'grind_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('equipment'),
  );
  static const VerificationMeta _grindClickValueMeta = const VerificationMeta(
    'grindClickValue',
  );
  @override
  late final GeneratedColumn<double> grindClickValue = GeneratedColumn<double>(
    'grind_click_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindSimpleLabelMeta = const VerificationMeta(
    'grindSimpleLabel',
  );
  @override
  late final GeneratedColumn<String> grindSimpleLabel = GeneratedColumn<String>(
    'grind_simple_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindMicronsMeta = const VerificationMeta(
    'grindMicrons',
  );
  @override
  late final GeneratedColumn<int> grindMicrons = GeneratedColumn<int>(
    'grind_microns',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coffeeWeightGMeta = const VerificationMeta(
    'coffeeWeightG',
  );
  @override
  late final GeneratedColumn<double> coffeeWeightG = GeneratedColumn<double>(
    'coffee_weight_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterWeightGMeta = const VerificationMeta(
    'waterWeightG',
  );
  @override
  late final GeneratedColumn<double> waterWeightG = GeneratedColumn<double>(
    'water_weight_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterTempCMeta = const VerificationMeta(
    'waterTempC',
  );
  @override
  late final GeneratedColumn<double> waterTempC = GeneratedColumn<double>(
    'water_temp_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brewDurationSMeta = const VerificationMeta(
    'brewDurationS',
  );
  @override
  late final GeneratedColumn<int> brewDurationS = GeneratedColumn<int>(
    'brew_duration_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloomTimeSMeta = const VerificationMeta(
    'bloomTimeS',
  );
  @override
  late final GeneratedColumn<int> bloomTimeS = GeneratedColumn<int>(
    'bloom_time_s',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pourMethodMeta = const VerificationMeta(
    'pourMethod',
  );
  @override
  late final GeneratedColumn<String> pourMethod = GeneratedColumn<String>(
    'pour_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterTypeMeta = const VerificationMeta(
    'waterType',
  );
  @override
  late final GeneratedColumn<String> waterType = GeneratedColumn<String>(
    'water_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomTempCMeta = const VerificationMeta(
    'roomTempC',
  );
  @override
  late final GeneratedColumn<double> roomTempC = GeneratedColumn<double>(
    'room_temp_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brewDate,
    beanName,
    equipmentId,
    brewMethod,
    grindMode,
    grindClickValue,
    grindSimpleLabel,
    grindMicrons,
    coffeeWeightG,
    waterWeightG,
    waterTempC,
    brewDurationS,
    bloomTimeS,
    pourMethod,
    waterType,
    roomTempC,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brew_date')) {
      context.handle(
        _brewDateMeta,
        brewDate.isAcceptableOrUnknown(data['brew_date']!, _brewDateMeta),
      );
    } else if (isInserting) {
      context.missing(_brewDateMeta);
    }
    if (data.containsKey('bean_name')) {
      context.handle(
        _beanNameMeta,
        beanName.isAcceptableOrUnknown(data['bean_name']!, _beanNameMeta),
      );
    } else if (isInserting) {
      context.missing(_beanNameMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    }
    if (data.containsKey('brew_method')) {
      context.handle(
        _brewMethodMeta,
        brewMethod.isAcceptableOrUnknown(data['brew_method']!, _brewMethodMeta),
      );
    }
    if (data.containsKey('grind_mode')) {
      context.handle(
        _grindModeMeta,
        grindMode.isAcceptableOrUnknown(data['grind_mode']!, _grindModeMeta),
      );
    }
    if (data.containsKey('grind_click_value')) {
      context.handle(
        _grindClickValueMeta,
        grindClickValue.isAcceptableOrUnknown(
          data['grind_click_value']!,
          _grindClickValueMeta,
        ),
      );
    }
    if (data.containsKey('grind_simple_label')) {
      context.handle(
        _grindSimpleLabelMeta,
        grindSimpleLabel.isAcceptableOrUnknown(
          data['grind_simple_label']!,
          _grindSimpleLabelMeta,
        ),
      );
    }
    if (data.containsKey('grind_microns')) {
      context.handle(
        _grindMicronsMeta,
        grindMicrons.isAcceptableOrUnknown(
          data['grind_microns']!,
          _grindMicronsMeta,
        ),
      );
    }
    if (data.containsKey('coffee_weight_g')) {
      context.handle(
        _coffeeWeightGMeta,
        coffeeWeightG.isAcceptableOrUnknown(
          data['coffee_weight_g']!,
          _coffeeWeightGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coffeeWeightGMeta);
    }
    if (data.containsKey('water_weight_g')) {
      context.handle(
        _waterWeightGMeta,
        waterWeightG.isAcceptableOrUnknown(
          data['water_weight_g']!,
          _waterWeightGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_waterWeightGMeta);
    }
    if (data.containsKey('water_temp_c')) {
      context.handle(
        _waterTempCMeta,
        waterTempC.isAcceptableOrUnknown(
          data['water_temp_c']!,
          _waterTempCMeta,
        ),
      );
    }
    if (data.containsKey('brew_duration_s')) {
      context.handle(
        _brewDurationSMeta,
        brewDurationS.isAcceptableOrUnknown(
          data['brew_duration_s']!,
          _brewDurationSMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brewDurationSMeta);
    }
    if (data.containsKey('bloom_time_s')) {
      context.handle(
        _bloomTimeSMeta,
        bloomTimeS.isAcceptableOrUnknown(
          data['bloom_time_s']!,
          _bloomTimeSMeta,
        ),
      );
    }
    if (data.containsKey('pour_method')) {
      context.handle(
        _pourMethodMeta,
        pourMethod.isAcceptableOrUnknown(data['pour_method']!, _pourMethodMeta),
      );
    }
    if (data.containsKey('water_type')) {
      context.handle(
        _waterTypeMeta,
        waterType.isAcceptableOrUnknown(data['water_type']!, _waterTypeMeta),
      );
    }
    if (data.containsKey('room_temp_c')) {
      context.handle(
        _roomTempCMeta,
        roomTempC.isAcceptableOrUnknown(data['room_temp_c']!, _roomTempCMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}brew_date'],
      )!,
      beanName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bean_name'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      ),
      brewMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brew_method'],
      )!,
      grindMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grind_mode'],
      )!,
      grindClickValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grind_click_value'],
      ),
      grindSimpleLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grind_simple_label'],
      ),
      grindMicrons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grind_microns'],
      ),
      coffeeWeightG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coffee_weight_g'],
      )!,
      waterWeightG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_weight_g'],
      )!,
      waterTempC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_temp_c'],
      ),
      brewDurationS: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brew_duration_s'],
      )!,
      bloomTimeS: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bloom_time_s'],
      ),
      pourMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pour_method'],
      ),
      waterType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_type'],
      ),
      roomTempC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}room_temp_c'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BrewRecordsTable createAlias(String alias) {
    return $BrewRecordsTable(attachedDatabase, alias);
  }
}

class BrewRecord extends DataClass implements Insertable<BrewRecord> {
  /// Auto-incremented primary key.
  final int id;

  /// Brew datetime (when the brew started).
  final DateTime brewDate;

  /// Bean name used in this brew (references Beans.name, stored as string).
  /// Stored as a name rather than FK to allow deletion of beans without
  /// losing historical brew records.
  final String beanName;

  /// Optional FK to Equipments — used for equipment-linked grind mode.
  final int? equipmentId;

  /// Brew method classification.
  /// One of: 'pour_over', 'espresso', 'custom'.
  final String brewMethod;

  /// Grind recording mode.
  /// Maps to [GrindMode] enum via text encoding.
  final String grindMode;

  /// Grind click value when grindMode == GrindMode.equipment.
  final double? grindClickValue;

  /// Grind label when grindMode == GrindMode.simple.
  /// One of the 7 standard labels (e.g. "Medium", "Fine").
  final String? grindSimpleLabel;

  /// Grind micron value when grindMode == GrindMode.pro.
  final int? grindMicrons;

  /// Coffee powder weight in grams.
  final double coffeeWeightG;

  /// Water weight in grams.
  final double waterWeightG;

  /// Water temperature in Celsius (optional).
  final double? waterTempC;

  /// Total brew duration in seconds.
  final int brewDurationS;

  /// Bloom time in seconds (optional pre-infusion).
  final int? bloomTimeS;

  /// Pour method description (e.g. "Spiral", "Pulse").
  final String? pourMethod;

  /// Water quality description (e.g. "Filtered", "Mineral").
  final String? waterType;

  /// Room temperature in Celsius at time of brew (optional).
  final double? roomTempC;

  /// Freeform notes about this brew.
  final String? notes;

  /// When this record row was created.
  final DateTime createdAt;

  /// When this record row was last updated.
  final DateTime updatedAt;
  const BrewRecord({
    required this.id,
    required this.brewDate,
    required this.beanName,
    this.equipmentId,
    required this.brewMethod,
    required this.grindMode,
    this.grindClickValue,
    this.grindSimpleLabel,
    this.grindMicrons,
    required this.coffeeWeightG,
    required this.waterWeightG,
    this.waterTempC,
    required this.brewDurationS,
    this.bloomTimeS,
    this.pourMethod,
    this.waterType,
    this.roomTempC,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brew_date'] = Variable<DateTime>(brewDate);
    map['bean_name'] = Variable<String>(beanName);
    if (!nullToAbsent || equipmentId != null) {
      map['equipment_id'] = Variable<int>(equipmentId);
    }
    map['brew_method'] = Variable<String>(brewMethod);
    map['grind_mode'] = Variable<String>(grindMode);
    if (!nullToAbsent || grindClickValue != null) {
      map['grind_click_value'] = Variable<double>(grindClickValue);
    }
    if (!nullToAbsent || grindSimpleLabel != null) {
      map['grind_simple_label'] = Variable<String>(grindSimpleLabel);
    }
    if (!nullToAbsent || grindMicrons != null) {
      map['grind_microns'] = Variable<int>(grindMicrons);
    }
    map['coffee_weight_g'] = Variable<double>(coffeeWeightG);
    map['water_weight_g'] = Variable<double>(waterWeightG);
    if (!nullToAbsent || waterTempC != null) {
      map['water_temp_c'] = Variable<double>(waterTempC);
    }
    map['brew_duration_s'] = Variable<int>(brewDurationS);
    if (!nullToAbsent || bloomTimeS != null) {
      map['bloom_time_s'] = Variable<int>(bloomTimeS);
    }
    if (!nullToAbsent || pourMethod != null) {
      map['pour_method'] = Variable<String>(pourMethod);
    }
    if (!nullToAbsent || waterType != null) {
      map['water_type'] = Variable<String>(waterType);
    }
    if (!nullToAbsent || roomTempC != null) {
      map['room_temp_c'] = Variable<double>(roomTempC);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BrewRecordsCompanion toCompanion(bool nullToAbsent) {
    return BrewRecordsCompanion(
      id: Value(id),
      brewDate: Value(brewDate),
      beanName: Value(beanName),
      equipmentId: equipmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentId),
      brewMethod: Value(brewMethod),
      grindMode: Value(grindMode),
      grindClickValue: grindClickValue == null && nullToAbsent
          ? const Value.absent()
          : Value(grindClickValue),
      grindSimpleLabel: grindSimpleLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(grindSimpleLabel),
      grindMicrons: grindMicrons == null && nullToAbsent
          ? const Value.absent()
          : Value(grindMicrons),
      coffeeWeightG: Value(coffeeWeightG),
      waterWeightG: Value(waterWeightG),
      waterTempC: waterTempC == null && nullToAbsent
          ? const Value.absent()
          : Value(waterTempC),
      brewDurationS: Value(brewDurationS),
      bloomTimeS: bloomTimeS == null && nullToAbsent
          ? const Value.absent()
          : Value(bloomTimeS),
      pourMethod: pourMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(pourMethod),
      waterType: waterType == null && nullToAbsent
          ? const Value.absent()
          : Value(waterType),
      roomTempC: roomTempC == null && nullToAbsent
          ? const Value.absent()
          : Value(roomTempC),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BrewRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewRecord(
      id: serializer.fromJson<int>(json['id']),
      brewDate: serializer.fromJson<DateTime>(json['brewDate']),
      beanName: serializer.fromJson<String>(json['beanName']),
      equipmentId: serializer.fromJson<int?>(json['equipmentId']),
      brewMethod: serializer.fromJson<String>(json['brewMethod']),
      grindMode: serializer.fromJson<String>(json['grindMode']),
      grindClickValue: serializer.fromJson<double?>(json['grindClickValue']),
      grindSimpleLabel: serializer.fromJson<String?>(json['grindSimpleLabel']),
      grindMicrons: serializer.fromJson<int?>(json['grindMicrons']),
      coffeeWeightG: serializer.fromJson<double>(json['coffeeWeightG']),
      waterWeightG: serializer.fromJson<double>(json['waterWeightG']),
      waterTempC: serializer.fromJson<double?>(json['waterTempC']),
      brewDurationS: serializer.fromJson<int>(json['brewDurationS']),
      bloomTimeS: serializer.fromJson<int?>(json['bloomTimeS']),
      pourMethod: serializer.fromJson<String?>(json['pourMethod']),
      waterType: serializer.fromJson<String?>(json['waterType']),
      roomTempC: serializer.fromJson<double?>(json['roomTempC']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brewDate': serializer.toJson<DateTime>(brewDate),
      'beanName': serializer.toJson<String>(beanName),
      'equipmentId': serializer.toJson<int?>(equipmentId),
      'brewMethod': serializer.toJson<String>(brewMethod),
      'grindMode': serializer.toJson<String>(grindMode),
      'grindClickValue': serializer.toJson<double?>(grindClickValue),
      'grindSimpleLabel': serializer.toJson<String?>(grindSimpleLabel),
      'grindMicrons': serializer.toJson<int?>(grindMicrons),
      'coffeeWeightG': serializer.toJson<double>(coffeeWeightG),
      'waterWeightG': serializer.toJson<double>(waterWeightG),
      'waterTempC': serializer.toJson<double?>(waterTempC),
      'brewDurationS': serializer.toJson<int>(brewDurationS),
      'bloomTimeS': serializer.toJson<int?>(bloomTimeS),
      'pourMethod': serializer.toJson<String?>(pourMethod),
      'waterType': serializer.toJson<String?>(waterType),
      'roomTempC': serializer.toJson<double?>(roomTempC),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BrewRecord copyWith({
    int? id,
    DateTime? brewDate,
    String? beanName,
    Value<int?> equipmentId = const Value.absent(),
    String? brewMethod,
    String? grindMode,
    Value<double?> grindClickValue = const Value.absent(),
    Value<String?> grindSimpleLabel = const Value.absent(),
    Value<int?> grindMicrons = const Value.absent(),
    double? coffeeWeightG,
    double? waterWeightG,
    Value<double?> waterTempC = const Value.absent(),
    int? brewDurationS,
    Value<int?> bloomTimeS = const Value.absent(),
    Value<String?> pourMethod = const Value.absent(),
    Value<String?> waterType = const Value.absent(),
    Value<double?> roomTempC = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BrewRecord(
    id: id ?? this.id,
    brewDate: brewDate ?? this.brewDate,
    beanName: beanName ?? this.beanName,
    equipmentId: equipmentId.present ? equipmentId.value : this.equipmentId,
    brewMethod: brewMethod ?? this.brewMethod,
    grindMode: grindMode ?? this.grindMode,
    grindClickValue: grindClickValue.present
        ? grindClickValue.value
        : this.grindClickValue,
    grindSimpleLabel: grindSimpleLabel.present
        ? grindSimpleLabel.value
        : this.grindSimpleLabel,
    grindMicrons: grindMicrons.present ? grindMicrons.value : this.grindMicrons,
    coffeeWeightG: coffeeWeightG ?? this.coffeeWeightG,
    waterWeightG: waterWeightG ?? this.waterWeightG,
    waterTempC: waterTempC.present ? waterTempC.value : this.waterTempC,
    brewDurationS: brewDurationS ?? this.brewDurationS,
    bloomTimeS: bloomTimeS.present ? bloomTimeS.value : this.bloomTimeS,
    pourMethod: pourMethod.present ? pourMethod.value : this.pourMethod,
    waterType: waterType.present ? waterType.value : this.waterType,
    roomTempC: roomTempC.present ? roomTempC.value : this.roomTempC,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BrewRecord copyWithCompanion(BrewRecordsCompanion data) {
    return BrewRecord(
      id: data.id.present ? data.id.value : this.id,
      brewDate: data.brewDate.present ? data.brewDate.value : this.brewDate,
      beanName: data.beanName.present ? data.beanName.value : this.beanName,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      brewMethod: data.brewMethod.present
          ? data.brewMethod.value
          : this.brewMethod,
      grindMode: data.grindMode.present ? data.grindMode.value : this.grindMode,
      grindClickValue: data.grindClickValue.present
          ? data.grindClickValue.value
          : this.grindClickValue,
      grindSimpleLabel: data.grindSimpleLabel.present
          ? data.grindSimpleLabel.value
          : this.grindSimpleLabel,
      grindMicrons: data.grindMicrons.present
          ? data.grindMicrons.value
          : this.grindMicrons,
      coffeeWeightG: data.coffeeWeightG.present
          ? data.coffeeWeightG.value
          : this.coffeeWeightG,
      waterWeightG: data.waterWeightG.present
          ? data.waterWeightG.value
          : this.waterWeightG,
      waterTempC: data.waterTempC.present
          ? data.waterTempC.value
          : this.waterTempC,
      brewDurationS: data.brewDurationS.present
          ? data.brewDurationS.value
          : this.brewDurationS,
      bloomTimeS: data.bloomTimeS.present
          ? data.bloomTimeS.value
          : this.bloomTimeS,
      pourMethod: data.pourMethod.present
          ? data.pourMethod.value
          : this.pourMethod,
      waterType: data.waterType.present ? data.waterType.value : this.waterType,
      roomTempC: data.roomTempC.present ? data.roomTempC.value : this.roomTempC,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewRecord(')
          ..write('id: $id, ')
          ..write('brewDate: $brewDate, ')
          ..write('beanName: $beanName, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('brewMethod: $brewMethod, ')
          ..write('grindMode: $grindMode, ')
          ..write('grindClickValue: $grindClickValue, ')
          ..write('grindSimpleLabel: $grindSimpleLabel, ')
          ..write('grindMicrons: $grindMicrons, ')
          ..write('coffeeWeightG: $coffeeWeightG, ')
          ..write('waterWeightG: $waterWeightG, ')
          ..write('waterTempC: $waterTempC, ')
          ..write('brewDurationS: $brewDurationS, ')
          ..write('bloomTimeS: $bloomTimeS, ')
          ..write('pourMethod: $pourMethod, ')
          ..write('waterType: $waterType, ')
          ..write('roomTempC: $roomTempC, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brewDate,
    beanName,
    equipmentId,
    brewMethod,
    grindMode,
    grindClickValue,
    grindSimpleLabel,
    grindMicrons,
    coffeeWeightG,
    waterWeightG,
    waterTempC,
    brewDurationS,
    bloomTimeS,
    pourMethod,
    waterType,
    roomTempC,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewRecord &&
          other.id == this.id &&
          other.brewDate == this.brewDate &&
          other.beanName == this.beanName &&
          other.equipmentId == this.equipmentId &&
          other.brewMethod == this.brewMethod &&
          other.grindMode == this.grindMode &&
          other.grindClickValue == this.grindClickValue &&
          other.grindSimpleLabel == this.grindSimpleLabel &&
          other.grindMicrons == this.grindMicrons &&
          other.coffeeWeightG == this.coffeeWeightG &&
          other.waterWeightG == this.waterWeightG &&
          other.waterTempC == this.waterTempC &&
          other.brewDurationS == this.brewDurationS &&
          other.bloomTimeS == this.bloomTimeS &&
          other.pourMethod == this.pourMethod &&
          other.waterType == this.waterType &&
          other.roomTempC == this.roomTempC &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BrewRecordsCompanion extends UpdateCompanion<BrewRecord> {
  final Value<int> id;
  final Value<DateTime> brewDate;
  final Value<String> beanName;
  final Value<int?> equipmentId;
  final Value<String> brewMethod;
  final Value<String> grindMode;
  final Value<double?> grindClickValue;
  final Value<String?> grindSimpleLabel;
  final Value<int?> grindMicrons;
  final Value<double> coffeeWeightG;
  final Value<double> waterWeightG;
  final Value<double?> waterTempC;
  final Value<int> brewDurationS;
  final Value<int?> bloomTimeS;
  final Value<String?> pourMethod;
  final Value<String?> waterType;
  final Value<double?> roomTempC;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BrewRecordsCompanion({
    this.id = const Value.absent(),
    this.brewDate = const Value.absent(),
    this.beanName = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.brewMethod = const Value.absent(),
    this.grindMode = const Value.absent(),
    this.grindClickValue = const Value.absent(),
    this.grindSimpleLabel = const Value.absent(),
    this.grindMicrons = const Value.absent(),
    this.coffeeWeightG = const Value.absent(),
    this.waterWeightG = const Value.absent(),
    this.waterTempC = const Value.absent(),
    this.brewDurationS = const Value.absent(),
    this.bloomTimeS = const Value.absent(),
    this.pourMethod = const Value.absent(),
    this.waterType = const Value.absent(),
    this.roomTempC = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BrewRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime brewDate,
    required String beanName,
    this.equipmentId = const Value.absent(),
    this.brewMethod = const Value.absent(),
    this.grindMode = const Value.absent(),
    this.grindClickValue = const Value.absent(),
    this.grindSimpleLabel = const Value.absent(),
    this.grindMicrons = const Value.absent(),
    required double coffeeWeightG,
    required double waterWeightG,
    this.waterTempC = const Value.absent(),
    required int brewDurationS,
    this.bloomTimeS = const Value.absent(),
    this.pourMethod = const Value.absent(),
    this.waterType = const Value.absent(),
    this.roomTempC = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : brewDate = Value(brewDate),
       beanName = Value(beanName),
       coffeeWeightG = Value(coffeeWeightG),
       waterWeightG = Value(waterWeightG),
       brewDurationS = Value(brewDurationS);
  static Insertable<BrewRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? brewDate,
    Expression<String>? beanName,
    Expression<int>? equipmentId,
    Expression<String>? brewMethod,
    Expression<String>? grindMode,
    Expression<double>? grindClickValue,
    Expression<String>? grindSimpleLabel,
    Expression<int>? grindMicrons,
    Expression<double>? coffeeWeightG,
    Expression<double>? waterWeightG,
    Expression<double>? waterTempC,
    Expression<int>? brewDurationS,
    Expression<int>? bloomTimeS,
    Expression<String>? pourMethod,
    Expression<String>? waterType,
    Expression<double>? roomTempC,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brewDate != null) 'brew_date': brewDate,
      if (beanName != null) 'bean_name': beanName,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (brewMethod != null) 'brew_method': brewMethod,
      if (grindMode != null) 'grind_mode': grindMode,
      if (grindClickValue != null) 'grind_click_value': grindClickValue,
      if (grindSimpleLabel != null) 'grind_simple_label': grindSimpleLabel,
      if (grindMicrons != null) 'grind_microns': grindMicrons,
      if (coffeeWeightG != null) 'coffee_weight_g': coffeeWeightG,
      if (waterWeightG != null) 'water_weight_g': waterWeightG,
      if (waterTempC != null) 'water_temp_c': waterTempC,
      if (brewDurationS != null) 'brew_duration_s': brewDurationS,
      if (bloomTimeS != null) 'bloom_time_s': bloomTimeS,
      if (pourMethod != null) 'pour_method': pourMethod,
      if (waterType != null) 'water_type': waterType,
      if (roomTempC != null) 'room_temp_c': roomTempC,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BrewRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? brewDate,
    Value<String>? beanName,
    Value<int?>? equipmentId,
    Value<String>? brewMethod,
    Value<String>? grindMode,
    Value<double?>? grindClickValue,
    Value<String?>? grindSimpleLabel,
    Value<int?>? grindMicrons,
    Value<double>? coffeeWeightG,
    Value<double>? waterWeightG,
    Value<double?>? waterTempC,
    Value<int>? brewDurationS,
    Value<int?>? bloomTimeS,
    Value<String?>? pourMethod,
    Value<String?>? waterType,
    Value<double?>? roomTempC,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BrewRecordsCompanion(
      id: id ?? this.id,
      brewDate: brewDate ?? this.brewDate,
      beanName: beanName ?? this.beanName,
      equipmentId: equipmentId ?? this.equipmentId,
      brewMethod: brewMethod ?? this.brewMethod,
      grindMode: grindMode ?? this.grindMode,
      grindClickValue: grindClickValue ?? this.grindClickValue,
      grindSimpleLabel: grindSimpleLabel ?? this.grindSimpleLabel,
      grindMicrons: grindMicrons ?? this.grindMicrons,
      coffeeWeightG: coffeeWeightG ?? this.coffeeWeightG,
      waterWeightG: waterWeightG ?? this.waterWeightG,
      waterTempC: waterTempC ?? this.waterTempC,
      brewDurationS: brewDurationS ?? this.brewDurationS,
      bloomTimeS: bloomTimeS ?? this.bloomTimeS,
      pourMethod: pourMethod ?? this.pourMethod,
      waterType: waterType ?? this.waterType,
      roomTempC: roomTempC ?? this.roomTempC,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brewDate.present) {
      map['brew_date'] = Variable<DateTime>(brewDate.value);
    }
    if (beanName.present) {
      map['bean_name'] = Variable<String>(beanName.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (brewMethod.present) {
      map['brew_method'] = Variable<String>(brewMethod.value);
    }
    if (grindMode.present) {
      map['grind_mode'] = Variable<String>(grindMode.value);
    }
    if (grindClickValue.present) {
      map['grind_click_value'] = Variable<double>(grindClickValue.value);
    }
    if (grindSimpleLabel.present) {
      map['grind_simple_label'] = Variable<String>(grindSimpleLabel.value);
    }
    if (grindMicrons.present) {
      map['grind_microns'] = Variable<int>(grindMicrons.value);
    }
    if (coffeeWeightG.present) {
      map['coffee_weight_g'] = Variable<double>(coffeeWeightG.value);
    }
    if (waterWeightG.present) {
      map['water_weight_g'] = Variable<double>(waterWeightG.value);
    }
    if (waterTempC.present) {
      map['water_temp_c'] = Variable<double>(waterTempC.value);
    }
    if (brewDurationS.present) {
      map['brew_duration_s'] = Variable<int>(brewDurationS.value);
    }
    if (bloomTimeS.present) {
      map['bloom_time_s'] = Variable<int>(bloomTimeS.value);
    }
    if (pourMethod.present) {
      map['pour_method'] = Variable<String>(pourMethod.value);
    }
    if (waterType.present) {
      map['water_type'] = Variable<String>(waterType.value);
    }
    if (roomTempC.present) {
      map['room_temp_c'] = Variable<double>(roomTempC.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewRecordsCompanion(')
          ..write('id: $id, ')
          ..write('brewDate: $brewDate, ')
          ..write('beanName: $beanName, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('brewMethod: $brewMethod, ')
          ..write('grindMode: $grindMode, ')
          ..write('grindClickValue: $grindClickValue, ')
          ..write('grindSimpleLabel: $grindSimpleLabel, ')
          ..write('grindMicrons: $grindMicrons, ')
          ..write('coffeeWeightG: $coffeeWeightG, ')
          ..write('waterWeightG: $waterWeightG, ')
          ..write('waterTempC: $waterTempC, ')
          ..write('brewDurationS: $brewDurationS, ')
          ..write('bloomTimeS: $bloomTimeS, ')
          ..write('pourMethod: $pourMethod, ')
          ..write('waterType: $waterType, ')
          ..write('roomTempC: $roomTempC, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BrewRatingsTable extends BrewRatings
    with TableInfo<$BrewRatingsTable, BrewRating> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewRatingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brewRecordIdMeta = const VerificationMeta(
    'brewRecordId',
  );
  @override
  late final GeneratedColumn<int> brewRecordId = GeneratedColumn<int>(
    'brew_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES brew_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _quickScoreMeta = const VerificationMeta(
    'quickScore',
  );
  @override
  late final GeneratedColumn<int> quickScore = GeneratedColumn<int>(
    'quick_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acidityMeta = const VerificationMeta(
    'acidity',
  );
  @override
  late final GeneratedColumn<double> acidity = GeneratedColumn<double>(
    'acidity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sweetnessMeta = const VerificationMeta(
    'sweetness',
  );
  @override
  late final GeneratedColumn<double> sweetness = GeneratedColumn<double>(
    'sweetness',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitternessMeta = const VerificationMeta(
    'bitterness',
  );
  @override
  late final GeneratedColumn<double> bitterness = GeneratedColumn<double>(
    'bitterness',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<double> body = GeneratedColumn<double>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flavorNotesMeta = const VerificationMeta(
    'flavorNotes',
  );
  @override
  late final GeneratedColumn<String> flavorNotes = GeneratedColumn<String>(
    'flavor_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brewRecordId,
    quickScore,
    emoji,
    acidity,
    sweetness,
    bitterness,
    body,
    flavorNotes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_ratings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewRating> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brew_record_id')) {
      context.handle(
        _brewRecordIdMeta,
        brewRecordId.isAcceptableOrUnknown(
          data['brew_record_id']!,
          _brewRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brewRecordIdMeta);
    }
    if (data.containsKey('quick_score')) {
      context.handle(
        _quickScoreMeta,
        quickScore.isAcceptableOrUnknown(data['quick_score']!, _quickScoreMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('acidity')) {
      context.handle(
        _acidityMeta,
        acidity.isAcceptableOrUnknown(data['acidity']!, _acidityMeta),
      );
    }
    if (data.containsKey('sweetness')) {
      context.handle(
        _sweetnessMeta,
        sweetness.isAcceptableOrUnknown(data['sweetness']!, _sweetnessMeta),
      );
    }
    if (data.containsKey('bitterness')) {
      context.handle(
        _bitternessMeta,
        bitterness.isAcceptableOrUnknown(data['bitterness']!, _bitternessMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('flavor_notes')) {
      context.handle(
        _flavorNotesMeta,
        flavorNotes.isAcceptableOrUnknown(
          data['flavor_notes']!,
          _flavorNotesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewRating map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewRating(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brewRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brew_record_id'],
      )!,
      quickScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quick_score'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      acidity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}acidity'],
      ),
      sweetness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sweetness'],
      ),
      bitterness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bitterness'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body'],
      ),
      flavorNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flavor_notes'],
      ),
    );
  }

  @override
  $BrewRatingsTable createAlias(String alias) {
    return $BrewRatingsTable(attachedDatabase, alias);
  }
}

class BrewRating extends DataClass implements Insertable<BrewRating> {
  /// Auto-incremented primary key.
  final int id;

  /// FK to [BrewRecords.id] — the brew being rated.
  /// Cascade deletes: removing a brew record removes its rating automatically.
  final int brewRecordId;

  /// Quick star score (1–5). Null if the user skipped quick rating.
  final int? quickScore;

  /// Emoji representing the tasting experience (e.g. "😊", "🥲").
  final String? emoji;

  /// Professional: acidity dimension (0.0–5.0).
  final double? acidity;

  /// Professional: sweetness dimension (0.0–5.0).
  final double? sweetness;

  /// Professional: bitterness dimension (0.0–5.0).
  final double? bitterness;

  /// Professional: body / mouthfeel dimension (0.0–5.0).
  final double? body;

  /// Comma-separated or JSON flavor note tags
  /// (e.g. "Citrus, Dark Chocolate, Floral").
  final String? flavorNotes;
  const BrewRating({
    required this.id,
    required this.brewRecordId,
    this.quickScore,
    this.emoji,
    this.acidity,
    this.sweetness,
    this.bitterness,
    this.body,
    this.flavorNotes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brew_record_id'] = Variable<int>(brewRecordId);
    if (!nullToAbsent || quickScore != null) {
      map['quick_score'] = Variable<int>(quickScore);
    }
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || acidity != null) {
      map['acidity'] = Variable<double>(acidity);
    }
    if (!nullToAbsent || sweetness != null) {
      map['sweetness'] = Variable<double>(sweetness);
    }
    if (!nullToAbsent || bitterness != null) {
      map['bitterness'] = Variable<double>(bitterness);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<double>(body);
    }
    if (!nullToAbsent || flavorNotes != null) {
      map['flavor_notes'] = Variable<String>(flavorNotes);
    }
    return map;
  }

  BrewRatingsCompanion toCompanion(bool nullToAbsent) {
    return BrewRatingsCompanion(
      id: Value(id),
      brewRecordId: Value(brewRecordId),
      quickScore: quickScore == null && nullToAbsent
          ? const Value.absent()
          : Value(quickScore),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      acidity: acidity == null && nullToAbsent
          ? const Value.absent()
          : Value(acidity),
      sweetness: sweetness == null && nullToAbsent
          ? const Value.absent()
          : Value(sweetness),
      bitterness: bitterness == null && nullToAbsent
          ? const Value.absent()
          : Value(bitterness),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      flavorNotes: flavorNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorNotes),
    );
  }

  factory BrewRating.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewRating(
      id: serializer.fromJson<int>(json['id']),
      brewRecordId: serializer.fromJson<int>(json['brewRecordId']),
      quickScore: serializer.fromJson<int?>(json['quickScore']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      acidity: serializer.fromJson<double?>(json['acidity']),
      sweetness: serializer.fromJson<double?>(json['sweetness']),
      bitterness: serializer.fromJson<double?>(json['bitterness']),
      body: serializer.fromJson<double?>(json['body']),
      flavorNotes: serializer.fromJson<String?>(json['flavorNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brewRecordId': serializer.toJson<int>(brewRecordId),
      'quickScore': serializer.toJson<int?>(quickScore),
      'emoji': serializer.toJson<String?>(emoji),
      'acidity': serializer.toJson<double?>(acidity),
      'sweetness': serializer.toJson<double?>(sweetness),
      'bitterness': serializer.toJson<double?>(bitterness),
      'body': serializer.toJson<double?>(body),
      'flavorNotes': serializer.toJson<String?>(flavorNotes),
    };
  }

  BrewRating copyWith({
    int? id,
    int? brewRecordId,
    Value<int?> quickScore = const Value.absent(),
    Value<String?> emoji = const Value.absent(),
    Value<double?> acidity = const Value.absent(),
    Value<double?> sweetness = const Value.absent(),
    Value<double?> bitterness = const Value.absent(),
    Value<double?> body = const Value.absent(),
    Value<String?> flavorNotes = const Value.absent(),
  }) => BrewRating(
    id: id ?? this.id,
    brewRecordId: brewRecordId ?? this.brewRecordId,
    quickScore: quickScore.present ? quickScore.value : this.quickScore,
    emoji: emoji.present ? emoji.value : this.emoji,
    acidity: acidity.present ? acidity.value : this.acidity,
    sweetness: sweetness.present ? sweetness.value : this.sweetness,
    bitterness: bitterness.present ? bitterness.value : this.bitterness,
    body: body.present ? body.value : this.body,
    flavorNotes: flavorNotes.present ? flavorNotes.value : this.flavorNotes,
  );
  BrewRating copyWithCompanion(BrewRatingsCompanion data) {
    return BrewRating(
      id: data.id.present ? data.id.value : this.id,
      brewRecordId: data.brewRecordId.present
          ? data.brewRecordId.value
          : this.brewRecordId,
      quickScore: data.quickScore.present
          ? data.quickScore.value
          : this.quickScore,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      acidity: data.acidity.present ? data.acidity.value : this.acidity,
      sweetness: data.sweetness.present ? data.sweetness.value : this.sweetness,
      bitterness: data.bitterness.present
          ? data.bitterness.value
          : this.bitterness,
      body: data.body.present ? data.body.value : this.body,
      flavorNotes: data.flavorNotes.present
          ? data.flavorNotes.value
          : this.flavorNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewRating(')
          ..write('id: $id, ')
          ..write('brewRecordId: $brewRecordId, ')
          ..write('quickScore: $quickScore, ')
          ..write('emoji: $emoji, ')
          ..write('acidity: $acidity, ')
          ..write('sweetness: $sweetness, ')
          ..write('bitterness: $bitterness, ')
          ..write('body: $body, ')
          ..write('flavorNotes: $flavorNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brewRecordId,
    quickScore,
    emoji,
    acidity,
    sweetness,
    bitterness,
    body,
    flavorNotes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewRating &&
          other.id == this.id &&
          other.brewRecordId == this.brewRecordId &&
          other.quickScore == this.quickScore &&
          other.emoji == this.emoji &&
          other.acidity == this.acidity &&
          other.sweetness == this.sweetness &&
          other.bitterness == this.bitterness &&
          other.body == this.body &&
          other.flavorNotes == this.flavorNotes);
}

class BrewRatingsCompanion extends UpdateCompanion<BrewRating> {
  final Value<int> id;
  final Value<int> brewRecordId;
  final Value<int?> quickScore;
  final Value<String?> emoji;
  final Value<double?> acidity;
  final Value<double?> sweetness;
  final Value<double?> bitterness;
  final Value<double?> body;
  final Value<String?> flavorNotes;
  const BrewRatingsCompanion({
    this.id = const Value.absent(),
    this.brewRecordId = const Value.absent(),
    this.quickScore = const Value.absent(),
    this.emoji = const Value.absent(),
    this.acidity = const Value.absent(),
    this.sweetness = const Value.absent(),
    this.bitterness = const Value.absent(),
    this.body = const Value.absent(),
    this.flavorNotes = const Value.absent(),
  });
  BrewRatingsCompanion.insert({
    this.id = const Value.absent(),
    required int brewRecordId,
    this.quickScore = const Value.absent(),
    this.emoji = const Value.absent(),
    this.acidity = const Value.absent(),
    this.sweetness = const Value.absent(),
    this.bitterness = const Value.absent(),
    this.body = const Value.absent(),
    this.flavorNotes = const Value.absent(),
  }) : brewRecordId = Value(brewRecordId);
  static Insertable<BrewRating> custom({
    Expression<int>? id,
    Expression<int>? brewRecordId,
    Expression<int>? quickScore,
    Expression<String>? emoji,
    Expression<double>? acidity,
    Expression<double>? sweetness,
    Expression<double>? bitterness,
    Expression<double>? body,
    Expression<String>? flavorNotes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brewRecordId != null) 'brew_record_id': brewRecordId,
      if (quickScore != null) 'quick_score': quickScore,
      if (emoji != null) 'emoji': emoji,
      if (acidity != null) 'acidity': acidity,
      if (sweetness != null) 'sweetness': sweetness,
      if (bitterness != null) 'bitterness': bitterness,
      if (body != null) 'body': body,
      if (flavorNotes != null) 'flavor_notes': flavorNotes,
    });
  }

  BrewRatingsCompanion copyWith({
    Value<int>? id,
    Value<int>? brewRecordId,
    Value<int?>? quickScore,
    Value<String?>? emoji,
    Value<double?>? acidity,
    Value<double?>? sweetness,
    Value<double?>? bitterness,
    Value<double?>? body,
    Value<String?>? flavorNotes,
  }) {
    return BrewRatingsCompanion(
      id: id ?? this.id,
      brewRecordId: brewRecordId ?? this.brewRecordId,
      quickScore: quickScore ?? this.quickScore,
      emoji: emoji ?? this.emoji,
      acidity: acidity ?? this.acidity,
      sweetness: sweetness ?? this.sweetness,
      bitterness: bitterness ?? this.bitterness,
      body: body ?? this.body,
      flavorNotes: flavorNotes ?? this.flavorNotes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brewRecordId.present) {
      map['brew_record_id'] = Variable<int>(brewRecordId.value);
    }
    if (quickScore.present) {
      map['quick_score'] = Variable<int>(quickScore.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (acidity.present) {
      map['acidity'] = Variable<double>(acidity.value);
    }
    if (sweetness.present) {
      map['sweetness'] = Variable<double>(sweetness.value);
    }
    if (bitterness.present) {
      map['bitterness'] = Variable<double>(bitterness.value);
    }
    if (body.present) {
      map['body'] = Variable<double>(body.value);
    }
    if (flavorNotes.present) {
      map['flavor_notes'] = Variable<String>(flavorNotes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewRatingsCompanion(')
          ..write('id: $id, ')
          ..write('brewRecordId: $brewRecordId, ')
          ..write('quickScore: $quickScore, ')
          ..write('emoji: $emoji, ')
          ..write('acidity: $acidity, ')
          ..write('sweetness: $sweetness, ')
          ..write('bitterness: $bitterness, ')
          ..write('body: $body, ')
          ..write('flavorNotes: $flavorNotes')
          ..write(')'))
        .toString();
  }
}

class $BrewMethodConfigsTable extends BrewMethodConfigs
    with TableInfo<$BrewMethodConfigsTable, BrewMethodConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewMethodConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, method, displayName, isEnabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_method_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewMethodConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewMethodConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewMethodConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $BrewMethodConfigsTable createAlias(String alias) {
    return $BrewMethodConfigsTable(attachedDatabase, alias);
  }
}

class BrewMethodConfig extends DataClass
    implements Insertable<BrewMethodConfig> {
  final int id;

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  final String method;

  /// Display name shown in UI (e.g. "Pour Over").
  final String displayName;

  /// Whether this brew method is enabled for the user.
  final bool isEnabled;
  const BrewMethodConfig({
    required this.id,
    required this.method,
    required this.displayName,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['method'] = Variable<String>(method);
    map['display_name'] = Variable<String>(displayName);
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  BrewMethodConfigsCompanion toCompanion(bool nullToAbsent) {
    return BrewMethodConfigsCompanion(
      id: Value(id),
      method: Value(method),
      displayName: Value(displayName),
      isEnabled: Value(isEnabled),
    );
  }

  factory BrewMethodConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewMethodConfig(
      id: serializer.fromJson<int>(json['id']),
      method: serializer.fromJson<String>(json['method']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'method': serializer.toJson<String>(method),
      'displayName': serializer.toJson<String>(displayName),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  BrewMethodConfig copyWith({
    int? id,
    String? method,
    String? displayName,
    bool? isEnabled,
  }) => BrewMethodConfig(
    id: id ?? this.id,
    method: method ?? this.method,
    displayName: displayName ?? this.displayName,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  BrewMethodConfig copyWithCompanion(BrewMethodConfigsCompanion data) {
    return BrewMethodConfig(
      id: data.id.present ? data.id.value : this.id,
      method: data.method.present ? data.method.value : this.method,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewMethodConfig(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('displayName: $displayName, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, method, displayName, isEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewMethodConfig &&
          other.id == this.id &&
          other.method == this.method &&
          other.displayName == this.displayName &&
          other.isEnabled == this.isEnabled);
}

class BrewMethodConfigsCompanion extends UpdateCompanion<BrewMethodConfig> {
  final Value<int> id;
  final Value<String> method;
  final Value<String> displayName;
  final Value<bool> isEnabled;
  const BrewMethodConfigsCompanion({
    this.id = const Value.absent(),
    this.method = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isEnabled = const Value.absent(),
  });
  BrewMethodConfigsCompanion.insert({
    this.id = const Value.absent(),
    required String method,
    required String displayName,
    this.isEnabled = const Value.absent(),
  }) : method = Value(method),
       displayName = Value(displayName);
  static Insertable<BrewMethodConfig> custom({
    Expression<int>? id,
    Expression<String>? method,
    Expression<String>? displayName,
    Expression<bool>? isEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (method != null) 'method': method,
      if (displayName != null) 'display_name': displayName,
      if (isEnabled != null) 'is_enabled': isEnabled,
    });
  }

  BrewMethodConfigsCompanion copyWith({
    Value<int>? id,
    Value<String>? method,
    Value<String>? displayName,
    Value<bool>? isEnabled,
  }) {
    return BrewMethodConfigsCompanion(
      id: id ?? this.id,
      method: method ?? this.method,
      displayName: displayName ?? this.displayName,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewMethodConfigsCompanion(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('displayName: $displayName, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }
}

class $BrewParamDefinitionsTable extends BrewParamDefinitions
    with TableInfo<$BrewParamDefinitionsTable, BrewParamDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewParamDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    method,
    name,
    type,
    unit,
    isSystem,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_param_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewParamDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewParamDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewParamDefinition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $BrewParamDefinitionsTable createAlias(String alias) {
    return $BrewParamDefinitionsTable(attachedDatabase, alias);
  }
}

class BrewParamDefinition extends DataClass
    implements Insertable<BrewParamDefinition> {
  final int id;

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  final String method;

  /// Parameter display name (e.g. "Water Temp").
  final String name;

  /// Parameter type: 'number' | 'text'.
  final String type;

  /// Optional unit label provided by user (e.g. "g", "C").
  final String? unit;

  /// Whether this is a system preset parameter.
  final bool isSystem;

  /// Sort order within the method parameter list.
  final int sortOrder;
  const BrewParamDefinition({
    required this.id,
    required this.method,
    required this.name,
    required this.type,
    this.unit,
    required this.isSystem,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['method'] = Variable<String>(method);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BrewParamDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return BrewParamDefinitionsCompanion(
      id: Value(id),
      method: Value(method),
      name: Value(name),
      type: Value(type),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
    );
  }

  factory BrewParamDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewParamDefinition(
      id: serializer.fromJson<int>(json['id']),
      method: serializer.fromJson<String>(json['method']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      unit: serializer.fromJson<String?>(json['unit']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'method': serializer.toJson<String>(method),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'unit': serializer.toJson<String?>(unit),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BrewParamDefinition copyWith({
    int? id,
    String? method,
    String? name,
    String? type,
    Value<String?> unit = const Value.absent(),
    bool? isSystem,
    int? sortOrder,
  }) => BrewParamDefinition(
    id: id ?? this.id,
    method: method ?? this.method,
    name: name ?? this.name,
    type: type ?? this.type,
    unit: unit.present ? unit.value : this.unit,
    isSystem: isSystem ?? this.isSystem,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  BrewParamDefinition copyWithCompanion(BrewParamDefinitionsCompanion data) {
    return BrewParamDefinition(
      id: data.id.present ? data.id.value : this.id,
      method: data.method.present ? data.method.value : this.method,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      unit: data.unit.present ? data.unit.value : this.unit,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamDefinition(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('unit: $unit, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, method, name, type, unit, isSystem, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewParamDefinition &&
          other.id == this.id &&
          other.method == this.method &&
          other.name == this.name &&
          other.type == this.type &&
          other.unit == this.unit &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder);
}

class BrewParamDefinitionsCompanion
    extends UpdateCompanion<BrewParamDefinition> {
  final Value<int> id;
  final Value<String> method;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> unit;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  const BrewParamDefinitionsCompanion({
    this.id = const Value.absent(),
    this.method = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.unit = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  BrewParamDefinitionsCompanion.insert({
    this.id = const Value.absent(),
    required String method,
    required String name,
    required String type,
    this.unit = const Value.absent(),
    this.isSystem = const Value.absent(),
    required int sortOrder,
  }) : method = Value(method),
       name = Value(name),
       type = Value(type),
       sortOrder = Value(sortOrder);
  static Insertable<BrewParamDefinition> custom({
    Expression<int>? id,
    Expression<String>? method,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? unit,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (method != null) 'method': method,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (unit != null) 'unit': unit,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  BrewParamDefinitionsCompanion copyWith({
    Value<int>? id,
    Value<String>? method,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? unit,
    Value<bool>? isSystem,
    Value<int>? sortOrder,
  }) {
    return BrewParamDefinitionsCompanion(
      id: id ?? this.id,
      method: method ?? this.method,
      name: name ?? this.name,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('unit: $unit, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $BrewParamVisibilitiesTable extends BrewParamVisibilities
    with TableInfo<$BrewParamVisibilitiesTable, BrewParamVisibility> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewParamVisibilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paramIdMeta = const VerificationMeta(
    'paramId',
  );
  @override
  late final GeneratedColumn<int> paramId = GeneratedColumn<int>(
    'param_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brew_param_definitions (id)',
    ),
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, method, paramId, isVisible];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_param_visibilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewParamVisibility> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('param_id')) {
      context.handle(
        _paramIdMeta,
        paramId.isAcceptableOrUnknown(data['param_id']!, _paramIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paramIdMeta);
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewParamVisibility map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewParamVisibility(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      paramId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}param_id'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
    );
  }

  @override
  $BrewParamVisibilitiesTable createAlias(String alias) {
    return $BrewParamVisibilitiesTable(attachedDatabase, alias);
  }
}

class BrewParamVisibility extends DataClass
    implements Insertable<BrewParamVisibility> {
  final int id;

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  final String method;

  /// FK to parameter definition.
  final int paramId;

  /// Whether this parameter is visible in the record UI.
  final bool isVisible;
  const BrewParamVisibility({
    required this.id,
    required this.method,
    required this.paramId,
    required this.isVisible,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['method'] = Variable<String>(method);
    map['param_id'] = Variable<int>(paramId);
    map['is_visible'] = Variable<bool>(isVisible);
    return map;
  }

  BrewParamVisibilitiesCompanion toCompanion(bool nullToAbsent) {
    return BrewParamVisibilitiesCompanion(
      id: Value(id),
      method: Value(method),
      paramId: Value(paramId),
      isVisible: Value(isVisible),
    );
  }

  factory BrewParamVisibility.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewParamVisibility(
      id: serializer.fromJson<int>(json['id']),
      method: serializer.fromJson<String>(json['method']),
      paramId: serializer.fromJson<int>(json['paramId']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'method': serializer.toJson<String>(method),
      'paramId': serializer.toJson<int>(paramId),
      'isVisible': serializer.toJson<bool>(isVisible),
    };
  }

  BrewParamVisibility copyWith({
    int? id,
    String? method,
    int? paramId,
    bool? isVisible,
  }) => BrewParamVisibility(
    id: id ?? this.id,
    method: method ?? this.method,
    paramId: paramId ?? this.paramId,
    isVisible: isVisible ?? this.isVisible,
  );
  BrewParamVisibility copyWithCompanion(BrewParamVisibilitiesCompanion data) {
    return BrewParamVisibility(
      id: data.id.present ? data.id.value : this.id,
      method: data.method.present ? data.method.value : this.method,
      paramId: data.paramId.present ? data.paramId.value : this.paramId,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamVisibility(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('paramId: $paramId, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, method, paramId, isVisible);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewParamVisibility &&
          other.id == this.id &&
          other.method == this.method &&
          other.paramId == this.paramId &&
          other.isVisible == this.isVisible);
}

class BrewParamVisibilitiesCompanion
    extends UpdateCompanion<BrewParamVisibility> {
  final Value<int> id;
  final Value<String> method;
  final Value<int> paramId;
  final Value<bool> isVisible;
  const BrewParamVisibilitiesCompanion({
    this.id = const Value.absent(),
    this.method = const Value.absent(),
    this.paramId = const Value.absent(),
    this.isVisible = const Value.absent(),
  });
  BrewParamVisibilitiesCompanion.insert({
    this.id = const Value.absent(),
    required String method,
    required int paramId,
    this.isVisible = const Value.absent(),
  }) : method = Value(method),
       paramId = Value(paramId);
  static Insertable<BrewParamVisibility> custom({
    Expression<int>? id,
    Expression<String>? method,
    Expression<int>? paramId,
    Expression<bool>? isVisible,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (method != null) 'method': method,
      if (paramId != null) 'param_id': paramId,
      if (isVisible != null) 'is_visible': isVisible,
    });
  }

  BrewParamVisibilitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? method,
    Value<int>? paramId,
    Value<bool>? isVisible,
  }) {
    return BrewParamVisibilitiesCompanion(
      id: id ?? this.id,
      method: method ?? this.method,
      paramId: paramId ?? this.paramId,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (paramId.present) {
      map['param_id'] = Variable<int>(paramId.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamVisibilitiesCompanion(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('paramId: $paramId, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }
}

class $BrewParamValuesTable extends BrewParamValues
    with TableInfo<$BrewParamValuesTable, BrewParamValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewParamValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brewRecordIdMeta = const VerificationMeta(
    'brewRecordId',
  );
  @override
  late final GeneratedColumn<int> brewRecordId = GeneratedColumn<int>(
    'brew_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brew_records (id)',
    ),
  );
  static const VerificationMeta _paramIdMeta = const VerificationMeta(
    'paramId',
  );
  @override
  late final GeneratedColumn<int> paramId = GeneratedColumn<int>(
    'param_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brew_param_definitions (id)',
    ),
  );
  static const VerificationMeta _valueNumberMeta = const VerificationMeta(
    'valueNumber',
  );
  @override
  late final GeneratedColumn<double> valueNumber = GeneratedColumn<double>(
    'value_number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  @override
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brewRecordId,
    paramId,
    valueNumber,
    valueText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_param_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewParamValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brew_record_id')) {
      context.handle(
        _brewRecordIdMeta,
        brewRecordId.isAcceptableOrUnknown(
          data['brew_record_id']!,
          _brewRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brewRecordIdMeta);
    }
    if (data.containsKey('param_id')) {
      context.handle(
        _paramIdMeta,
        paramId.isAcceptableOrUnknown(data['param_id']!, _paramIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paramIdMeta);
    }
    if (data.containsKey('value_number')) {
      context.handle(
        _valueNumberMeta,
        valueNumber.isAcceptableOrUnknown(
          data['value_number']!,
          _valueNumberMeta,
        ),
      );
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewParamValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewParamValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brewRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brew_record_id'],
      )!,
      paramId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}param_id'],
      )!,
      valueNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_number'],
      ),
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      ),
    );
  }

  @override
  $BrewParamValuesTable createAlias(String alias) {
    return $BrewParamValuesTable(attachedDatabase, alias);
  }
}

class BrewParamValue extends DataClass implements Insertable<BrewParamValue> {
  final int id;

  /// FK to brew record.
  final int brewRecordId;

  /// FK to parameter definition.
  final int paramId;

  /// Numeric value (when ParamType == number).
  final double? valueNumber;

  /// Text value (when ParamType == text).
  final String? valueText;
  const BrewParamValue({
    required this.id,
    required this.brewRecordId,
    required this.paramId,
    this.valueNumber,
    this.valueText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brew_record_id'] = Variable<int>(brewRecordId);
    map['param_id'] = Variable<int>(paramId);
    if (!nullToAbsent || valueNumber != null) {
      map['value_number'] = Variable<double>(valueNumber);
    }
    if (!nullToAbsent || valueText != null) {
      map['value_text'] = Variable<String>(valueText);
    }
    return map;
  }

  BrewParamValuesCompanion toCompanion(bool nullToAbsent) {
    return BrewParamValuesCompanion(
      id: Value(id),
      brewRecordId: Value(brewRecordId),
      paramId: Value(paramId),
      valueNumber: valueNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNumber),
      valueText: valueText == null && nullToAbsent
          ? const Value.absent()
          : Value(valueText),
    );
  }

  factory BrewParamValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewParamValue(
      id: serializer.fromJson<int>(json['id']),
      brewRecordId: serializer.fromJson<int>(json['brewRecordId']),
      paramId: serializer.fromJson<int>(json['paramId']),
      valueNumber: serializer.fromJson<double?>(json['valueNumber']),
      valueText: serializer.fromJson<String?>(json['valueText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brewRecordId': serializer.toJson<int>(brewRecordId),
      'paramId': serializer.toJson<int>(paramId),
      'valueNumber': serializer.toJson<double?>(valueNumber),
      'valueText': serializer.toJson<String?>(valueText),
    };
  }

  BrewParamValue copyWith({
    int? id,
    int? brewRecordId,
    int? paramId,
    Value<double?> valueNumber = const Value.absent(),
    Value<String?> valueText = const Value.absent(),
  }) => BrewParamValue(
    id: id ?? this.id,
    brewRecordId: brewRecordId ?? this.brewRecordId,
    paramId: paramId ?? this.paramId,
    valueNumber: valueNumber.present ? valueNumber.value : this.valueNumber,
    valueText: valueText.present ? valueText.value : this.valueText,
  );
  BrewParamValue copyWithCompanion(BrewParamValuesCompanion data) {
    return BrewParamValue(
      id: data.id.present ? data.id.value : this.id,
      brewRecordId: data.brewRecordId.present
          ? data.brewRecordId.value
          : this.brewRecordId,
      paramId: data.paramId.present ? data.paramId.value : this.paramId,
      valueNumber: data.valueNumber.present
          ? data.valueNumber.value
          : this.valueNumber,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamValue(')
          ..write('id: $id, ')
          ..write('brewRecordId: $brewRecordId, ')
          ..write('paramId: $paramId, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueText: $valueText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, brewRecordId, paramId, valueNumber, valueText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewParamValue &&
          other.id == this.id &&
          other.brewRecordId == this.brewRecordId &&
          other.paramId == this.paramId &&
          other.valueNumber == this.valueNumber &&
          other.valueText == this.valueText);
}

class BrewParamValuesCompanion extends UpdateCompanion<BrewParamValue> {
  final Value<int> id;
  final Value<int> brewRecordId;
  final Value<int> paramId;
  final Value<double?> valueNumber;
  final Value<String?> valueText;
  const BrewParamValuesCompanion({
    this.id = const Value.absent(),
    this.brewRecordId = const Value.absent(),
    this.paramId = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueText = const Value.absent(),
  });
  BrewParamValuesCompanion.insert({
    this.id = const Value.absent(),
    required int brewRecordId,
    required int paramId,
    this.valueNumber = const Value.absent(),
    this.valueText = const Value.absent(),
  }) : brewRecordId = Value(brewRecordId),
       paramId = Value(paramId);
  static Insertable<BrewParamValue> custom({
    Expression<int>? id,
    Expression<int>? brewRecordId,
    Expression<int>? paramId,
    Expression<double>? valueNumber,
    Expression<String>? valueText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brewRecordId != null) 'brew_record_id': brewRecordId,
      if (paramId != null) 'param_id': paramId,
      if (valueNumber != null) 'value_number': valueNumber,
      if (valueText != null) 'value_text': valueText,
    });
  }

  BrewParamValuesCompanion copyWith({
    Value<int>? id,
    Value<int>? brewRecordId,
    Value<int>? paramId,
    Value<double?>? valueNumber,
    Value<String?>? valueText,
  }) {
    return BrewParamValuesCompanion(
      id: id ?? this.id,
      brewRecordId: brewRecordId ?? this.brewRecordId,
      paramId: paramId ?? this.paramId,
      valueNumber: valueNumber ?? this.valueNumber,
      valueText: valueText ?? this.valueText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brewRecordId.present) {
      map['brew_record_id'] = Variable<int>(brewRecordId.value);
    }
    if (paramId.present) {
      map['param_id'] = Variable<int>(paramId.value);
    }
    if (valueNumber.present) {
      map['value_number'] = Variable<double>(valueNumber.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewParamValuesCompanion(')
          ..write('id: $id, ')
          ..write('brewRecordId: $brewRecordId, ')
          ..write('paramId: $paramId, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueText: $valueText')
          ..write(')'))
        .toString();
  }
}

abstract class _$OneBrewDatabase extends GeneratedDatabase {
  _$OneBrewDatabase(QueryExecutor e) : super(e);
  $OneBrewDatabaseManager get managers => $OneBrewDatabaseManager(this);
  late final $BeansTable beans = $BeansTable(this);
  late final $EquipmentsTable equipments = $EquipmentsTable(this);
  late final $BrewRecordsTable brewRecords = $BrewRecordsTable(this);
  late final $BrewRatingsTable brewRatings = $BrewRatingsTable(this);
  late final $BrewMethodConfigsTable brewMethodConfigs =
      $BrewMethodConfigsTable(this);
  late final $BrewParamDefinitionsTable brewParamDefinitions =
      $BrewParamDefinitionsTable(this);
  late final $BrewParamVisibilitiesTable brewParamVisibilities =
      $BrewParamVisibilitiesTable(this);
  late final $BrewParamValuesTable brewParamValues = $BrewParamValuesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    beans,
    equipments,
    brewRecords,
    brewRatings,
    brewMethodConfigs,
    brewParamDefinitions,
    brewParamVisibilities,
    brewParamValues,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'brew_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('brew_ratings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BeansTableCreateCompanionBuilder =
    BeansCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> roaster,
      Value<String?> origin,
      Value<String?> roastLevel,
      Value<DateTime> addedAt,
      Value<int> useCount,
    });
typedef $$BeansTableUpdateCompanionBuilder =
    BeansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> roaster,
      Value<String?> origin,
      Value<String?> roastLevel,
      Value<DateTime> addedAt,
      Value<int> useCount,
    });

class $$BeansTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BeansTable> {
  $$BeansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BeansTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BeansTable> {
  $$BeansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BeansTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BeansTable> {
  $$BeansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get roaster =>
      $composableBuilder(column: $table.roaster, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);
}

class $$BeansTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BeansTable,
          Bean,
          $$BeansTableFilterComposer,
          $$BeansTableOrderingComposer,
          $$BeansTableAnnotationComposer,
          $$BeansTableCreateCompanionBuilder,
          $$BeansTableUpdateCompanionBuilder,
          (Bean, BaseReferences<_$OneBrewDatabase, $BeansTable, Bean>),
          Bean,
          PrefetchHooks Function()
        > {
  $$BeansTableTableManager(_$OneBrewDatabase db, $BeansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> roaster = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> roastLevel = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> useCount = const Value.absent(),
              }) => BeansCompanion(
                id: id,
                name: name,
                roaster: roaster,
                origin: origin,
                roastLevel: roastLevel,
                addedAt: addedAt,
                useCount: useCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> roaster = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> roastLevel = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> useCount = const Value.absent(),
              }) => BeansCompanion.insert(
                id: id,
                name: name,
                roaster: roaster,
                origin: origin,
                roastLevel: roastLevel,
                addedAt: addedAt,
                useCount: useCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BeansTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BeansTable,
      Bean,
      $$BeansTableFilterComposer,
      $$BeansTableOrderingComposer,
      $$BeansTableAnnotationComposer,
      $$BeansTableCreateCompanionBuilder,
      $$BeansTableUpdateCompanionBuilder,
      (Bean, BaseReferences<_$OneBrewDatabase, $BeansTable, Bean>),
      Bean,
      PrefetchHooks Function()
    >;
typedef $$EquipmentsTableCreateCompanionBuilder =
    EquipmentsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> category,
      Value<bool> isGrinder,
      Value<bool> isDeleted,
      Value<double?> grindMinClick,
      Value<double?> grindMaxClick,
      Value<double?> grindClickStep,
      Value<String?> grindClickUnit,
      Value<DateTime> addedAt,
      Value<int> useCount,
    });
typedef $$EquipmentsTableUpdateCompanionBuilder =
    EquipmentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> category,
      Value<bool> isGrinder,
      Value<bool> isDeleted,
      Value<double?> grindMinClick,
      Value<double?> grindMaxClick,
      Value<double?> grindClickStep,
      Value<String?> grindClickUnit,
      Value<DateTime> addedAt,
      Value<int> useCount,
    });

final class $$EquipmentsTableReferences
    extends BaseReferences<_$OneBrewDatabase, $EquipmentsTable, Equipment> {
  $$EquipmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BrewRecordsTable, List<BrewRecord>>
  _brewRecordsRefsTable(_$OneBrewDatabase db) => MultiTypedResultKey.fromTable(
    db.brewRecords,
    aliasName: $_aliasNameGenerator(
      db.equipments.id,
      db.brewRecords.equipmentId,
    ),
  );

  $$BrewRecordsTableProcessedTableManager get brewRecordsRefs {
    final manager = $$BrewRecordsTableTableManager(
      $_db,
      $_db.brewRecords,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_brewRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentsTableFilterComposer
    extends Composer<_$OneBrewDatabase, $EquipmentsTable> {
  $$EquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGrinder => $composableBuilder(
    column: $table.isGrinder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grindMinClick => $composableBuilder(
    column: $table.grindMinClick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grindMaxClick => $composableBuilder(
    column: $table.grindMaxClick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grindClickStep => $composableBuilder(
    column: $table.grindClickStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grindClickUnit => $composableBuilder(
    column: $table.grindClickUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> brewRecordsRefs(
    Expression<bool> Function($$BrewRecordsTableFilterComposer f) f,
  ) {
    final $$BrewRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableFilterComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentsTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $EquipmentsTable> {
  $$EquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGrinder => $composableBuilder(
    column: $table.isGrinder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grindMinClick => $composableBuilder(
    column: $table.grindMinClick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grindMaxClick => $composableBuilder(
    column: $table.grindMaxClick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grindClickStep => $composableBuilder(
    column: $table.grindClickStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grindClickUnit => $composableBuilder(
    column: $table.grindClickUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentsTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $EquipmentsTable> {
  $$EquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isGrinder =>
      $composableBuilder(column: $table.isGrinder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<double> get grindMinClick => $composableBuilder(
    column: $table.grindMinClick,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grindMaxClick => $composableBuilder(
    column: $table.grindMaxClick,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grindClickStep => $composableBuilder(
    column: $table.grindClickStep,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grindClickUnit => $composableBuilder(
    column: $table.grindClickUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  Expression<T> brewRecordsRefs<T extends Object>(
    Expression<T> Function($$BrewRecordsTableAnnotationComposer a) f,
  ) {
    final $$BrewRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentsTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $EquipmentsTable,
          Equipment,
          $$EquipmentsTableFilterComposer,
          $$EquipmentsTableOrderingComposer,
          $$EquipmentsTableAnnotationComposer,
          $$EquipmentsTableCreateCompanionBuilder,
          $$EquipmentsTableUpdateCompanionBuilder,
          (Equipment, $$EquipmentsTableReferences),
          Equipment,
          PrefetchHooks Function({bool brewRecordsRefs})
        > {
  $$EquipmentsTableTableManager(_$OneBrewDatabase db, $EquipmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<bool> isGrinder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<double?> grindMinClick = const Value.absent(),
                Value<double?> grindMaxClick = const Value.absent(),
                Value<double?> grindClickStep = const Value.absent(),
                Value<String?> grindClickUnit = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> useCount = const Value.absent(),
              }) => EquipmentsCompanion(
                id: id,
                name: name,
                category: category,
                isGrinder: isGrinder,
                isDeleted: isDeleted,
                grindMinClick: grindMinClick,
                grindMaxClick: grindMaxClick,
                grindClickStep: grindClickStep,
                grindClickUnit: grindClickUnit,
                addedAt: addedAt,
                useCount: useCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                Value<bool> isGrinder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<double?> grindMinClick = const Value.absent(),
                Value<double?> grindMaxClick = const Value.absent(),
                Value<double?> grindClickStep = const Value.absent(),
                Value<String?> grindClickUnit = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> useCount = const Value.absent(),
              }) => EquipmentsCompanion.insert(
                id: id,
                name: name,
                category: category,
                isGrinder: isGrinder,
                isDeleted: isDeleted,
                grindMinClick: grindMinClick,
                grindMaxClick: grindMaxClick,
                grindClickStep: grindClickStep,
                grindClickUnit: grindClickUnit,
                addedAt: addedAt,
                useCount: useCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brewRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (brewRecordsRefs) db.brewRecords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (brewRecordsRefs)
                    await $_getPrefetchedData<
                      Equipment,
                      $EquipmentsTable,
                      BrewRecord
                    >(
                      currentTable: table,
                      referencedTable: $$EquipmentsTableReferences
                          ._brewRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EquipmentsTableReferences(
                            db,
                            table,
                            p0,
                          ).brewRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.equipmentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $EquipmentsTable,
      Equipment,
      $$EquipmentsTableFilterComposer,
      $$EquipmentsTableOrderingComposer,
      $$EquipmentsTableAnnotationComposer,
      $$EquipmentsTableCreateCompanionBuilder,
      $$EquipmentsTableUpdateCompanionBuilder,
      (Equipment, $$EquipmentsTableReferences),
      Equipment,
      PrefetchHooks Function({bool brewRecordsRefs})
    >;
typedef $$BrewRecordsTableCreateCompanionBuilder =
    BrewRecordsCompanion Function({
      Value<int> id,
      required DateTime brewDate,
      required String beanName,
      Value<int?> equipmentId,
      Value<String> brewMethod,
      Value<String> grindMode,
      Value<double?> grindClickValue,
      Value<String?> grindSimpleLabel,
      Value<int?> grindMicrons,
      required double coffeeWeightG,
      required double waterWeightG,
      Value<double?> waterTempC,
      required int brewDurationS,
      Value<int?> bloomTimeS,
      Value<String?> pourMethod,
      Value<String?> waterType,
      Value<double?> roomTempC,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BrewRecordsTableUpdateCompanionBuilder =
    BrewRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> brewDate,
      Value<String> beanName,
      Value<int?> equipmentId,
      Value<String> brewMethod,
      Value<String> grindMode,
      Value<double?> grindClickValue,
      Value<String?> grindSimpleLabel,
      Value<int?> grindMicrons,
      Value<double> coffeeWeightG,
      Value<double> waterWeightG,
      Value<double?> waterTempC,
      Value<int> brewDurationS,
      Value<int?> bloomTimeS,
      Value<String?> pourMethod,
      Value<String?> waterType,
      Value<double?> roomTempC,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BrewRecordsTableReferences
    extends BaseReferences<_$OneBrewDatabase, $BrewRecordsTable, BrewRecord> {
  $$BrewRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EquipmentsTable _equipmentIdTable(_$OneBrewDatabase db) =>
      db.equipments.createAlias(
        $_aliasNameGenerator(db.brewRecords.equipmentId, db.equipments.id),
      );

  $$EquipmentsTableProcessedTableManager? get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id');
    if ($_column == null) return null;
    final manager = $$EquipmentsTableTableManager(
      $_db,
      $_db.equipments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BrewRatingsTable, List<BrewRating>>
  _brewRatingsRefsTable(_$OneBrewDatabase db) => MultiTypedResultKey.fromTable(
    db.brewRatings,
    aliasName: $_aliasNameGenerator(
      db.brewRecords.id,
      db.brewRatings.brewRecordId,
    ),
  );

  $$BrewRatingsTableProcessedTableManager get brewRatingsRefs {
    final manager = $$BrewRatingsTableTableManager(
      $_db,
      $_db.brewRatings,
    ).filter((f) => f.brewRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_brewRatingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BrewParamValuesTable, List<BrewParamValue>>
  _brewParamValuesRefsTable(_$OneBrewDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.brewParamValues,
        aliasName: $_aliasNameGenerator(
          db.brewRecords.id,
          db.brewParamValues.brewRecordId,
        ),
      );

  $$BrewParamValuesTableProcessedTableManager get brewParamValuesRefs {
    final manager = $$BrewParamValuesTableTableManager(
      $_db,
      $_db.brewParamValues,
    ).filter((f) => f.brewRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _brewParamValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrewRecordsTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewRecordsTable> {
  $$BrewRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get brewDate => $composableBuilder(
    column: $table.brewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beanName => $composableBuilder(
    column: $table.beanName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brewMethod => $composableBuilder(
    column: $table.brewMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grindMode => $composableBuilder(
    column: $table.grindMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grindClickValue => $composableBuilder(
    column: $table.grindClickValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grindSimpleLabel => $composableBuilder(
    column: $table.grindSimpleLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grindMicrons => $composableBuilder(
    column: $table.grindMicrons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coffeeWeightG => $composableBuilder(
    column: $table.coffeeWeightG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterWeightG => $composableBuilder(
    column: $table.waterWeightG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterTempC => $composableBuilder(
    column: $table.waterTempC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brewDurationS => $composableBuilder(
    column: $table.brewDurationS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bloomTimeS => $composableBuilder(
    column: $table.bloomTimeS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pourMethod => $composableBuilder(
    column: $table.pourMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterType => $composableBuilder(
    column: $table.waterType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get roomTempC => $composableBuilder(
    column: $table.roomTempC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EquipmentsTableFilterComposer get equipmentId {
    final $$EquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> brewRatingsRefs(
    Expression<bool> Function($$BrewRatingsTableFilterComposer f) f,
  ) {
    final $$BrewRatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewRatings,
      getReferencedColumn: (t) => t.brewRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRatingsTableFilterComposer(
            $db: $db,
            $table: $db.brewRatings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> brewParamValuesRefs(
    Expression<bool> Function($$BrewParamValuesTableFilterComposer f) f,
  ) {
    final $$BrewParamValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewParamValues,
      getReferencedColumn: (t) => t.brewRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamValuesTableFilterComposer(
            $db: $db,
            $table: $db.brewParamValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrewRecordsTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewRecordsTable> {
  $$BrewRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get brewDate => $composableBuilder(
    column: $table.brewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beanName => $composableBuilder(
    column: $table.beanName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brewMethod => $composableBuilder(
    column: $table.brewMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grindMode => $composableBuilder(
    column: $table.grindMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grindClickValue => $composableBuilder(
    column: $table.grindClickValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grindSimpleLabel => $composableBuilder(
    column: $table.grindSimpleLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grindMicrons => $composableBuilder(
    column: $table.grindMicrons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coffeeWeightG => $composableBuilder(
    column: $table.coffeeWeightG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterWeightG => $composableBuilder(
    column: $table.waterWeightG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterTempC => $composableBuilder(
    column: $table.waterTempC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brewDurationS => $composableBuilder(
    column: $table.brewDurationS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bloomTimeS => $composableBuilder(
    column: $table.bloomTimeS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pourMethod => $composableBuilder(
    column: $table.pourMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterType => $composableBuilder(
    column: $table.waterType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get roomTempC => $composableBuilder(
    column: $table.roomTempC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EquipmentsTableOrderingComposer get equipmentId {
    final $$EquipmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableOrderingComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewRecordsTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewRecordsTable> {
  $$BrewRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get brewDate =>
      $composableBuilder(column: $table.brewDate, builder: (column) => column);

  GeneratedColumn<String> get beanName =>
      $composableBuilder(column: $table.beanName, builder: (column) => column);

  GeneratedColumn<String> get brewMethod => $composableBuilder(
    column: $table.brewMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grindMode =>
      $composableBuilder(column: $table.grindMode, builder: (column) => column);

  GeneratedColumn<double> get grindClickValue => $composableBuilder(
    column: $table.grindClickValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grindSimpleLabel => $composableBuilder(
    column: $table.grindSimpleLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grindMicrons => $composableBuilder(
    column: $table.grindMicrons,
    builder: (column) => column,
  );

  GeneratedColumn<double> get coffeeWeightG => $composableBuilder(
    column: $table.coffeeWeightG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waterWeightG => $composableBuilder(
    column: $table.waterWeightG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waterTempC => $composableBuilder(
    column: $table.waterTempC,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brewDurationS => $composableBuilder(
    column: $table.brewDurationS,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bloomTimeS => $composableBuilder(
    column: $table.bloomTimeS,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pourMethod => $composableBuilder(
    column: $table.pourMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waterType =>
      $composableBuilder(column: $table.waterType, builder: (column) => column);

  GeneratedColumn<double> get roomTempC =>
      $composableBuilder(column: $table.roomTempC, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EquipmentsTableAnnotationComposer get equipmentId {
    final $$EquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> brewRatingsRefs<T extends Object>(
    Expression<T> Function($$BrewRatingsTableAnnotationComposer a) f,
  ) {
    final $$BrewRatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewRatings,
      getReferencedColumn: (t) => t.brewRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.brewRatings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> brewParamValuesRefs<T extends Object>(
    Expression<T> Function($$BrewParamValuesTableAnnotationComposer a) f,
  ) {
    final $$BrewParamValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewParamValues,
      getReferencedColumn: (t) => t.brewRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.brewParamValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrewRecordsTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewRecordsTable,
          BrewRecord,
          $$BrewRecordsTableFilterComposer,
          $$BrewRecordsTableOrderingComposer,
          $$BrewRecordsTableAnnotationComposer,
          $$BrewRecordsTableCreateCompanionBuilder,
          $$BrewRecordsTableUpdateCompanionBuilder,
          (BrewRecord, $$BrewRecordsTableReferences),
          BrewRecord,
          PrefetchHooks Function({
            bool equipmentId,
            bool brewRatingsRefs,
            bool brewParamValuesRefs,
          })
        > {
  $$BrewRecordsTableTableManager(_$OneBrewDatabase db, $BrewRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> brewDate = const Value.absent(),
                Value<String> beanName = const Value.absent(),
                Value<int?> equipmentId = const Value.absent(),
                Value<String> brewMethod = const Value.absent(),
                Value<String> grindMode = const Value.absent(),
                Value<double?> grindClickValue = const Value.absent(),
                Value<String?> grindSimpleLabel = const Value.absent(),
                Value<int?> grindMicrons = const Value.absent(),
                Value<double> coffeeWeightG = const Value.absent(),
                Value<double> waterWeightG = const Value.absent(),
                Value<double?> waterTempC = const Value.absent(),
                Value<int> brewDurationS = const Value.absent(),
                Value<int?> bloomTimeS = const Value.absent(),
                Value<String?> pourMethod = const Value.absent(),
                Value<String?> waterType = const Value.absent(),
                Value<double?> roomTempC = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BrewRecordsCompanion(
                id: id,
                brewDate: brewDate,
                beanName: beanName,
                equipmentId: equipmentId,
                brewMethod: brewMethod,
                grindMode: grindMode,
                grindClickValue: grindClickValue,
                grindSimpleLabel: grindSimpleLabel,
                grindMicrons: grindMicrons,
                coffeeWeightG: coffeeWeightG,
                waterWeightG: waterWeightG,
                waterTempC: waterTempC,
                brewDurationS: brewDurationS,
                bloomTimeS: bloomTimeS,
                pourMethod: pourMethod,
                waterType: waterType,
                roomTempC: roomTempC,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime brewDate,
                required String beanName,
                Value<int?> equipmentId = const Value.absent(),
                Value<String> brewMethod = const Value.absent(),
                Value<String> grindMode = const Value.absent(),
                Value<double?> grindClickValue = const Value.absent(),
                Value<String?> grindSimpleLabel = const Value.absent(),
                Value<int?> grindMicrons = const Value.absent(),
                required double coffeeWeightG,
                required double waterWeightG,
                Value<double?> waterTempC = const Value.absent(),
                required int brewDurationS,
                Value<int?> bloomTimeS = const Value.absent(),
                Value<String?> pourMethod = const Value.absent(),
                Value<String?> waterType = const Value.absent(),
                Value<double?> roomTempC = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BrewRecordsCompanion.insert(
                id: id,
                brewDate: brewDate,
                beanName: beanName,
                equipmentId: equipmentId,
                brewMethod: brewMethod,
                grindMode: grindMode,
                grindClickValue: grindClickValue,
                grindSimpleLabel: grindSimpleLabel,
                grindMicrons: grindMicrons,
                coffeeWeightG: coffeeWeightG,
                waterWeightG: waterWeightG,
                waterTempC: waterTempC,
                brewDurationS: brewDurationS,
                bloomTimeS: bloomTimeS,
                pourMethod: pourMethod,
                waterType: waterType,
                roomTempC: roomTempC,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrewRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                equipmentId = false,
                brewRatingsRefs = false,
                brewParamValuesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (brewRatingsRefs) db.brewRatings,
                    if (brewParamValuesRefs) db.brewParamValues,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (equipmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipmentId,
                                    referencedTable:
                                        $$BrewRecordsTableReferences
                                            ._equipmentIdTable(db),
                                    referencedColumn:
                                        $$BrewRecordsTableReferences
                                            ._equipmentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (brewRatingsRefs)
                        await $_getPrefetchedData<
                          BrewRecord,
                          $BrewRecordsTable,
                          BrewRating
                        >(
                          currentTable: table,
                          referencedTable: $$BrewRecordsTableReferences
                              ._brewRatingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrewRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).brewRatingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.brewRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (brewParamValuesRefs)
                        await $_getPrefetchedData<
                          BrewRecord,
                          $BrewRecordsTable,
                          BrewParamValue
                        >(
                          currentTable: table,
                          referencedTable: $$BrewRecordsTableReferences
                              ._brewParamValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrewRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).brewParamValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.brewRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BrewRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewRecordsTable,
      BrewRecord,
      $$BrewRecordsTableFilterComposer,
      $$BrewRecordsTableOrderingComposer,
      $$BrewRecordsTableAnnotationComposer,
      $$BrewRecordsTableCreateCompanionBuilder,
      $$BrewRecordsTableUpdateCompanionBuilder,
      (BrewRecord, $$BrewRecordsTableReferences),
      BrewRecord,
      PrefetchHooks Function({
        bool equipmentId,
        bool brewRatingsRefs,
        bool brewParamValuesRefs,
      })
    >;
typedef $$BrewRatingsTableCreateCompanionBuilder =
    BrewRatingsCompanion Function({
      Value<int> id,
      required int brewRecordId,
      Value<int?> quickScore,
      Value<String?> emoji,
      Value<double?> acidity,
      Value<double?> sweetness,
      Value<double?> bitterness,
      Value<double?> body,
      Value<String?> flavorNotes,
    });
typedef $$BrewRatingsTableUpdateCompanionBuilder =
    BrewRatingsCompanion Function({
      Value<int> id,
      Value<int> brewRecordId,
      Value<int?> quickScore,
      Value<String?> emoji,
      Value<double?> acidity,
      Value<double?> sweetness,
      Value<double?> bitterness,
      Value<double?> body,
      Value<String?> flavorNotes,
    });

final class $$BrewRatingsTableReferences
    extends BaseReferences<_$OneBrewDatabase, $BrewRatingsTable, BrewRating> {
  $$BrewRatingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrewRecordsTable _brewRecordIdTable(_$OneBrewDatabase db) =>
      db.brewRecords.createAlias(
        $_aliasNameGenerator(db.brewRatings.brewRecordId, db.brewRecords.id),
      );

  $$BrewRecordsTableProcessedTableManager get brewRecordId {
    final $_column = $_itemColumn<int>('brew_record_id')!;

    final manager = $$BrewRecordsTableTableManager(
      $_db,
      $_db.brewRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brewRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BrewRatingsTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewRatingsTable> {
  $$BrewRatingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quickScore => $composableBuilder(
    column: $table.quickScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get acidity => $composableBuilder(
    column: $table.acidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sweetness => $composableBuilder(
    column: $table.sweetness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bitterness => $composableBuilder(
    column: $table.bitterness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flavorNotes => $composableBuilder(
    column: $table.flavorNotes,
    builder: (column) => ColumnFilters(column),
  );

  $$BrewRecordsTableFilterComposer get brewRecordId {
    final $$BrewRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableFilterComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewRatingsTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewRatingsTable> {
  $$BrewRatingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quickScore => $composableBuilder(
    column: $table.quickScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get acidity => $composableBuilder(
    column: $table.acidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sweetness => $composableBuilder(
    column: $table.sweetness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bitterness => $composableBuilder(
    column: $table.bitterness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flavorNotes => $composableBuilder(
    column: $table.flavorNotes,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrewRecordsTableOrderingComposer get brewRecordId {
    final $$BrewRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewRatingsTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewRatingsTable> {
  $$BrewRatingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quickScore => $composableBuilder(
    column: $table.quickScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<double> get acidity =>
      $composableBuilder(column: $table.acidity, builder: (column) => column);

  GeneratedColumn<double> get sweetness =>
      $composableBuilder(column: $table.sweetness, builder: (column) => column);

  GeneratedColumn<double> get bitterness => $composableBuilder(
    column: $table.bitterness,
    builder: (column) => column,
  );

  GeneratedColumn<double> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get flavorNotes => $composableBuilder(
    column: $table.flavorNotes,
    builder: (column) => column,
  );

  $$BrewRecordsTableAnnotationComposer get brewRecordId {
    final $$BrewRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewRatingsTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewRatingsTable,
          BrewRating,
          $$BrewRatingsTableFilterComposer,
          $$BrewRatingsTableOrderingComposer,
          $$BrewRatingsTableAnnotationComposer,
          $$BrewRatingsTableCreateCompanionBuilder,
          $$BrewRatingsTableUpdateCompanionBuilder,
          (BrewRating, $$BrewRatingsTableReferences),
          BrewRating,
          PrefetchHooks Function({bool brewRecordId})
        > {
  $$BrewRatingsTableTableManager(_$OneBrewDatabase db, $BrewRatingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewRatingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewRatingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewRatingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brewRecordId = const Value.absent(),
                Value<int?> quickScore = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<double?> acidity = const Value.absent(),
                Value<double?> sweetness = const Value.absent(),
                Value<double?> bitterness = const Value.absent(),
                Value<double?> body = const Value.absent(),
                Value<String?> flavorNotes = const Value.absent(),
              }) => BrewRatingsCompanion(
                id: id,
                brewRecordId: brewRecordId,
                quickScore: quickScore,
                emoji: emoji,
                acidity: acidity,
                sweetness: sweetness,
                bitterness: bitterness,
                body: body,
                flavorNotes: flavorNotes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brewRecordId,
                Value<int?> quickScore = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<double?> acidity = const Value.absent(),
                Value<double?> sweetness = const Value.absent(),
                Value<double?> bitterness = const Value.absent(),
                Value<double?> body = const Value.absent(),
                Value<String?> flavorNotes = const Value.absent(),
              }) => BrewRatingsCompanion.insert(
                id: id,
                brewRecordId: brewRecordId,
                quickScore: quickScore,
                emoji: emoji,
                acidity: acidity,
                sweetness: sweetness,
                bitterness: bitterness,
                body: body,
                flavorNotes: flavorNotes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrewRatingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brewRecordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (brewRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.brewRecordId,
                                referencedTable: $$BrewRatingsTableReferences
                                    ._brewRecordIdTable(db),
                                referencedColumn: $$BrewRatingsTableReferences
                                    ._brewRecordIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BrewRatingsTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewRatingsTable,
      BrewRating,
      $$BrewRatingsTableFilterComposer,
      $$BrewRatingsTableOrderingComposer,
      $$BrewRatingsTableAnnotationComposer,
      $$BrewRatingsTableCreateCompanionBuilder,
      $$BrewRatingsTableUpdateCompanionBuilder,
      (BrewRating, $$BrewRatingsTableReferences),
      BrewRating,
      PrefetchHooks Function({bool brewRecordId})
    >;
typedef $$BrewMethodConfigsTableCreateCompanionBuilder =
    BrewMethodConfigsCompanion Function({
      Value<int> id,
      required String method,
      required String displayName,
      Value<bool> isEnabled,
    });
typedef $$BrewMethodConfigsTableUpdateCompanionBuilder =
    BrewMethodConfigsCompanion Function({
      Value<int> id,
      Value<String> method,
      Value<String> displayName,
      Value<bool> isEnabled,
    });

class $$BrewMethodConfigsTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewMethodConfigsTable> {
  $$BrewMethodConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrewMethodConfigsTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewMethodConfigsTable> {
  $$BrewMethodConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrewMethodConfigsTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewMethodConfigsTable> {
  $$BrewMethodConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);
}

class $$BrewMethodConfigsTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewMethodConfigsTable,
          BrewMethodConfig,
          $$BrewMethodConfigsTableFilterComposer,
          $$BrewMethodConfigsTableOrderingComposer,
          $$BrewMethodConfigsTableAnnotationComposer,
          $$BrewMethodConfigsTableCreateCompanionBuilder,
          $$BrewMethodConfigsTableUpdateCompanionBuilder,
          (
            BrewMethodConfig,
            BaseReferences<
              _$OneBrewDatabase,
              $BrewMethodConfigsTable,
              BrewMethodConfig
            >,
          ),
          BrewMethodConfig,
          PrefetchHooks Function()
        > {
  $$BrewMethodConfigsTableTableManager(
    _$OneBrewDatabase db,
    $BrewMethodConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewMethodConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewMethodConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewMethodConfigsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
              }) => BrewMethodConfigsCompanion(
                id: id,
                method: method,
                displayName: displayName,
                isEnabled: isEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String method,
                required String displayName,
                Value<bool> isEnabled = const Value.absent(),
              }) => BrewMethodConfigsCompanion.insert(
                id: id,
                method: method,
                displayName: displayName,
                isEnabled: isEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrewMethodConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewMethodConfigsTable,
      BrewMethodConfig,
      $$BrewMethodConfigsTableFilterComposer,
      $$BrewMethodConfigsTableOrderingComposer,
      $$BrewMethodConfigsTableAnnotationComposer,
      $$BrewMethodConfigsTableCreateCompanionBuilder,
      $$BrewMethodConfigsTableUpdateCompanionBuilder,
      (
        BrewMethodConfig,
        BaseReferences<
          _$OneBrewDatabase,
          $BrewMethodConfigsTable,
          BrewMethodConfig
        >,
      ),
      BrewMethodConfig,
      PrefetchHooks Function()
    >;
typedef $$BrewParamDefinitionsTableCreateCompanionBuilder =
    BrewParamDefinitionsCompanion Function({
      Value<int> id,
      required String method,
      required String name,
      required String type,
      Value<String?> unit,
      Value<bool> isSystem,
      required int sortOrder,
    });
typedef $$BrewParamDefinitionsTableUpdateCompanionBuilder =
    BrewParamDefinitionsCompanion Function({
      Value<int> id,
      Value<String> method,
      Value<String> name,
      Value<String> type,
      Value<String?> unit,
      Value<bool> isSystem,
      Value<int> sortOrder,
    });

final class $$BrewParamDefinitionsTableReferences
    extends
        BaseReferences<
          _$OneBrewDatabase,
          $BrewParamDefinitionsTable,
          BrewParamDefinition
        > {
  $$BrewParamDefinitionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $BrewParamVisibilitiesTable,
    List<BrewParamVisibility>
  >
  _brewParamVisibilitiesRefsTable(_$OneBrewDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.brewParamVisibilities,
        aliasName: $_aliasNameGenerator(
          db.brewParamDefinitions.id,
          db.brewParamVisibilities.paramId,
        ),
      );

  $$BrewParamVisibilitiesTableProcessedTableManager
  get brewParamVisibilitiesRefs {
    final manager = $$BrewParamVisibilitiesTableTableManager(
      $_db,
      $_db.brewParamVisibilities,
    ).filter((f) => f.paramId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _brewParamVisibilitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BrewParamValuesTable, List<BrewParamValue>>
  _brewParamValuesRefsTable(_$OneBrewDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.brewParamValues,
        aliasName: $_aliasNameGenerator(
          db.brewParamDefinitions.id,
          db.brewParamValues.paramId,
        ),
      );

  $$BrewParamValuesTableProcessedTableManager get brewParamValuesRefs {
    final manager = $$BrewParamValuesTableTableManager(
      $_db,
      $_db.brewParamValues,
    ).filter((f) => f.paramId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _brewParamValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrewParamDefinitionsTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewParamDefinitionsTable> {
  $$BrewParamDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> brewParamVisibilitiesRefs(
    Expression<bool> Function($$BrewParamVisibilitiesTableFilterComposer f) f,
  ) {
    final $$BrewParamVisibilitiesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.brewParamVisibilities,
          getReferencedColumn: (t) => t.paramId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamVisibilitiesTableFilterComposer(
                $db: $db,
                $table: $db.brewParamVisibilities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> brewParamValuesRefs(
    Expression<bool> Function($$BrewParamValuesTableFilterComposer f) f,
  ) {
    final $$BrewParamValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewParamValues,
      getReferencedColumn: (t) => t.paramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamValuesTableFilterComposer(
            $db: $db,
            $table: $db.brewParamValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrewParamDefinitionsTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewParamDefinitionsTable> {
  $$BrewParamDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrewParamDefinitionsTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewParamDefinitionsTable> {
  $$BrewParamDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> brewParamVisibilitiesRefs<T extends Object>(
    Expression<T> Function($$BrewParamVisibilitiesTableAnnotationComposer a) f,
  ) {
    final $$BrewParamVisibilitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.brewParamVisibilities,
          getReferencedColumn: (t) => t.paramId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamVisibilitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.brewParamVisibilities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> brewParamValuesRefs<T extends Object>(
    Expression<T> Function($$BrewParamValuesTableAnnotationComposer a) f,
  ) {
    final $$BrewParamValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brewParamValues,
      getReferencedColumn: (t) => t.paramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.brewParamValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrewParamDefinitionsTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewParamDefinitionsTable,
          BrewParamDefinition,
          $$BrewParamDefinitionsTableFilterComposer,
          $$BrewParamDefinitionsTableOrderingComposer,
          $$BrewParamDefinitionsTableAnnotationComposer,
          $$BrewParamDefinitionsTableCreateCompanionBuilder,
          $$BrewParamDefinitionsTableUpdateCompanionBuilder,
          (BrewParamDefinition, $$BrewParamDefinitionsTableReferences),
          BrewParamDefinition,
          PrefetchHooks Function({
            bool brewParamVisibilitiesRefs,
            bool brewParamValuesRefs,
          })
        > {
  $$BrewParamDefinitionsTableTableManager(
    _$OneBrewDatabase db,
    $BrewParamDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewParamDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewParamDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BrewParamDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => BrewParamDefinitionsCompanion(
                id: id,
                method: method,
                name: name,
                type: type,
                unit: unit,
                isSystem: isSystem,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String method,
                required String name,
                required String type,
                Value<String?> unit = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                required int sortOrder,
              }) => BrewParamDefinitionsCompanion.insert(
                id: id,
                method: method,
                name: name,
                type: type,
                unit: unit,
                isSystem: isSystem,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrewParamDefinitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                brewParamVisibilitiesRefs = false,
                brewParamValuesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (brewParamVisibilitiesRefs) db.brewParamVisibilities,
                    if (brewParamValuesRefs) db.brewParamValues,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (brewParamVisibilitiesRefs)
                        await $_getPrefetchedData<
                          BrewParamDefinition,
                          $BrewParamDefinitionsTable,
                          BrewParamVisibility
                        >(
                          currentTable: table,
                          referencedTable: $$BrewParamDefinitionsTableReferences
                              ._brewParamVisibilitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrewParamDefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).brewParamVisibilitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.paramId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (brewParamValuesRefs)
                        await $_getPrefetchedData<
                          BrewParamDefinition,
                          $BrewParamDefinitionsTable,
                          BrewParamValue
                        >(
                          currentTable: table,
                          referencedTable: $$BrewParamDefinitionsTableReferences
                              ._brewParamValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrewParamDefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).brewParamValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.paramId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BrewParamDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewParamDefinitionsTable,
      BrewParamDefinition,
      $$BrewParamDefinitionsTableFilterComposer,
      $$BrewParamDefinitionsTableOrderingComposer,
      $$BrewParamDefinitionsTableAnnotationComposer,
      $$BrewParamDefinitionsTableCreateCompanionBuilder,
      $$BrewParamDefinitionsTableUpdateCompanionBuilder,
      (BrewParamDefinition, $$BrewParamDefinitionsTableReferences),
      BrewParamDefinition,
      PrefetchHooks Function({
        bool brewParamVisibilitiesRefs,
        bool brewParamValuesRefs,
      })
    >;
typedef $$BrewParamVisibilitiesTableCreateCompanionBuilder =
    BrewParamVisibilitiesCompanion Function({
      Value<int> id,
      required String method,
      required int paramId,
      Value<bool> isVisible,
    });
typedef $$BrewParamVisibilitiesTableUpdateCompanionBuilder =
    BrewParamVisibilitiesCompanion Function({
      Value<int> id,
      Value<String> method,
      Value<int> paramId,
      Value<bool> isVisible,
    });

final class $$BrewParamVisibilitiesTableReferences
    extends
        BaseReferences<
          _$OneBrewDatabase,
          $BrewParamVisibilitiesTable,
          BrewParamVisibility
        > {
  $$BrewParamVisibilitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BrewParamDefinitionsTable _paramIdTable(_$OneBrewDatabase db) =>
      db.brewParamDefinitions.createAlias(
        $_aliasNameGenerator(
          db.brewParamVisibilities.paramId,
          db.brewParamDefinitions.id,
        ),
      );

  $$BrewParamDefinitionsTableProcessedTableManager get paramId {
    final $_column = $_itemColumn<int>('param_id')!;

    final manager = $$BrewParamDefinitionsTableTableManager(
      $_db,
      $_db.brewParamDefinitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paramIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BrewParamVisibilitiesTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewParamVisibilitiesTable> {
  $$BrewParamVisibilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  $$BrewParamDefinitionsTableFilterComposer get paramId {
    final $$BrewParamDefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paramId,
      referencedTable: $db.brewParamDefinitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamDefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.brewParamDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewParamVisibilitiesTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewParamVisibilitiesTable> {
  $$BrewParamVisibilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrewParamDefinitionsTableOrderingComposer get paramId {
    final $$BrewParamDefinitionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.paramId,
          referencedTable: $db.brewParamDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamDefinitionsTableOrderingComposer(
                $db: $db,
                $table: $db.brewParamDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BrewParamVisibilitiesTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewParamVisibilitiesTable> {
  $$BrewParamVisibilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  $$BrewParamDefinitionsTableAnnotationComposer get paramId {
    final $$BrewParamDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.paramId,
          referencedTable: $db.brewParamDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamDefinitionsTableAnnotationComposer(
                $db: $db,
                $table: $db.brewParamDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BrewParamVisibilitiesTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewParamVisibilitiesTable,
          BrewParamVisibility,
          $$BrewParamVisibilitiesTableFilterComposer,
          $$BrewParamVisibilitiesTableOrderingComposer,
          $$BrewParamVisibilitiesTableAnnotationComposer,
          $$BrewParamVisibilitiesTableCreateCompanionBuilder,
          $$BrewParamVisibilitiesTableUpdateCompanionBuilder,
          (BrewParamVisibility, $$BrewParamVisibilitiesTableReferences),
          BrewParamVisibility,
          PrefetchHooks Function({bool paramId})
        > {
  $$BrewParamVisibilitiesTableTableManager(
    _$OneBrewDatabase db,
    $BrewParamVisibilitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewParamVisibilitiesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BrewParamVisibilitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BrewParamVisibilitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> paramId = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
              }) => BrewParamVisibilitiesCompanion(
                id: id,
                method: method,
                paramId: paramId,
                isVisible: isVisible,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String method,
                required int paramId,
                Value<bool> isVisible = const Value.absent(),
              }) => BrewParamVisibilitiesCompanion.insert(
                id: id,
                method: method,
                paramId: paramId,
                isVisible: isVisible,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrewParamVisibilitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({paramId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (paramId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.paramId,
                                referencedTable:
                                    $$BrewParamVisibilitiesTableReferences
                                        ._paramIdTable(db),
                                referencedColumn:
                                    $$BrewParamVisibilitiesTableReferences
                                        ._paramIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BrewParamVisibilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewParamVisibilitiesTable,
      BrewParamVisibility,
      $$BrewParamVisibilitiesTableFilterComposer,
      $$BrewParamVisibilitiesTableOrderingComposer,
      $$BrewParamVisibilitiesTableAnnotationComposer,
      $$BrewParamVisibilitiesTableCreateCompanionBuilder,
      $$BrewParamVisibilitiesTableUpdateCompanionBuilder,
      (BrewParamVisibility, $$BrewParamVisibilitiesTableReferences),
      BrewParamVisibility,
      PrefetchHooks Function({bool paramId})
    >;
typedef $$BrewParamValuesTableCreateCompanionBuilder =
    BrewParamValuesCompanion Function({
      Value<int> id,
      required int brewRecordId,
      required int paramId,
      Value<double?> valueNumber,
      Value<String?> valueText,
    });
typedef $$BrewParamValuesTableUpdateCompanionBuilder =
    BrewParamValuesCompanion Function({
      Value<int> id,
      Value<int> brewRecordId,
      Value<int> paramId,
      Value<double?> valueNumber,
      Value<String?> valueText,
    });

final class $$BrewParamValuesTableReferences
    extends
        BaseReferences<
          _$OneBrewDatabase,
          $BrewParamValuesTable,
          BrewParamValue
        > {
  $$BrewParamValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BrewRecordsTable _brewRecordIdTable(_$OneBrewDatabase db) =>
      db.brewRecords.createAlias(
        $_aliasNameGenerator(
          db.brewParamValues.brewRecordId,
          db.brewRecords.id,
        ),
      );

  $$BrewRecordsTableProcessedTableManager get brewRecordId {
    final $_column = $_itemColumn<int>('brew_record_id')!;

    final manager = $$BrewRecordsTableTableManager(
      $_db,
      $_db.brewRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brewRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BrewParamDefinitionsTable _paramIdTable(_$OneBrewDatabase db) =>
      db.brewParamDefinitions.createAlias(
        $_aliasNameGenerator(
          db.brewParamValues.paramId,
          db.brewParamDefinitions.id,
        ),
      );

  $$BrewParamDefinitionsTableProcessedTableManager get paramId {
    final $_column = $_itemColumn<int>('param_id')!;

    final manager = $$BrewParamDefinitionsTableTableManager(
      $_db,
      $_db.brewParamDefinitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paramIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BrewParamValuesTableFilterComposer
    extends Composer<_$OneBrewDatabase, $BrewParamValuesTable> {
  $$BrewParamValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnFilters(column),
  );

  $$BrewRecordsTableFilterComposer get brewRecordId {
    final $$BrewRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableFilterComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrewParamDefinitionsTableFilterComposer get paramId {
    final $$BrewParamDefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paramId,
      referencedTable: $db.brewParamDefinitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewParamDefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.brewParamDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewParamValuesTableOrderingComposer
    extends Composer<_$OneBrewDatabase, $BrewParamValuesTable> {
  $$BrewParamValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrewRecordsTableOrderingComposer get brewRecordId {
    final $$BrewRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrewParamDefinitionsTableOrderingComposer get paramId {
    final $$BrewParamDefinitionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.paramId,
          referencedTable: $db.brewParamDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamDefinitionsTableOrderingComposer(
                $db: $db,
                $table: $db.brewParamDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BrewParamValuesTableAnnotationComposer
    extends Composer<_$OneBrewDatabase, $BrewParamValuesTable> {
  $$BrewParamValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueText =>
      $composableBuilder(column: $table.valueText, builder: (column) => column);

  $$BrewRecordsTableAnnotationComposer get brewRecordId {
    final $$BrewRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brewRecordId,
      referencedTable: $db.brewRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.brewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrewParamDefinitionsTableAnnotationComposer get paramId {
    final $$BrewParamDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.paramId,
          referencedTable: $db.brewParamDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BrewParamDefinitionsTableAnnotationComposer(
                $db: $db,
                $table: $db.brewParamDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BrewParamValuesTableTableManager
    extends
        RootTableManager<
          _$OneBrewDatabase,
          $BrewParamValuesTable,
          BrewParamValue,
          $$BrewParamValuesTableFilterComposer,
          $$BrewParamValuesTableOrderingComposer,
          $$BrewParamValuesTableAnnotationComposer,
          $$BrewParamValuesTableCreateCompanionBuilder,
          $$BrewParamValuesTableUpdateCompanionBuilder,
          (BrewParamValue, $$BrewParamValuesTableReferences),
          BrewParamValue,
          PrefetchHooks Function({bool brewRecordId, bool paramId})
        > {
  $$BrewParamValuesTableTableManager(
    _$OneBrewDatabase db,
    $BrewParamValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewParamValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewParamValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewParamValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brewRecordId = const Value.absent(),
                Value<int> paramId = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
              }) => BrewParamValuesCompanion(
                id: id,
                brewRecordId: brewRecordId,
                paramId: paramId,
                valueNumber: valueNumber,
                valueText: valueText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brewRecordId,
                required int paramId,
                Value<double?> valueNumber = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
              }) => BrewParamValuesCompanion.insert(
                id: id,
                brewRecordId: brewRecordId,
                paramId: paramId,
                valueNumber: valueNumber,
                valueText: valueText,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrewParamValuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brewRecordId = false, paramId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (brewRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.brewRecordId,
                                referencedTable:
                                    $$BrewParamValuesTableReferences
                                        ._brewRecordIdTable(db),
                                referencedColumn:
                                    $$BrewParamValuesTableReferences
                                        ._brewRecordIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (paramId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.paramId,
                                referencedTable:
                                    $$BrewParamValuesTableReferences
                                        ._paramIdTable(db),
                                referencedColumn:
                                    $$BrewParamValuesTableReferences
                                        ._paramIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BrewParamValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$OneBrewDatabase,
      $BrewParamValuesTable,
      BrewParamValue,
      $$BrewParamValuesTableFilterComposer,
      $$BrewParamValuesTableOrderingComposer,
      $$BrewParamValuesTableAnnotationComposer,
      $$BrewParamValuesTableCreateCompanionBuilder,
      $$BrewParamValuesTableUpdateCompanionBuilder,
      (BrewParamValue, $$BrewParamValuesTableReferences),
      BrewParamValue,
      PrefetchHooks Function({bool brewRecordId, bool paramId})
    >;

class $OneBrewDatabaseManager {
  final _$OneBrewDatabase _db;
  $OneBrewDatabaseManager(this._db);
  $$BeansTableTableManager get beans =>
      $$BeansTableTableManager(_db, _db.beans);
  $$EquipmentsTableTableManager get equipments =>
      $$EquipmentsTableTableManager(_db, _db.equipments);
  $$BrewRecordsTableTableManager get brewRecords =>
      $$BrewRecordsTableTableManager(_db, _db.brewRecords);
  $$BrewRatingsTableTableManager get brewRatings =>
      $$BrewRatingsTableTableManager(_db, _db.brewRatings);
  $$BrewMethodConfigsTableTableManager get brewMethodConfigs =>
      $$BrewMethodConfigsTableTableManager(_db, _db.brewMethodConfigs);
  $$BrewParamDefinitionsTableTableManager get brewParamDefinitions =>
      $$BrewParamDefinitionsTableTableManager(_db, _db.brewParamDefinitions);
  $$BrewParamVisibilitiesTableTableManager get brewParamVisibilities =>
      $$BrewParamVisibilitiesTableTableManager(_db, _db.brewParamVisibilities);
  $$BrewParamValuesTableTableManager get brewParamValues =>
      $$BrewParamValuesTableTableManager(_db, _db.brewParamValues);
}
