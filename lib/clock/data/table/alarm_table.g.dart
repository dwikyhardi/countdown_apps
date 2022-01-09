// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_table.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class AlarmTableData extends DataClass implements Insertable<AlarmTableData> {
  final int alarmTimeInMs;
  final int? alarmId;
  final int? timeToStopAlarm;
  final bool? isStop;
  final bool? isActive;
  AlarmTableData(
      {required this.alarmTimeInMs,
      this.alarmId,
      this.timeToStopAlarm,
      this.isStop,
      this.isActive});
  factory AlarmTableData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AlarmTableData(
      alarmTimeInMs: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}alarm_time_in_ms'])!,
      alarmId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}alarm_id']),
      timeToStopAlarm: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}time_to_stop_alarm']),
      isStop: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_stop']),
      isActive: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_active']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alarm_time_in_ms'] = Variable<int>(alarmTimeInMs);
    if (!nullToAbsent || alarmId != null) {
      map['alarm_id'] = Variable<int?>(alarmId);
    }
    if (!nullToAbsent || timeToStopAlarm != null) {
      map['time_to_stop_alarm'] = Variable<int?>(timeToStopAlarm);
    }
    if (!nullToAbsent || isStop != null) {
      map['is_stop'] = Variable<bool?>(isStop);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool?>(isActive);
    }
    return map;
  }

  AlarmTableCompanion toCompanion(bool nullToAbsent) {
    return AlarmTableCompanion(
      alarmTimeInMs: Value(alarmTimeInMs),
      alarmId: alarmId == null && nullToAbsent
          ? const Value.absent()
          : Value(alarmId),
      timeToStopAlarm: timeToStopAlarm == null && nullToAbsent
          ? const Value.absent()
          : Value(timeToStopAlarm),
      isStop:
          isStop == null && nullToAbsent ? const Value.absent() : Value(isStop),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
    );
  }

  factory AlarmTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmTableData(
      alarmTimeInMs: serializer.fromJson<int>(json['alarmTimeInMs']),
      alarmId: serializer.fromJson<int?>(json['alarmId']),
      timeToStopAlarm: serializer.fromJson<int?>(json['timeToStopAlarm']),
      isStop: serializer.fromJson<bool?>(json['isStop']),
      isActive: serializer.fromJson<bool?>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'alarmTimeInMs': serializer.toJson<int>(alarmTimeInMs),
      'alarmId': serializer.toJson<int?>(alarmId),
      'timeToStopAlarm': serializer.toJson<int?>(timeToStopAlarm),
      'isStop': serializer.toJson<bool?>(isStop),
      'isActive': serializer.toJson<bool?>(isActive),
    };
  }

  AlarmTableData copyWith(
          {int? alarmTimeInMs,
          int? alarmId,
          int? timeToStopAlarm,
          bool? isStop,
          bool? isActive}) =>
      AlarmTableData(
        alarmTimeInMs: alarmTimeInMs ?? this.alarmTimeInMs,
        alarmId: alarmId ?? this.alarmId,
        timeToStopAlarm: timeToStopAlarm ?? this.timeToStopAlarm,
        isStop: isStop ?? this.isStop,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('AlarmTableData(')
          ..write('alarmTimeInMs: $alarmTimeInMs, ')
          ..write('alarmId: $alarmId, ')
          ..write('timeToStopAlarm: $timeToStopAlarm, ')
          ..write('isStop: $isStop, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(alarmTimeInMs, alarmId, timeToStopAlarm, isStop, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmTableData &&
          other.alarmTimeInMs == this.alarmTimeInMs &&
          other.alarmId == this.alarmId &&
          other.timeToStopAlarm == this.timeToStopAlarm &&
          other.isStop == this.isStop &&
          other.isActive == this.isActive);
}

