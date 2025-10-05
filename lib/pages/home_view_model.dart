import 'package:flutter/foundation.dart';
import 'package:shorten_links/domain/exceptions/parse_exception.dart'
    show ParseException;
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/network/http_exception.dart';
import 'package:shorten_links/pages/home_state.dart';
import 'package:shorten_links/repositories/link_repository.dart';
import 'package:shorten_links/utils/result.dart';

class HomeViewModel {
  HomeViewModel(this._linkRepository);

  final LinkRepository _linkRepository;
  final ValueNotifier<HomeState> _state = ValueNotifier(HomeState.initial());
  ValueListenable<HomeState> get state => _state;
  List<Link> get links => _state.value.links;

  Future<void> shortenUrl(String url) async {
    _emitShortening();

    final result = await _linkRepository.shortenUrl(url);
    switch (result) {
      case Ok():
        _emitSuccess(result.value);
      case Error():
        _emitError(_getErrorMessage(result.error));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is HttpException) {
      return 'Network error: ${error.message}.';
    } else if (error is ParseException) {
      return 'Invalid response from server.';
    } else {
      return 'An unexpected error occurred.';
    }
  }

  void _emitShortening() {
    _state.value = HomeState(links: links, isShortening: true, error: null);
  }

  void _emitError(String error) {
    _state.value = HomeState(links: links, isShortening: false, error: error);
  }

  void _emitSuccess(Link link) {
    _state.value = HomeState(
      links: [...links, link],
      isShortening: false,
      error: null,
    );
  }
}
