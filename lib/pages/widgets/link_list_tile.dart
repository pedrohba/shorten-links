import 'package:flutter/material.dart';
import 'package:shorten_links/domain/models/link.dart';

class LinkListTile extends StatelessWidget {
  const LinkListTile({super.key, required this.link});
  final Link link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(link.url, style: Theme.of(context).textTheme.titleMedium),
          Text(
            'Alias: ${link.alias}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Short URL: ${link.shortUrl}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
