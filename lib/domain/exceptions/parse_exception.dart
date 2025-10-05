class ParseException implements Exception {
  final String message;
  final Map<String, dynamic>? rawJson;
  final String? originalError;

  ParseException({required this.message, this.rawJson, this.originalError});

  @override
  String toString() {
    String result = 'ParseException: $message';
    if (originalError != null) {
      result += ' (Original: $originalError)';
    }
    if (rawJson != null) {
      result += ' (JSON: $rawJson)';
    }
    return result;
  }
}
