import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/network/http_exception.dart';

@GenerateMocks([http.Client])
import 'api_client_test.mocks.dart';

void main() {
  group('ApiClient', () {
    late MockClient mockClient;
    late ApiClient apiClient;
    const String baseUrl = 'https://api.example.com';
    const String endpoint = '/test';

    setUp(() {
      mockClient = MockClient();
      ApiClient.init(baseUrl: baseUrl, client: mockClient);
      apiClient = ApiClient();
    });

    tearDown(() {
      apiClient.dispose();
    });

    group('Initialization', () {
      test('should return singleton instance when initialized', () {
        final instance1 = ApiClient();
        final instance2 = ApiClient();
        expect(identical(instance1, instance2), isTrue);
      });

      test('should throw exception when not initialized', () {
        apiClient.dispose();
        expect(() => ApiClient(), throwsException);
      });

      test('should maintain singleton behavior across multiple calls', () {
        // Arrange
        final instances = <ApiClient>[];

        // Act - Create multiple instances
        for (int i = 0; i < 5; i++) {
          instances.add(ApiClient());
        }

        // Assert - All should be the same instance
        for (int i = 1; i < instances.length; i++) {
          expect(identical(instances[0], instances[i]), isTrue);
        }
      });

      test('should dispose client when dispose is called', () {
        // Arrange
        final testMockClient = MockClient();
        ApiClient.init(baseUrl: baseUrl, client: testMockClient);
        final testApiClient = ApiClient();

        // Act
        testApiClient.dispose();

        // Assert
        verify(testMockClient.close()).called(1);
      });
    });

    group('GET requests', () {
      test('should make successful GET request', () async {
        // Arrange
        final mockResponse = http.Response('{"success": true}', 200);
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await apiClient.get(endpoint);

        // Assert
        expect(result, equals({'success': true}));
        verify(
          mockClient.get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('should handle GET request with query parameters', () async {
        // Arrange
        final mockResponse = http.Response('{"data": "filtered"}', 200);
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await apiClient.get(
          endpoint,
          queryParameters: {'page': '1', 'limit': '10', 'sort': 'name'},
        );

        // Assert
        verify(
          mockClient.get(
            Uri.parse('$baseUrl$endpoint?page=1&limit=10&sort=name'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('should handle empty response body', () async {
        // Arrange
        final mockResponse = http.Response('', 200);
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await apiClient.get(endpoint);

        // Assert
        expect(result, equals({}));
      });

      test('should throw HttpException on 4xx status codes', () async {
        // Arrange
        final mockResponse = http.Response('{"error": "Not found"}', 404);
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => apiClient.get(endpoint),
          throwsA(
            isA<HttpException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having(
                  (e) => e.responseBody,
                  'responseBody',
                  '{"error": "Not found"}',
                ),
          ),
        );
      });
    });

    group('POST requests', () {
      test('should make successful POST request', () async {
        // Arrange
        final requestBody = {'name': 'test', 'value': 123};
        final mockResponse = http.Response('{"success": true, "id": 1}', 201);
        when(
          mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await apiClient.post(endpoint, requestBody);

        // Assert
        expect(result, equals({'success': true, 'id': 1}));
        verify(
          mockClient.post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          ),
        ).called(1);
      });

      test('should throw HttpException on 4xx status codes', () async {
        // Arrange
        final requestBody = {'invalid': 'data'};
        final mockResponse = http.Response('{"error": "Bad request"}', 400);
        when(
          mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, requestBody),
          throwsA(
            isA<HttpException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having(
                  (e) => e.responseBody,
                  'responseBody',
                  '{"error": "Bad request"}',
                ),
          ),
        );
      });
    });
  });
}
