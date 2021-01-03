import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/inumber_trivia_repository.dart';

class GetRandomNumberTriviaEntity {
  final INumberTriviaRepository repository;

  GetRandomNumberTriviaEntity({@required this.repository});

  Future<Either<IFailure, NumberTriviaEntity>> call() async {
    return await repository.getRandomNumberTrivia();
  }
}
