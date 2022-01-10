import 'dart:async';
import 'dart:io';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/core/error/exception.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'count_down_table.g.dart';

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

class CountDownTable extends Table {
  IntColumn get countDownTimeInMs => integer()();

  IntColumn get remainingCountDownTimeInMs => integer()();

  IntColumn get countDownId => integer().autoIncrement().nullable()();

  IntColumn get timeToStopCountDown =>
      integer().withDefault(const Constant(0)).nullable()();

  BoolColumn get isStop =>
      boolean().withDefault(const Constant(false)).nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).nullable()();
}

@DriftDatabase(
  tables: [CountDownTable],
  daos: [AppDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(
  tables: [CountDownTable],
)
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  final AppDatabase db;

  AppDao(this.db) : super(db);

  Timer? _timer;

  Future<int> saveCountDown(CountDownModels countDownData,
      StreamController<CountDownModels?> streamController) async {
    try {
      if (countDownData.countDownId == null) {
        Insertable<CountDownTableData> data = CountDownTableData(
            remainingCountDownTimeInMs:
                countDownData.remainingCountDownTimeInMs,
            countDownTimeInMs: countDownData.countDownTimeInMs,
            isStop: countDownData.isStop,
            timeToStopCountDown: countDownData.timeToStopCountDown,
            isActive: countDownData.isActive);
        var result = await into(countDownTable).insert(data);
        var seconds = countDownData.remainingCountDownTimeInMs;
        const period = Duration(seconds: 1);
        _timer = Timer.periodic(period, (timer) {
          seconds = seconds - period.inMilliseconds;
          debugPrint('Seconds Dong $seconds');
          if (seconds == 0) {
            debugPrint('Seconds Dong nol $seconds');
            _timer?.cancel();
            updateRemainingTime(result, 0, streamController, seconds > 0);
          } else {
            debugPrint('Seconds Dong Tidak Nol $seconds');
            updateRemainingTime(result, seconds, streamController, seconds > 0);
          }
        });
        return result;
      } else {
        var seconds = countDownData.remainingCountDownTimeInMs;
        const period = Duration(seconds: 1);
        _timer = Timer.periodic(period, (timer) {
          seconds = seconds - period.inMilliseconds;
          if (seconds == 0) {
            _timer?.cancel();
            updateRemainingTime(countDownData.countDownId ?? 0, 0,
                streamController, seconds > 0);
          } else {
            updateRemainingTime(countDownData.countDownId ?? 0, seconds,
                streamController, seconds > 0);
          }
        });
        return Future.value(countDownData.countDownId);
      }
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<CountDownModels> getCountDown(int countDownId) async {
    try {
      var result = await (select(countDownTable)
            ..where((tbl) => tbl.countDownId.equals(countDownId)))
          .getSingle();
      return CountDownModels.fromJson(result.toJson());
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<void> deleteCountDown(int countDownId) async {
    try {
      (delete(countDownTable)
            ..where((tbl) => tbl.countDownId.equals(countDownId)))
          .go();
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<bool> stopCountDown(
    int countDownId,
    int timeToStopCountDown,
    int remainingTime,
    StreamController<CountDownModels?>? streamController,
  ) async {
    try {
      var result = true;
      var newEntity = await getCountDown(countDownId);
      if (newEntity.isStop) {
        await deleteCountDown(countDownId);
        if (streamController != null) {
          streamController.add(null);
        }
      } else {
        result = await update(countDownTable).replace(
          CountDownTableData(
            countDownTimeInMs: newEntity.countDownTimeInMs,
            remainingCountDownTimeInMs: remainingTime,
            countDownId: countDownId,
            timeToStopCountDown: timeToStopCountDown,
            isActive: false,
            isStop: true,
          ),
        );
        if (streamController != null) {
          streamController.add(await getCountDown(countDownId));
        }

        _timer?.cancel();
      }
      return result;
    } on Exception {
      throw DatabaseException();
    }
  }

  Future<void> updateRemainingTime(int countDownId, int remainingTime,
      StreamController<CountDownModels?> streamController, bool isActive) async {
    try {
      var newEntity = await getCountDown(countDownId);
      await update(countDownTable).replace(CountDownTableData(
        countDownTimeInMs: newEntity.countDownTimeInMs,
        remainingCountDownTimeInMs: remainingTime,
        countDownId: countDownId,
        timeToStopCountDown: newEntity.timeToStopCountDown,
        isActive: isActive,
        isStop: false,
      ));
      if(remainingTime == 0){
        streamController.add(null);
      }else{
        streamController.add(await getCountDown(countDownId));
      }
    } on Exception {
      throw DatabaseException();
    }
  }

  Stream<List<CountDownModels>> streamCountDowns() async* {
    StreamTransformer<List<CountDownTableData>, List<CountDownModels>>
        transformer = StreamTransformer.fromHandlers(handleData:
            (List<CountDownTableData> event,
                EventSink<List<CountDownModels>> output) {
      List<CountDownModels> data = [];
      for (var element in event) {
        data.add(CountDownModels.fromJson(element.toJson()));
      }
      output.add(data);
    });

    yield* (select(countDownTable)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.countDownTimeInMs, mode: OrderingMode.desc),
          ]))
        .watch()
        .transform(transformer);
  }

  Future<List<CountDownModels>> getAllCountDown() async {
    return await (select(countDownTable)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.countDownTimeInMs, mode: OrderingMode.desc),
          ]))
        .get()
        .then((value) {
      List<CountDownModels> data = [];
      for (var element in value) {
        data.add(CountDownModels(
          remainingCountDownTimeInMs: element.remainingCountDownTimeInMs,
          countDownTimeInMs: element.countDownTimeInMs,
          timeToStopCountDown: element.timeToStopCountDown ?? 0,
          isActive: element.isActive ?? true,
          isStop: element.isStop ?? false,
          countDownId: element.countDownId,
        ));
      }
      return data;
    });
  }
}
