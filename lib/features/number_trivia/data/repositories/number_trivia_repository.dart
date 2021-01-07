import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/network/inetwork_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/inumber_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/inumber_trivia_repository.dart';

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDataSource remoteDataSource;
  final INumberTriviaLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  NumberTriviaRepository({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<IFailure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);

        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<IFailure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final randomTrivia = await remoteDataSource.getRandomNumberTrivia();

        localDataSource.cacheNumberTrivia(randomTrivia);

        return Right(randomTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
