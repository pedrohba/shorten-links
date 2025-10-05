import 'package:shorten_links/domain/link.dart';
import 'package:shorten_links/try_parse.dart';

class ShortenUrlResponse {
  final String alias;
  final Links links;

  ShortenUrlResponse({required this.alias, required this.links});

  factory ShortenUrlResponse.fromJson(Map<String, dynamic> json) {
    return tryParse(
      (json) => ShortenUrlResponse(
        alias: json['alias'],
        links: Links.fromJson(json['links']),
      ),
      json,
    );
  }

  Link toDomain() {
    return Link(alias: alias, url: links.self, shortUrl: links.short);
  }
}

class Links {
  final String self;
  final String short;

  Links({required this.self, required this.short});

  factory Links.fromJson(Map<String, dynamic> json) {
    return tryParse(
      (json) => Links(self: json['self'], short: json['short']),
      json,
    );
  }
}
