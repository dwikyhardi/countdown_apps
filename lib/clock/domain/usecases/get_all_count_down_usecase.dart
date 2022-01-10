import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCountDownUseCase extends UseCase<List<CountDown>, NoParams> {
  final ClockRepository repository;

  GetAllCountDownUseCase(this.repository);

  @override
  Future<Either<Failure, List<CountDown>>> call(NoParams params) async {
    return await repository.getAllCountDown();
  }
}
