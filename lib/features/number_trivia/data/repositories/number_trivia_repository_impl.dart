import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return  remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() getConcretOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcretOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CachException {
        return Left(CacheFailure());
      }
    }
  }
}
