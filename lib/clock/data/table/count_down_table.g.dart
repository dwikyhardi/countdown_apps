// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_down_table.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CountDownTableData extends DataClass
    implements Insertable<CountDownTableData> {
  final int countDownTimeInMs;
  final int remainingCountDownTimeInMs;
  final int? countDownId;
  final int? timeToStopCountDown;
  final bool? isStop;
  final bool? isActive;
  CountDownTableData(
      {required this.countDownTimeInMs,
      required this.remainingCountDownTimeInMs,
      this.countDownId,
      this.timeToStopCountDown,
      this.isStop,
      this.isActive});
  factory CountDownTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CountDownTableData(
      countDownTimeInMs: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}count_down_time_in_ms'])!,
      remainingCountDownTimeInMs: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}remaining_count_down_time_in_ms'])!,
      countDownId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}count_down_id']),
      timeToStopCountDown: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}time_to_stop_count_down']),
      isStop: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_stop']),
      isActive: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['count_down_time_in_ms'] = Variable<int>(countDownTimeInMs);
    map['remaining_count_down_time_in_ms'] =
        Variable<int>(remainingCountDownTimeInMs);
    if (!nullToAbsent || countDownId != null) {
      map['count_down_id'] = Variable<int?>(countDownId);
    }
    if (!nullToAbsent || timeToStopCountDown != null) {
      map['time_to_stop_count_down'] = Variable<int?>(timeToStopCountDown);
    }
    if (!nullToAbsent || isStop != null) {
      map['is_stop'] = Variable<bool?>(isStop);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool?>(isActive);
    }
    return map;
  }

  CountDownTableCompanion toCompanion(bool nullToAbsent) {
    return CountDownTableCompanion(
      countDownTimeInMs: Value(countDownTimeInMs),
      remainingCountDownTimeInMs: Value(remainingCountDownTimeInMs),
      countDownId: countDownId == null && nullToAbsent
          ? const Value.absent()
          : Value(countDownId),
      timeToStopCountDown: timeToStopCountDown == null && nullToAbsent
          ? const Value.absent()
          : Value(timeToStopCountDown),
      isStop:
          isStop == null && nullToAbsent ? const Value.absent() : Value(isStop),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
    );
  }

  factory CountDownTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CountDownTableData(
      countDownTimeInMs: serializer.fromJson<int>(json['countDownTimeInMs']),
      remainingCountDownTimeInMs:
          serializer.fromJson<int>(json['remainingCountDownTimeInMs']),
      countDownId: serializer.fromJson<int?>(json['countDownId']),
      timeToStopCountDown:
          serializer.fromJson<int?>(json['timeToStopCountDown']),
      isStop: serializer.fromJson<bool?>(json['isStop']),
      isActive: serializer.fromJson<bool?>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'countDownTimeInMs': serializer.toJson<int>(countDownTimeInMs),
      'remainingCountDownTimeInMs':
          serializer.toJson<int>(remainingCountDownTimeInMs),
      'countDownId': serializer.toJson<int?>(countDownId),
      'timeToStopCountDown': serializer.toJson<int?>(timeToStopCountDown),
      'isStop': serializer.toJson<bool?>(isStop),
      'isActive': serializer.toJson<bool?>(isActive),
    };
  }

  CountDownTableData copyWith(
          {int? countDownTimeInMs,
          int? remainingCountDownTimeInMs,
          int? countDownId,
          int? timeToStopCountDown,
          bool? isStop,
          bool? isActive}) =>
      CountDownTableData(
        countDownTimeInMs: countDownTimeInMs ?? this.countDownTimeInMs,
        remainingCountDownTimeInMs:
            remainingCountDownTimeInMs ?? this.remainingCountDownTimeInMs,
        countDownId: countDownId ?? this.countDownId,
        timeToStopCountDown: timeToStopCountDown ?? this.timeToStopCountDown,
        isStop: isStop ?? this.isStop,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('CountDownTableData(')
          ..write('countDownTimeInMs: $countDownTimeInMs, ')
          ..write('remainingCountDownTimeInMs: $remainingCountDownTimeInMs, ')
          ..write('countDownId: $countDownId, ')
          ..write('timeToStopCountDown: $timeToStopCountDown, ')
          ..write('isStop: $isStop, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(countDownTimeInMs, remainingCountDownTimeInMs,
      countDownId, timeToStopCountDown, isStop, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CountDownTableData &&
          other.countDownTimeInMs == this.countDownTimeInMs &&
          other.remainingCountDownTimeInMs == this.remainingCountDownTimeInMs &&
          other.countDownId == this.countDownId &&
          other.timeToStopCountDown == this.timeToStopCountDown &&
          other.isStop == this.isStop &&
          other.isActive == this.isActive);
}

