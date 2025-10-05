import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/utils/result.dart';

abstract class LinkRepository {
  Future<Result<Link>> shortenUrl(String url);

  Future<Result<String>> getOriginalUrl(String alias);
}
