import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/domain/exceptions/parse_exception.dart';
import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/network/http_exception.dart';
import 'package:shorten_links/repositories/link_repository.dart';

// Generate mocks with: flutter packages pub run build_runner build
@GenerateMocks([ApiClient])
import 'link_repository_test.mocks.dart';

void main() {
  group('LinkRepository', () {
    late MockApiClient mockApiClient;
    late LinkRepository linkRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      linkRepository = LinkRepository(mockApiClient);
    });

    group('shortenUrl', () {
      test('should return Link when API call succeeds', () async {
        // Arrange
        const url = 'https://example.com';
        final mockResponse = {
          'alias': 'abc123',
          '_links': {
            'self': 'https://api.example.com/alias/abc123',
            'short': 'https://short.ly/abc123',
          },
        };

        when(
          mockApiClient.post('/alias', {'url': url}),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await linkRepository.shortenUrl(url);

        // Assert
        expect(result, isA<Link>());
        expect(result.alias, equals('abc123'));
        expect(result.url, equals('https://api.example.com/alias/abc123'));
        expect(result.shortUrl, equals('https://short.ly/abc123'));
        verify(mockApiClient.post('/alias', {'url': url})).called(1);
      });

      test('should throw HttpException when API call fails', () async {
        // Arrange
        const url = 'https://example.com';
        final httpException = HttpException(
          statusCode: 400,
          responseBody: 'Bad Request',
          message: 'Invalid URL format',
        );

        when(
          mockApiClient.post('/alias', {'url': url}),
        ).thenThrow(httpException);

        // Act & Assert
        expect(
          () => linkRepository.shortenUrl(url),
          throwsA(isA<HttpException>()),
        );
        verify(mockApiClient.post('/alias', {'url': url})).called(1);
      });

      test(
        'should throw ParseException when API returns invalid JSON',
        () async {
          // Arrange
          const url = 'https://example.com';
          final invalidJsonResponse = {
            'alias': 'abc123',
            // Missing 'links' field - should cause ParseException
          };

          when(
            mockApiClient.post('/alias', {'url': url}),
          ).thenAnswer((_) async => invalidJsonResponse);

          // Act & Assert
          expect(
            () => linkRepository.shortenUrl(url),
            throwsA(isA<ParseException>()),
          );
          verify(mockApiClient.post('/alias', {'url': url})).called(1);
        },
      );
    });

    group('getOriginalUrl', () {
      test('should return original URL when API call succeeds', () async {
        // Arrange
        const alias = 'abc123';
        final mockResponse = {'url': 'https://example.com'};

        when(
          mockApiClient.get('/alias/$alias'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await linkRepository.getOriginalUrl(alias);

        // Assert
        expect(result, equals('https://example.com'));
        verify(mockApiClient.get('/alias/$alias')).called(1);
      });

      test('should throw HttpException when API call fails', () async {
        // Arrange
        const alias = 'invalid';
        final httpException = HttpException(
          statusCode: 404,
          responseBody: 'Not Found',
          message: 'Alias not found',
        );

        when(mockApiClient.get('/alias/$alias')).thenThrow(httpException);

        // Act & Assert
        expect(
          () => linkRepository.getOriginalUrl(alias),
          throwsA(isA<HttpException>()),
        );
        verify(mockApiClient.get('/alias/$alias')).called(1);
      });

      test(
        'should throw ParseException when API returns invalid JSON',
        () async {
          // Arrange
          const alias = 'abc123';
          final invalidJsonResponse = {
            // Missing 'url' field - should cause ParseException
            'status': 'success',
          };

          when(
            mockApiClient.get('/alias/$alias'),
          ).thenAnswer((_) async => invalidJsonResponse);

          // Act & Assert
          expect(
            () => linkRepository.getOriginalUrl(alias),
            throwsA(isA<ParseException>()),
          );
          verify(mockApiClient.get('/alias/$alias')).called(1);
        },
      );
    });
  });
}
