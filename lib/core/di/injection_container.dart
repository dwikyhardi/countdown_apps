import 'package:countdown_apps/core/notification/notification.dart';
import 'package:countdown_apps/clock/data/datasource/clock_datasource.dart';
import 'package:countdown_apps/clock/data/repositories/clock_repository_impl.dart';
import 'package:countdown_apps/clock/data/table/count_down_table.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/clock/domain/usecases/start_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/get_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/get_all_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/remove_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/stop_count_down_usecase.dart';
import 'package:countdown_apps/clock/domain/usecases/stream_count_down_usecase.dart';
import 'package:countdown_apps/clock/presentation/bloc/clock_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///Feature CountDown
  //Bloc
  sl.registerFactory(() => ClockBloc(
        startCountDownUseCase: sl(),
        gatCountDownUseCase: sl(),
        removeCountDownUseCase: sl(),
        stopCountDownUseCase: sl(),
        streamCountDownUseCase: sl(),
        getAllCountDownUseCase: sl(),
        // streamRemainingTime: sl(),
      ));

  //UseCase
  sl.registerFactory(() => StreamCountDownUseCase(sl()));
  sl.registerLazySingleton(() => StartCountDownUseCase(sl()));
  sl.registerLazySingleton(() => GatCountDownUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCountDownUseCase(sl()));
  sl.registerLazySingleton(() => StopCountDownUseCase(sl()));
  sl.registerLazySingleton(() => GetAllCountDownUseCase(sl()));

  //Repository
  sl.registerLazySingleton<ClockRepository>(() => ClockRepositoryImpl(sl()));

  //Datasource
  sl.registerFactory<ClockDatasource>(() => ClockDataSourceImpl(sl(), sl()));

  ///Core
  //Database
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton(() => Notification());
}
