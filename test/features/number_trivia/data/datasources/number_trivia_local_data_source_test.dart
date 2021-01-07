import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource localDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSource(mockSharedPreferences);
  });

  group('last number trivia cached', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('trivia_cached.json'),
      ),
    );

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));

        // act
        final result = await localDataSource.getLastNumberTrivia();

        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () {
        // arrange
        when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
            .thenReturn(null);

        // act
        // Not calling the method here, just storing it inside a call variable
        final call = localDataSource.getLastNumberTrivia;

        // assert
        // Calling the method happens from a higher-order function passed.
        // This is needed to test if calling a method throws an exception.
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cache number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);

    test(
      'should call SharedPreferences to cache the data',
      () {
        // arrange
        final expectedJson = json.encode(tNumberTriviaModel.toJson());

        // act
        localDataSource.cacheNumberTrivia(tNumberTriviaModel);

        // assert
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJson));
      },
    );
  });
}
