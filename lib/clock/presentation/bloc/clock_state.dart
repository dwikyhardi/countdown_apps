part of 'clock_bloc.dart';

abstract class ClockState extends Equatable {
  const ClockState();
}

class ClockInitial extends ClockState {

  const ClockInitial();

  @override
  List<Object> get props => [
      ];
}

class ClockUpdate extends ClockState {

  const ClockUpdate();

  @override
  List<Object> get props => [];
}
