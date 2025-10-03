class HttpException implements Exception {
  final int statusCode;
  final String responseBody;
  final String message;

  HttpException({
    required this.statusCode,
    required this.responseBody,
    required this.message,
  });

  @override
  String toString() =>
      'HttpException: $message (Status: $statusCode, Body: $responseBody)';
}
