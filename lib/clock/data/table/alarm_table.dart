import 'dart:async';
import 'dart:io';

import 'package:countdown_apps/core/error/exception.dart';
import 'package:countdown_apps/clock/data/model/alarm_model.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'alarm_table.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}

class AlarmTable extends Table {
  IntColumn get alarmTimeInMs => integer()();

  IntColumn get alarmId => integer().autoIncrement().nullable()();

  IntColumn get timeToStopAlarm =>
      integer().withDefault(const Constant(0)).nullable()();

  BoolColumn get isStop =>
      boolean().withDefault(const Constant(false)).nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).nullable()();
}

@DriftDatabase(
  tables: [AlarmTable],
  daos: [AppDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(
  tables: [AlarmTable],
)
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  final AppDatabase db;

  AppDao(this.db) : super(db);

  Future<int> saveAlarm(AlarmModels alarmData) async {
    try {
      Insertable<AlarmTableData> data = AlarmTableData(
          alarmTimeInMs: alarmData.alarmTimeInMs,
          isStop: alarmData.isStop,
          timeToStopAlarm: alarmData.timeToStopAlarm,
          isActive: alarmData.isActive);
      return await into(alarmTable).insert(data);
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<AlarmModels> getAlarm(int alarmId) async {
    try {
      var result = await (select(alarmTable)
            ..where((tbl) => tbl.alarmId.equals(alarmId)))
          .getSingle();
      return AlarmModels.fromJson(result.toJson());
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<void> deleteAlarm(int alarmId) async {
    try {
      (delete(alarmTable)..where((tbl) => tbl.alarmId.equals(alarmId))).go();
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<bool> stopAlarm(int alarmId, int timeToStopAlarm) async {
    try {
      var newEntity = await getAlarm(alarmId);
      return await update(alarmTable).replace(AlarmTableData(
          alarmTimeInMs: newEntity.alarmTimeInMs,
          alarmId: alarmId,
          timeToStopAlarm: timeToStopAlarm,
          isActive: false,
          isStop: true));
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<bool> setIsActiveAlarm(
      int alarmId, bool isActive, int? newAlarmTimeInMs) async {
    try {
      var newEntity = await getAlarm(alarmId);
      return await update(alarmTable).replace(AlarmTableData(
          alarmTimeInMs: newAlarmTimeInMs ?? newEntity.alarmTimeInMs,
          alarmId: alarmId,
          timeToStopAlarm:
              newAlarmTimeInMs != null ? 0 : newEntity.timeToStopAlarm,
          isActive: isActive,
          isStop: !isActive));
    } on Exception {
      throw DatabaseException();
    }
  }

  Stream<List<AlarmModels>> streamAlarms() async* {
    StreamTransformer<List<AlarmTableData>, List<AlarmModels>> transformer =
        StreamTransformer.fromHandlers(handleData:
            (List<AlarmTableData> event, EventSink<List<AlarmModels>> output) {
      List<AlarmModels> data = [];
      for (var element in event) {
        data.add(AlarmModels.fromJson(element.toJson()));
      }
      output.add(data);
    });

    yield* (select(alarmTable)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.alarmTimeInMs, mode: OrderingMode.desc),
          ]))
        .watch()
        .transform(transformer);
  }

  Future<List<AlarmModels>> getAllAlarm() async {
    return await (select(alarmTable)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.alarmTimeInMs, mode: OrderingMode.desc),
          ]))
        .get()
        .then((value) {
      List<AlarmModels> data = [];
      for (var element in value) {
        data.add(AlarmModels(
          alarmTimeInMs: element.alarmTimeInMs,
          timeToStopAlarm: element.timeToStopAlarm ?? 0,
          isActive: element.isActive ?? true,
          isStop: element.isStop ?? false,
          alarmId: element.alarmId,
        ));
      }
      return data;
    });
  }
}
