import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:app/features/connectivity/presentation/cubits/connectivity_cubit.dart';
import 'package:app/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:app/features/vitals/data/datasources/vitals_local_data_source_impl.dart';
import 'package:app/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:app/features/vitals/data/datasources/vitals_remote_data_source_impl.dart';
import 'package:app/features/vitals/data/repositories/vitals_repository_impl.dart';
import 'package:app/features/vitals/domain/repositories/vitals_repository.dart';
import 'package:app/features/vitals/domain/usecases/get_analytics.dart';
import 'package:app/features/vitals/domain/usecases/get_current_vitals.dart';
import 'package:app/features/vitals/domain/usecases/get_history.dart';
import 'package:app/features/vitals/domain/usecases/log_vitals.dart';
import 'package:app/features/vitals/presentation/cubits/dashboard_cubit.dart';
import 'package:app/features/vitals/presentation/cubits/history_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Vitals
  
  // Cubits
  sl.registerFactory(() => ConnectivityCubit(sl()));
  sl.registerFactory(() => DashboardCubit(
    getCurrentVitals: sl(),
    logVitals: sl(),
    connectivityCubit: sl(),
  ));
  sl.registerFactory(() => HistoryCubit(
    getHistory: sl(),
    getAnalytics: sl(),
    connectivityCubit: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentVitals(sl()));
  sl.registerLazySingleton(() => LogVitals(sl()));
  sl.registerLazySingleton(() => GetHistory(sl()));
  sl.registerLazySingleton(() => GetAnalytics(sl()));

  // Repository
  sl.registerLazySingleton<VitalsRepository>(() => VitalsRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<VitalsRemoteDataSource>(() => VitalsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<VitalsLocalDataSource>(() => VitalsLocalDataSourceImpl());

  // External
  sl.registerLazySingleton(() => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  )));
}
