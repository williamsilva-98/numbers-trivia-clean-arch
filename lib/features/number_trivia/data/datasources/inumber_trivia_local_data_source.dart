import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSource implements INumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSource(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(numberTriviaModel.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final String jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      // Future which is immediately completed
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
