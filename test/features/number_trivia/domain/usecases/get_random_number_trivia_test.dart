import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/inumber_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockINumberTriviaEntityRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  GetRandomNumberTriviaEntity usecase;
  MockINumberTriviaEntityRepository repository;

  setUp(() {
    repository = MockINumberTriviaEntityRepository();
    usecase = GetRandomNumberTriviaEntity(repository: repository);
  });

  final tNumberTriviaEntity = NumberTriviaEntity(number: 1, text: 'test');

  test('should get trivia from repository', () async {
    // Arrange
    when(repository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(tNumberTriviaEntity));

    // Act
    final response = await usecase();

    // Assert
    expect(response, Right(tNumberTriviaEntity));
    verify(repository.getRandomNumberTrivia());
  });
}
