part of 'clock_bloc.dart';

abstract class ClockState extends Equatable {
  final StreamController<CountDownModels?>? streamController;

  const ClockState({required this.streamController});

  @override
  List<Object?> get props => [streamController];
}

class ClockInitial extends ClockState {
  const ClockInitial({StreamController<CountDownModels?>? streamController})
      : super(streamController: streamController);

  @override
  List<Object?> get props => [streamController];
}

class ClockUpdate extends ClockState {
  final CountDownModels countDownModels;

  const ClockUpdate(
      {required this.countDownModels,
      StreamController<CountDownModels?>? streamController})
      : super(
          streamController: streamController,
        );

  @override
  List<Object?> get props => [countDownModels, streamController];
}
