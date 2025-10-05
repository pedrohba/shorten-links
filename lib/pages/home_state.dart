import 'package:shorten_links/domain/models/link.dart';

class HomeState {
  final List<Link> links;
  final bool isShortening;
  final String? error;

  factory HomeState.initial() {
    return HomeState(links: [], isShortening: false, error: null);
  }

  HomeState({required this.links, this.isShortening = false, this.error});
}
