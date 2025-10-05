import 'package:shorten_links/utils/try_parse.dart';

class GetUrlResponse {
  final String url;

  GetUrlResponse({required this.url});

  factory GetUrlResponse.fromJson(Map<String, dynamic> json) {
    return tryParse((json) => GetUrlResponse(url: json['url']), json);
  }

  String toDomain() {
    return url;
  }
}
