import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/network/inetwork_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

class MockRemoteDataSource extends Mock
    implements INumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements INumberTriviaLocalDataSource {
}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
  final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

  group('concrete numbers', () {
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        //act
        repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTriviaEntity)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaEntity));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, isA<Left>());
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTriviaEntity)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, isA<Left>());
        },
      );
    });
  });

  group('random numbers', () {
    test(
      'should check if isConnected was called',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        //act
        await repository.getRandomNumberTrivia();

        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group(
      'device is online',
      () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            //arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            //act
            final result = await repository.getRandomNumberTrivia();

            //assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTriviaEntity)));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            //arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            //act
            await repository.getRandomNumberTrivia();

            //assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            //arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            //act
            final result = await repository.getRandomNumberTrivia();

            //assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, isA<Left>());
          },
        );
      },
    );

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTriviaEntity)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, isA<Left>());
        },
      );
    });
  });
}
