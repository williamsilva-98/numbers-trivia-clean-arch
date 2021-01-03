import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/inumber_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final INumberTriviaRepository repository;

  GetConcreteNumberTrivia({@required this.repository});

  Future<Either<IFailure, NumberTriviaEntity>> call({
    @required int number,
  }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
