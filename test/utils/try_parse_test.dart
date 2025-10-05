import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_links/domain/exceptions/parse_exception.dart';
import 'package:shorten_links/utils/try_parse.dart';

void main() {
  group('tryParse', () {
    group('successful parsing', () {
      test('should return result when fromJson succeeds', () {
        // Arrange
        final json = {'name': 'test', 'value': 123};
        String fromJson(Map<String, dynamic> json) => json['name'] as String;

        // Act
        final result = tryParse<String>(fromJson, json);

        // Assert
        expect(result, equals('test'));
      });

      test('should work with different generic types', () {
        // Arrange
        final json = {'number': 42, 'text': 'hello'};

        int intFromJson(Map<String, dynamic> json) => json['number'] as int;
        String stringFromJson(Map<String, dynamic> json) =>
            json['text'] as String;

        // Act
        final intResult = tryParse<int>(intFromJson, json);
        final stringResult = tryParse<String>(stringFromJson, json);

        // Assert
        expect(intResult, equals(42));
        expect(stringResult, equals('hello'));
      });

      test('should work with custom class types', () {
        // Arrange
        final json = {'id': 1, 'title': 'Test Item'};

        TestItem itemFromJson(Map<String, dynamic> json) =>
            TestItem(id: json['id'] as int, title: json['title'] as String);

        // Act
        final result = tryParse<TestItem>(itemFromJson, json);

        // Assert
        expect(result.id, equals(1));
        expect(result.title, equals('Test Item'));
      });
    });

    group('exception handling', () {
      test('should throw ParseException when fromJson fails', () {
        // Arrange
        final json = {'invalid': 'data'};
        String fromJson(Map<String, dynamic> json) => json['missing'] as String;

        // Act & Assert
        expect(
          () => tryParse<String>(fromJson, json),
          throwsA(isA<ParseException>()),
        );
      });

      test('should preserve original JSON in exception', () {
        // Arrange
        final json = {'test': 'data', 'number': 123};
        String fromJson(Map<String, dynamic> json) =>
            throw Exception('Test error');

        // Act & Assert
        try {
          tryParse<String>(fromJson, json);
          fail('Expected ParseException to be thrown');
        } catch (e) {
          expect(e, isA<ParseException>());
          final parseException = e as ParseException;
          expect(parseException.rawJson, equals(json));
        }
      });

      test('should preserve original error in exception', () {
        // Arrange
        final json = {'test': 'data'};
        final originalError = 'Custom parsing error';
        String fromJson(Map<String, dynamic> json) =>
            throw Exception(originalError);

        // Act & Assert
        try {
          tryParse<String>(fromJson, json);
          fail('Expected ParseException to be thrown');
        } catch (e) {
          expect(e, isA<ParseException>());
          final parseException = e as ParseException;
          expect(parseException.originalError, contains(originalError));
        }
      });
    });
  });
}

// Helper class for testing custom types
class TestItem {
  final int id;
  final String title;

  TestItem({required this.id, required this.title});
}
