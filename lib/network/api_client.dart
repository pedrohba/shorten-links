import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exceptions/api_exception.dart';
import 'exceptions/http_exception.dart';

class ApiClient {
  static ApiClient? _instance;
  final String _baseUrl;
  final http.Client _client;

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // Private constructor
  ApiClient._({required String baseUrl, required http.Client client})
    : _baseUrl = baseUrl,
      _client = client;

  // Factory constructor to return singleton instance
  factory ApiClient() {
    if (_instance == null) {
      throw Exception('ApiClient not initialized');
    }
    return _instance!;
  }

  // Initialize the singleton with required parameters
  static void init({required String baseUrl, http.Client? client}) {
    _instance = ApiClient._(baseUrl: baseUrl, client: client ?? http.Client());
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final uriWithParams =
          queryParameters != null && queryParameters.isNotEmpty
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      final response = await _client.get(uriWithParams, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw HttpException(
        statusCode: response.statusCode,
        responseBody: response.body,
        message: 'HTTP request failed with status ${response.statusCode}',
      );
    }
  }

  void dispose() {
    _client.close();
    _instance = null;
  }
}
