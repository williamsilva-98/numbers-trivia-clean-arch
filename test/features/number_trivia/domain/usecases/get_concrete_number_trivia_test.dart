import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/inumber_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockINumberTriviaEntityRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockINumberTriviaEntityRepository mockRepository;

  setUp(() {
    mockRepository = MockINumberTriviaEntityRepository();
    usecase = GetConcreteNumberTrivia(repository: mockRepository);
  });

  final tNumber = 1;
  final tNumberTriviaEntity = NumberTriviaEntity(text: 'test', number: tNumber);

  test(
    'should get trivia for the number from the repository',
    () async {
      // Arrange
      when(mockRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTriviaEntity));

      // Act
      final result = await usecase(number: tNumber);

      // Assert
      expect(result, Right(tNumberTriviaEntity));
      verify(mockRepository.getConcreteNumberTrivia(tNumber));
    },
  );
}
