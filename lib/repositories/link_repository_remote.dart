import 'dart:developer';

import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/repositories/dtos/get_url_response.dart';
import 'package:shorten_links/repositories/dtos/shorten_url_response.dart';
import 'package:shorten_links/repositories/link_repository.dart';
import 'package:shorten_links/utils/result.dart';

class LinkRepositoryRemote implements LinkRepository {
  final ApiClient _apiClient;

  LinkRepositoryRemote(this._apiClient);

  @override
  Future<Result<Link>> shortenUrl(String url) async {
    try {
      final rawResponse = await _apiClient.post('/alias', {'url': url});
      final response = ShortenUrlResponse.fromJson(rawResponse);
      return Result.ok(response.toDomain());
    } on Exception catch (e) {
      log(e.toString());
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> getOriginalUrl(String alias) async {
    try {
      final rawResponse = await _apiClient.get('/alias/$alias');
      final response = GetUrlResponse.fromJson(rawResponse);
      return Result.ok(response.toDomain());
    } on Exception catch (e) {
      log(e.toString());
      return Result.error(e);
    }
  }
}
