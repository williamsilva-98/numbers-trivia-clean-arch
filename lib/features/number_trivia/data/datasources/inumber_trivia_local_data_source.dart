import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class INumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}