class CountDownTableCompanion extends UpdateCompanion<CountDownTableData> {
  final Value<int> countDownTimeInMs;
  final Value<int> remainingCountDownTimeInMs;
  final Value<int?> countDownId;
  final Value<int?> timeToStopCountDown;
  final Value<bool?> isStop;
  final Value<bool?> isActive;
  const CountDownTableCompanion({
    this.countDownTimeInMs = const Value.absent(),
    this.remainingCountDownTimeInMs = const Value.absent(),
    this.countDownId = const Value.absent(),
    this.timeToStopCountDown = const Value.absent(),
    this.isStop = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CountDownTableCompanion.insert({
    required int countDownTimeInMs,
    required int remainingCountDownTimeInMs,
    this.countDownId = const Value.absent(),
    this.timeToStopCountDown = const Value.absent(),
    this.isStop = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : countDownTimeInMs = Value(countDownTimeInMs),
        remainingCountDownTimeInMs = Value(remainingCountDownTimeInMs);
  static Insertable<CountDownTableData> custom({
    Expression<int>? countDownTimeInMs,
    Expression<int>? remainingCountDownTimeInMs,
    Expression<int?>? countDownId,
    Expression<int?>? timeToStopCountDown,
    Expression<bool?>? isStop,
    Expression<bool?>? isActive,
  }) {
    return RawValuesInsertable({
      if (countDownTimeInMs != null) 'count_down_time_in_ms': countDownTimeInMs,
      if (remainingCountDownTimeInMs != null)
        'remaining_count_down_time_in_ms': remainingCountDownTimeInMs,
      if (countDownId != null) 'count_down_id': countDownId,
      if (timeToStopCountDown != null)
        'time_to_stop_count_down': timeToStopCountDown,
      if (isStop != null) 'is_stop': isStop,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CountDownTableCompanion copyWith(
      {Value<int>? countDownTimeInMs,
      Value<int>? remainingCountDownTimeInMs,
      Value<int?>? countDownId,
      Value<int?>? timeToStopCountDown,
      Value<bool?>? isStop,
      Value<bool?>? isActive}) {
    return CountDownTableCompanion(
      countDownTimeInMs: countDownTimeInMs ?? this.countDownTimeInMs,
      remainingCountDownTimeInMs:
          remainingCountDownTimeInMs ?? this.remainingCountDownTimeInMs,
      countDownId: countDownId ?? this.countDownId,
      timeToStopCountDown: timeToStopCountDown ?? this.timeToStopCountDown,
      isStop: isStop ?? this.isStop,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (countDownTimeInMs.present) {
      map['count_down_time_in_ms'] = Variable<int>(countDownTimeInMs.value);
    }
    if (remainingCountDownTimeInMs.present) {
      map['remaining_count_down_time_in_ms'] =
          Variable<int>(remainingCountDownTimeInMs.value);
    }
    if (countDownId.present) {
      map['count_down_id'] = Variable<int?>(countDownId.value);
    }
    if (timeToStopCountDown.present) {
      map['time_to_stop_count_down'] =
          Variable<int?>(timeToStopCountDown.value);
    }
    if (isStop.present) {
      map['is_stop'] = Variable<bool?>(isStop.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool?>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountDownTableCompanion(')
          ..write('countDownTimeInMs: $countDownTimeInMs, ')
          ..write('remainingCountDownTimeInMs: $remainingCountDownTimeInMs, ')
          ..write('countDownId: $countDownId, ')
          ..write('timeToStopCountDown: $timeToStopCountDown, ')
          ..write('isStop: $isStop, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $CountDownTableTable extends CountDownTable
    with TableInfo<$CountDownTableTable, CountDownTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CountDownTableTable(this._db, [this._alias]);
  final VerificationMeta _countDownTimeInMsMeta =
      const VerificationMeta('countDownTimeInMs');
  late final GeneratedColumn<int?> countDownTimeInMs = GeneratedColumn<int?>(
      'count_down_time_in_ms', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _remainingCountDownTimeInMsMeta =
      const VerificationMeta('remainingCountDownTimeInMs');
  late final GeneratedColumn<int?> remainingCountDownTimeInMs =
      GeneratedColumn<int?>(
          'remaining_count_down_time_in_ms', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _countDownIdMeta =
      const VerificationMeta('countDownId');
  late final GeneratedColumn<int?> countDownId = GeneratedColumn<int?>(
      'count_down_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _timeToStopCountDownMeta =
      const VerificationMeta('timeToStopCountDown');
  late final GeneratedColumn<int?> timeToStopCountDown = GeneratedColumn<int?>(
      'time_to_stop_count_down', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _isStopMeta = const VerificationMeta('isStop');
  late final GeneratedColumn<bool?> isStop = GeneratedColumn<bool?>(
      'is_stop', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_stop IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  late final GeneratedColumn<bool?> isActive = GeneratedColumn<bool?>(
      'is_active', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_active IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        countDownTimeInMs,
        remainingCountDownTimeInMs,
        countDownId,
        timeToStopCountDown,
        isStop,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? 'count_down_table';
  @override
  String get actualTableName => 'count_down_table';
  @override
  VerificationContext validateIntegrity(Insertable<CountDownTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('count_down_time_in_ms')) {
      context.handle(
          _countDownTimeInMsMeta,
          countDownTimeInMs.isAcceptableOrUnknown(
              data['count_down_time_in_ms']!, _countDownTimeInMsMeta));
    } else if (isInserting) {
      context.missing(_countDownTimeInMsMeta);
    }
    if (data.containsKey('remaining_count_down_time_in_ms')) {
      context.handle(
          _remainingCountDownTimeInMsMeta,
          remainingCountDownTimeInMs.isAcceptableOrUnknown(
              data['remaining_count_down_time_in_ms']!,
              _remainingCountDownTimeInMsMeta));
    } else if (isInserting) {
      context.missing(_remainingCountDownTimeInMsMeta);
    }
    if (data.containsKey('count_down_id')) {
      context.handle(
          _countDownIdMeta,
          countDownId.isAcceptableOrUnknown(
              data['count_down_id']!, _countDownIdMeta));
    }
    if (data.containsKey('time_to_stop_count_down')) {
      context.handle(
          _timeToStopCountDownMeta,
          timeToStopCountDown.isAcceptableOrUnknown(
              data['time_to_stop_count_down']!, _timeToStopCountDownMeta));
    }
    if (data.containsKey('is_stop')) {
      context.handle(_isStopMeta,
          isStop.isAcceptableOrUnknown(data['is_stop']!, _isStopMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {countDownId};
  @override
  CountDownTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CountDownTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CountDownTableTable createAlias(String alias) {
    return $CountDownTableTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $CountDownTableTable countDownTable = $CountDownTableTable(this);
  late final AppDao appDao = AppDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [countDownTable];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$AppDaoMixin on DatabaseAccessor<AppDatabase> {
  $CountDownTableTable get countDownTable => attachedDatabase.countDownTable;
}
