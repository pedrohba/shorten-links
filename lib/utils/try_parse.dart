import 'package:shorten_links/domain/parse_exception.dart';

T tryParse<T>(
  T Function(Map<String, dynamic> json) fromJson,
  Map<String, dynamic> json,
) {
  try {
    return fromJson(json);
  } catch (e) {
    throw ParseException(
      message: 'Failed to parse $T from JSON',
      rawJson: json,
      originalError: e.toString(),
    );
  }
}
