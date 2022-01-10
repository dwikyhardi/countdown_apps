import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/usecases/get_all_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/get_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/remove_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/start_count_down_usecase.dart'
    as startCountDown;
import 'package:countdown_apps/clock/domain/usecases/stop_count_down_usecase.dart'
    as paramStop;
import 'package:countdown_apps/clock/domain/usecases/stream_count_down_usecase.dart';
import 'package:countdown_apps/clock/presentation/pages/chart_view.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

part 'clock_event.dart';

part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  final startCountDown.StartCountDownUseCase startCountDownUseCase;
  final GatCountDownUseCase gatCountDownUseCase;
  final GetAllCountDownUseCase getAllCountDownUseCase;
  final RemoveCountDownUseCase removeCountDownUseCase;
  final paramStop.StopCountDownUseCase stopCountDownUseCase;
  final StreamCountDownUseCase streamCountDownUseCase;

  ClockBloc({
    required this.startCountDownUseCase,
    required this.gatCountDownUseCase,
    required this.removeCountDownUseCase,
    required this.stopCountDownUseCase,
    required this.streamCountDownUseCase,
    required this.getAllCountDownUseCase,
  }) : super(const ClockInitial()) {
    on<StartCountDownEvent>(
        (event, emit) => onStartCountDownEvent(event, emit));
    on<RemoveCountDownEvent>(
        (event, emit) => onRemoveCountDownEvent(event, emit));
    on<StopCountDownEvent>((event, emit) => onStopCountDownEvent(event, emit));
    on<GetCountDownEvent>((event, emit) => onGetCountDownEvent(event, emit));
    on<OpenChartEvent>(
        (event, emit) async => await onOpenChartEvent(event, emit));
  }

  Future<void> onOpenChartEvent(
      OpenChartEvent event, Emitter<ClockState> emitter) async {
    debugPrint('Kadieu emitter.runtimeType ===== ${emitter.runtimeType}');
    debugPrint('Kadieu emitter.isDone ===== ${emitter.isDone}');
    // if (emitter.isDone) {
    //   debugPrint('Kadieu');
      emitter(const ClockUpdate(countDownModels: CountDownModels(
        countDownTimeInMs: 0,
        remainingCountDownTimeInMs: 0,
        timeToStopCountDown: 0,
        isStop: false,
        isActive: false,
      )));
    // }
    await getAllCountDownUseCase(NoParams())
        .then((eitherFailureOrListCountDown) async {
      await eitherFailureOrListCountDown.fold(
        (l) => null,
        (r) async => await _openChartBottomSheet(
          event.context,
          r,
          emitter,
        ),
      );
    });
  }

  Future<List<CountDown>> getAllCountDownEvent() async {
    return await getAllCountDownUseCase(NoParams()).then((failureOrCountDown) {
      List<CountDown> countDownData = [];
      failureOrCountDown.fold((l) => null, (r) => countDownData.addAll(r));
      return countDownData;
    });
  }

  Future<void> onStartCountDownEvent(
      StartCountDownEvent event, Emitter<ClockState> emitter) async {
    await startCountDownUseCase(startCountDown.Params(
      countDownId: event.countDownId,
      countDownTimeInMs: event.countDownTimeInMs,
      remainingCountDownTimeInMs: event.remainingCountDownTimeInMs,
      streamController: event.streamController,
    )).whenComplete(() {
      if (emitter.isDone) {
        emitter(const ClockInitial());
      }
    });
  }

  Future<void> onRemoveCountDownEvent(
      RemoveCountDownEvent event, Emitter<ClockState> emitter) async {
    await removeCountDownUseCase(Params(countDownId: event.countDownId))
        .whenComplete(() {
      if (emitter.isDone) {
        emitter(const ClockInitial());
      }
    });
  }

  Future<void> onStopCountDownEvent(
      StopCountDownEvent event, Emitter<ClockState> emitter) async {
    await stopCountDownUseCase(paramStop.Params(
      streamController: event.streamController,
      countDownId: event.countDownId,
      timeToStopCountDown: event.timeToStopCountDown,
      remainingCountDownTimeInMs: event.remainingCountDownTimeInMs,
    )).then((_) async {
      if (event.remainingCountDownTimeInMs == 0 &&
          event.streamController == null) {
        add(OpenChartEvent(navGK.currentState!.context));
      }
    });
  }

  Future<void> onGetCountDownEvent(
      GetCountDownEvent event, Emitter<ClockState> emitter) async {
    if (emitter.isDone) {
      emitter(const ClockInitial());
    }
    await gatCountDownUseCase(Params(countDownId: event.countDownId));
  }

  Stream<List<CountDown>> streamListCountDown() async* {
    StreamTransformer<Either<Failure, List<CountDown>>, List<CountDown>>
        transformer = StreamTransformer.fromHandlers(handleData:
            (Either<Failure, List<CountDown>> data,
                EventSink<List<CountDown>> output) {
      if (data.isRight()) {
        output.add(data.getOrElse(() => []));
      }
    });
    yield* streamCountDownUseCase(NoParams()).transform(transformer);
  }

  Future<void> _openChartBottomSheet(BuildContext context,
      List<CountDown> listCountDown, Emitter<ClockState> emitter) async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context) {
          return ChartView(listCountDown: listCountDown.reversed.toList());
        });
  }
}
