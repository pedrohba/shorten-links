import 'package:flutter/material.dart';
import 'package:shorten_links/pages/home_view_model.dart';
import 'package:shorten_links/pages/widgets/link_list_tile.dart';
import 'package:shorten_links/pages/widgets/url_input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.viewModel, {super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  HomeViewModel get viewModel => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.state,
      builder: (context, state, child) {
        showErrorIfExists(state.error);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shorten Links'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: UrlInputField(
                controller: _urlController,
                onSendPressed: _onSendPressed,
                isShortening: state.isShortening,
              ),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.links.isEmpty) {
                  return const Center(
                    child: Text(
                      'No links found. Please add a link to shorten.',
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Recently shortened links',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.links.length,
                        itemBuilder: (context, index) {
                          final link = state.links[index];
                          return LinkListTile(link: link);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showErrorIfExists(String? error) {
    if (error != null) {
      // Making sure the build is complete before showing the snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: ColorScheme.of(context).error,
            ),
          );
        }
      });
    }
  }

  void _onSendPressed() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      viewModel.shortenUrl(url);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
