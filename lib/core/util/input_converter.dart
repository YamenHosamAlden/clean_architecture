import 'package:clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringTounsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const  FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
