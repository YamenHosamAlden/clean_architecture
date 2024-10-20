import 'dart:async';

import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  sl.registerLazySingleton<Dio>(
    () => Dio()
      ..interceptors.add(PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          request: true,
          compact: true,
          maxWidth: 1000)),
  );

  sl.registerLazySingleton(
    () => InternetConnection(),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnection>()),
  );
  initBloc();
  initDatasources();
  initRepositories();
  initUseCase();
}

void initBloc() {
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: sl<GetRandomNumberTrivia>(),
      inputConverter: sl<InputConverter>()));
}

void initUseCase() {
  sl.registerLazySingleton(
      () => GetConcreteNumberTrivia(sl<NumberTriviaRepository>()));
  sl.registerLazySingleton(
      () => GetRandomNumberTrivia(sl<NumberTriviaRepository>()));
  sl.registerLazySingleton(() => InputConverter());
}

void initRepositories() {
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl<NumberTriviaLocalDataSource>(),
          networkInfo: sl<NetworkInfo>(),
          remoteDataSource: sl<NumberTriviaRemoteDataSource>()));
}

void initDatasources() {
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(dio: sl<Dio>()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImpl(
          sharedPreferences: sl<SharedPreferences>()));
}
