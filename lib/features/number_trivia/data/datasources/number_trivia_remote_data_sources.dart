import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getTriviaFromUrl("http://numbersapi.com/random/trivia");

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      headers: {
        "Content-Type": 'application/json',
      },
      Uri.parse(
        url,
      ),
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.formJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
