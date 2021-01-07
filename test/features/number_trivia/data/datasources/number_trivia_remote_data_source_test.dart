import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class NumberTriviaRemoteDataSource implements INumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSource(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get('http://numbersapi.com/$number',
        headers: {'Content-Type': 'application/json'});
    return NumberTriviaModel.fromJson(json.decode(response.body));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}

void main() {
  NumberTriviaRemoteDataSource remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSource(mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));

        // act
        remoteDataSource.getConcreteNumberTrivia(tNumber);

        // assert
        verify(
          mockHttpClient.get('http://numbersapi.com/$tNumber',
              headers: {'Content-Type': 'application/json'}),
        );
      },
    );

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));

        // act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response('Something went wrong', 404));

        // act
        final call = remoteDataSource.getConcreteNumberTrivia;

        // assert
        //expect(() => call, throwsA())
      },
    );
  });
}
