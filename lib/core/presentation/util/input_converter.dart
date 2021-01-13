import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/ifailures.dart';

class InputConverter {
  Either<IFailure, int> stringToUnsignedInteger(String string) {
    try {
      final integer = int.parse(string);
      if (integer < 0) throw FormatException();
      return Right(int.parse(string));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
