import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/ifailures.dart';
import 'package:number_trivia/core/presentation/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        final str = '123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return an InvalidInputFailure when the string is not an integer',
      () {
        // arrange
        final str = 'abc';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, isA<Left>());
      },
    );

    test(
      'should return a failure when the string is a negative integer',
      () async {
        // arrange
        final str = '-123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, isA<Left>());
      },
    );
  });
}
