import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);

  test('should be a subclass of NumberTriviaEntity', () {
    //assert
    expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
  });

  test(
    'should return a valid model when the JSON number is an interger',
    () {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, isA<NumberTriviaModel>());
    },
  );

  test(
    'should return a valid model when the JSON number is a double',
    () {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, isA<NumberTriviaModel>());
    },
  );

  test(
    'should return a JSON map containing the proper data',
    () {
      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      final expectedJsonMap = {
        "text": "test",
        "number": 1,
      };
      expect(result, expectedJsonMap);
    },
  );
}
