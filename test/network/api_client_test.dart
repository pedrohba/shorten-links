import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:shorten_links/network/api_client.dart';

// Generate mocks with: flutter packages pub run build_runner build
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
    });
  });
}
