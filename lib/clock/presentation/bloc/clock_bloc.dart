import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/clock/domain/usecases/add_alarm_usecase.dart'
    as addAlarm;
import 'package:countdown_apps/clock/domain/usecases/get_alarm_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/get_all_alarm_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/remove_alarm_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/set_active_alarm_usecase.dart'
    as paramIsActive;
import 'package:countdown_apps/clock/domain/usecases/stop_alarm_usecase.dart'
    as paramStop;
import 'package:countdown_apps/clock/domain/usecases/stream_alarm_usecase.dart';
import 'package:countdown_apps/clock/presentation/pages/chart_view.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'clock_event.dart';

part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  final addAlarm.AddAlarmUseCase addAlarmUseCase;
  final GatAlarmUseCase gatAlarmUseCase;
  final GetAllAlarmUseCase getAllAlarmUseCase;
  final RemoveAlarmUseCase removeAlarmUseCase;
  final paramStop.StopAlarmUseCase stopAlarmUseCase;
  final StreamAlarmUseCase streamAlarmUseCase;
  final paramIsActive.SetActiveAlarmUseCase setActiveAlarmUseCase;

  ClockBloc({
    required this.addAlarmUseCase,
    required this.gatAlarmUseCase,
    required this.removeAlarmUseCase,
    required this.stopAlarmUseCase,
    required this.streamAlarmUseCase,
    required this.setActiveAlarmUseCase,
    required this.getAllAlarmUseCase,
  }) : super(const ClockInitial()) {
    on<AddAlarmEvent>((event, emit) => onAddAlarmEvent(event, emit));
    on<RemoveAlarmEvent>((event, emit) => onRemoveAlarmEvent(event, emit));
    on<StopAlarmEvent>((event, emit) => onStopAlarmEvent(event, emit));
    on<GetAlarmEvent>((event, emit) => onGetAlarmEvent(event, emit));
    on<SetIsActiveAlarmEvent>(
        (event, emit) => onSetIsActiveAlarmEvent(event, emit));
    on<OpenChartEvent>(
        (event, emit) async => await onOpenChartEvent(event, emit));
  }

  Future<void> onOpenChartEvent(
      OpenChartEvent event, Emitter<ClockState> emitter) async {
    await getAllAlarmUseCase(NoParams()).then((eitherFailureOrListAlarm) {
      if (eitherFailureOrListAlarm.isRight()) {
        _openChartBottomSheet(
            event.context, eitherFailureOrListAlarm.getOrElse(() => []));
      }
    });
  }

  void onSetIsActiveAlarmEvent(
      SetIsActiveAlarmEvent event, Emitter<ClockState> emitter) {
    setActiveAlarmUseCase(
        paramIsActive.Params(alarmId: event.alarmId, isActive: event.isActive));
  }

  void onAddAlarmEvent(AddAlarmEvent event, Emitter<ClockState> emitter) {
    addAlarmUseCase(addAlarm.Params(alarmTimeInMs: event.alarmTimeInMs));
  }

  void onRemoveAlarmEvent(RemoveAlarmEvent event, Emitter<ClockState> emitter) {
    removeAlarmUseCase(Params(alarmId: event.alarmId));
  }

  void onStopAlarmEvent(StopAlarmEvent event, Emitter<ClockState> emitter) {
    stopAlarmUseCase(paramStop.Params(
        alarmId: event.alarmId, timeToStopAlarm: event.timeToStopAlarm));
  }

  void onGetAlarmEvent(GetAlarmEvent event, Emitter<ClockState> emitter) {
    gatAlarmUseCase(Params(alarmId: event.alarmId));
  }

  Stream<List<Alarm>> streamListAlarm() async* {
    StreamTransformer<Either<Failure, List<Alarm>>, List<Alarm>> transformer =
        StreamTransformer.fromHandlers(handleData:
            (Either<Failure, List<Alarm>> data, EventSink<List<Alarm>> output) {
      if (data.isRight()) {
        output.add(data.getOrElse(() => []));
      }
    });
    yield* streamAlarmUseCase(NoParams()).transform(transformer);
  }

  Future<void> _openChartBottomSheet(
      BuildContext context, List<Alarm> listAlarm) async {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (BuildContext context) {
          return ChartView(listAlarm: listAlarm.reversed.toList());
        });
  }
}
