import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/clock/domain/usecases/get_count_down_usecase.dart';
import 'package:dartz/dartz.dart';

class RemoveCountDownUseCase extends UseCase<bool, Params> {
  final ClockRepository repository;

  RemoveCountDownUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.removeCountDown(countDownId: params.countDownId);
  }
}
