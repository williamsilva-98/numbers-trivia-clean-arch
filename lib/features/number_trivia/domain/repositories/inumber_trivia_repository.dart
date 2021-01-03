import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class INumberTriviaRepository {
  Future<Either<IFailure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number);
  Future<Either<IFailure, NumberTriviaEntity>> getRandomNumberTrivia();
}
