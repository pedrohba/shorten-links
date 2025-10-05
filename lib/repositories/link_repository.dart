import 'package:shorten_links/network/api_client.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/repositories/dtos/get_url_response.dart';
import 'package:shorten_links/repositories/dtos/shorten_url_response.dart';

class LinkRepository {
  final ApiClient _apiClient;

  LinkRepository(this._apiClient);

  Future<Link> shortenUrl(String url) async {
    final rawResponse = await _apiClient.post('/alias', {'url': url});
    final response = ShortenUrlResponse.fromJson(rawResponse);
    return response.toDomain();
  }

  Future<String> getOriginalUrl(String alias) async {
    final rawResponse = await _apiClient.get('/alias/$alias');
    final response = GetUrlResponse.fromJson(rawResponse);
    return response.toDomain();
  }
}