class AlarmTableCompanion extends UpdateCompanion<AlarmTableData> {
  final Value<int> alarmTimeInMs;
  final Value<int?> alarmId;
  final Value<int?> timeToStopAlarm;
  final Value<bool?> isStop;
  final Value<bool?> isActive;
  const AlarmTableCompanion({
    this.alarmTimeInMs = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.timeToStopAlarm = const Value.absent(),
    this.isStop = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AlarmTableCompanion.insert({
    required int alarmTimeInMs,
    this.alarmId = const Value.absent(),
    this.timeToStopAlarm = const Value.absent(),
    this.isStop = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : alarmTimeInMs = Value(alarmTimeInMs);
  static Insertable<AlarmTableData> custom({
    Expression<int>? alarmTimeInMs,
    Expression<int?>? alarmId,
    Expression<int?>? timeToStopAlarm,
    Expression<bool?>? isStop,
    Expression<bool?>? isActive,
  }) {
    return RawValuesInsertable({
      if (alarmTimeInMs != null) 'alarm_time_in_ms': alarmTimeInMs,
      if (alarmId != null) 'alarm_id': alarmId,
      if (timeToStopAlarm != null) 'time_to_stop_alarm': timeToStopAlarm,
      if (isStop != null) 'is_stop': isStop,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AlarmTableCompanion copyWith(
      {Value<int>? alarmTimeInMs,
      Value<int?>? alarmId,
      Value<int?>? timeToStopAlarm,
      Value<bool?>? isStop,
      Value<bool?>? isActive}) {
    return AlarmTableCompanion(
      alarmTimeInMs: alarmTimeInMs ?? this.alarmTimeInMs,
      alarmId: alarmId ?? this.alarmId,
      timeToStopAlarm: timeToStopAlarm ?? this.timeToStopAlarm,
      isStop: isStop ?? this.isStop,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (alarmTimeInMs.present) {
      map['alarm_time_in_ms'] = Variable<int>(alarmTimeInMs.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<int?>(alarmId.value);
    }
    if (timeToStopAlarm.present) {
      map['time_to_stop_alarm'] = Variable<int?>(timeToStopAlarm.value);
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
    return (StringBuffer('AlarmTableCompanion(')
          ..write('alarmTimeInMs: $alarmTimeInMs, ')
          ..write('alarmId: $alarmId, ')
          ..write('timeToStopAlarm: $timeToStopAlarm, ')
          ..write('isStop: $isStop, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AlarmTableTable extends AlarmTable
    with TableInfo<$AlarmTableTable, AlarmTableData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AlarmTableTable(this._db, [this._alias]);
  final VerificationMeta _alarmTimeInMsMeta =
      const VerificationMeta('alarmTimeInMs');
  late final GeneratedColumn<int?> alarmTimeInMs = GeneratedColumn<int?>(
      'alarm_time_in_ms', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _alarmIdMeta = const VerificationMeta('alarmId');
  late final GeneratedColumn<int?> alarmId = GeneratedColumn<int?>(
      'alarm_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _timeToStopAlarmMeta =
      const VerificationMeta('timeToStopAlarm');
  late final GeneratedColumn<int?> timeToStopAlarm = GeneratedColumn<int?>(
      'time_to_stop_alarm', aliasedName, true,
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
  List<GeneratedColumn> get $columns =>
      [alarmTimeInMs, alarmId, timeToStopAlarm, isStop, isActive];
  @override
  String get aliasedName => _alias ?? 'alarm_table';
  @override
  String get actualTableName => 'alarm_table';
  @override
  VerificationContext validateIntegrity(Insertable<AlarmTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('alarm_time_in_ms')) {
      context.handle(
          _alarmTimeInMsMeta,
          alarmTimeInMs.isAcceptableOrUnknown(
              data['alarm_time_in_ms']!, _alarmTimeInMsMeta));
    } else if (isInserting) {
      context.missing(_alarmTimeInMsMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(_alarmIdMeta,
          alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta));
    }
    if (data.containsKey('time_to_stop_alarm')) {
      context.handle(
          _timeToStopAlarmMeta,
          timeToStopAlarm.isAcceptableOrUnknown(
              data['time_to_stop_alarm']!, _timeToStopAlarmMeta));
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
  Set<GeneratedColumn> get $primaryKey => {alarmId};
  @override
  AlarmTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AlarmTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AlarmTableTable createAlias(String alias) {
    return $AlarmTableTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AlarmTableTable alarmTable = $AlarmTableTable(this);
  late final AppDao appDao = AppDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [alarmTable];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$AppDaoMixin on DatabaseAccessor<AppDatabase> {
  $AlarmTableTable get alarmTable => attachedDatabase.alarmTable;
}
