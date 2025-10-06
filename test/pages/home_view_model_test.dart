import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shorten_links/domain/exceptions/parse_exception.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/network/http_exception.dart';
import 'package:shorten_links/pages/home_view_model.dart';
import 'package:shorten_links/repositories/link_repository.dart';
import 'package:shorten_links/utils/result.dart';

@GenerateMocks([LinkRepository])
import 'home_view_model_test.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockLinkRepository mockRepository;
    late HomeViewModel viewModel;

    setUpAll(() {
      // Provide dummy value for Result<Link>
      provideDummy<Result<Link>>(
        Result.ok(
          Link(
            alias: 'dummy',
            url: 'https://dummy.com',
            shortUrl: 'https://short.ly/dummy',
          ),
        ),
      );
    });

    setUp(() {
      mockRepository = MockLinkRepository();
      viewModel = HomeViewModel(mockRepository);
    });

    test('should initialize with empty state', () {
      // Assert
      expect(viewModel.state.value.links, isEmpty);
      expect(viewModel.state.value.isShortening, isFalse);
      expect(viewModel.state.value.error, isNull);
      expect(viewModel.links, isEmpty);
    });

    test('should show loading state when shortening URL', () async {
      // Arrange
      final testUrl = 'https://example.com';
      final testLink = Link(
        alias: 'abc123',
        url: testUrl,
        shortUrl: 'https://short.ly/abc123',
      );

      when(
        mockRepository.shortenUrl(testUrl),
      ).thenAnswer((_) async => Result.ok(testLink));

      // Act
      viewModel.shortenUrl(testUrl);

      // Assert - should be in loading state immediately
      expect(viewModel.state.value.isShortening, isTrue);
      expect(viewModel.state.value.error, isNull);
    });

    test('should successfully shorten URL and add to links', () async {
      // Arrange
      final testUrl = 'https://example.com';
      final testLink = Link(
        alias: 'abc123',
        url: testUrl,
        shortUrl: 'https://short.ly/abc123',
      );

      when(
        mockRepository.shortenUrl(testUrl),
      ).thenAnswer((_) async => Result.ok(testLink));

      // Act
      await viewModel.shortenUrl(testUrl);

      // Assert
      expect(viewModel.state.value.isShortening, isFalse);
      expect(viewModel.state.value.error, isNull);
      expect(viewModel.links, hasLength(1));
      expect(viewModel.links.first.alias, equals(testLink.alias));
      expect(viewModel.links.first.url, equals(testUrl));
      expect(viewModel.links.first.shortUrl, equals(testLink.shortUrl));
      verify(mockRepository.shortenUrl(testUrl)).called(1);
    });

    test('should handle network error', () async {
      // Arrange
      final testUrl = 'https://example.com';
      final networkError = HttpException(
        statusCode: 500,
        responseBody: 'Internal Server Error',
        message: 'Network timeout',
      );

      when(
        mockRepository.shortenUrl(testUrl),
      ).thenAnswer((_) async => Result.error(networkError));

      // Act
      await viewModel.shortenUrl(testUrl);

      // Assert
      expect(viewModel.state.value.isShortening, isFalse);
      expect(
        viewModel.state.value.error,
        equals('Network error: Network timeout.'),
      );
      expect(viewModel.links, isEmpty);
      verify(mockRepository.shortenUrl(testUrl)).called(1);
    });

    test('should handle parse error', () async {
      // Arrange
      final testUrl = 'https://example.com';
      final parseError = ParseException(message: 'Invalid JSON');

      when(
        mockRepository.shortenUrl(testUrl),
      ).thenAnswer((_) async => Result.error(parseError));

      // Act
      await viewModel.shortenUrl(testUrl);

      // Assert
      expect(viewModel.state.value.isShortening, isFalse);
      expect(
        viewModel.state.value.error,
        equals('Invalid response from server.'),
      );
      expect(viewModel.links, isEmpty);
      verify(mockRepository.shortenUrl(testUrl)).called(1);
    });

    test('should handle unexpected error', () async {
      // Arrange
      final testUrl = 'https://example.com';
      final unexpectedError = Exception('Something went wrong');

      when(
        mockRepository.shortenUrl(testUrl),
      ).thenAnswer((_) async => Result.error(unexpectedError));

      // Act
      await viewModel.shortenUrl(testUrl);

      // Assert
      expect(viewModel.state.value.isShortening, isFalse);
      expect(
        viewModel.state.value.error,
        equals('An unexpected error occurred.'),
      );
      expect(viewModel.links, isEmpty);
      verify(mockRepository.shortenUrl(testUrl)).called(1);
    });

    test('should add multiple links and maintain order', () async {
      // Arrange
      final firstUrl = 'https://example.com';
      final secondUrl = 'https://google.com';
      final firstLink = Link(
        alias: 'abc123',
        url: firstUrl,
        shortUrl: 'https://short.ly/abc123',
      );
      final secondLink = Link(
        alias: 'def456',
        url: secondUrl,
        shortUrl: 'https://short.ly/def456',
      );

      when(
        mockRepository.shortenUrl(firstUrl),
      ).thenAnswer((_) async => Result.ok(firstLink));
      when(
        mockRepository.shortenUrl(secondUrl),
      ).thenAnswer((_) async => Result.ok(secondLink));

      // Act
      await viewModel.shortenUrl(firstUrl);
      await viewModel.shortenUrl(secondUrl);

      // Assert
      expect(viewModel.links, hasLength(2));
      expect(viewModel.links[0].alias, equals(secondLink.alias));
      expect(viewModel.links[1].alias, equals(firstLink.alias));
      verify(mockRepository.shortenUrl(firstUrl)).called(1);
      verify(mockRepository.shortenUrl(secondUrl)).called(1);
    });

    test(
      'should clear error when successfully shortening after error',
      () async {
        // Arrange
        final testUrl = 'https://example.com';
        final networkError = HttpException(
          statusCode: 500,
          responseBody: 'Internal Server Error',
          message: 'Network timeout',
        );
        final testLink = Link(
          alias: 'abc123',
          url: testUrl,
          shortUrl: 'https://short.ly/abc123',
        );

        when(
          mockRepository.shortenUrl(testUrl),
        ).thenAnswer((_) async => Result.error(networkError));

        // Act - first call fails
        await viewModel.shortenUrl(testUrl);
        expect(viewModel.state.value.error, isNotNull);

        // Arrange - second call succeeds
        when(
          mockRepository.shortenUrl(testUrl),
        ).thenAnswer((_) async => Result.ok(testLink));

        // Act - second call succeeds
        await viewModel.shortenUrl(testUrl);

        // Assert
        expect(viewModel.state.value.isShortening, isFalse);
        expect(viewModel.state.value.error, isNull);
        expect(viewModel.links, hasLength(1));
        expect(viewModel.links.first.alias, equals(testLink.alias));
      },
    );
  });
}
