
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dio/dio.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio dio;

  NumberTriviaRemoteDataSourceImpl({required this.dio});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getTriviaFromUrl("http://numbersapi.com/random/trivia");

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          "Content-Type": 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.formJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
