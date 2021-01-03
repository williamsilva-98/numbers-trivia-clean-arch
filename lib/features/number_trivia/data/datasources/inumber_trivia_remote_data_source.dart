import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class INumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
