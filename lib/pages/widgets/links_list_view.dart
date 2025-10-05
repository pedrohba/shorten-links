import 'package:flutter/material.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/pages/widgets/link_list_tile.dart';

class LinksListView extends StatelessWidget {
  const LinksListView({super.key, required this.links, this.emptyMessage});

  final List<Link> links;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return Center(child: Text(emptyMessage ?? 'The links list is empty.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recently shortened links',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              return LinkListTile(link: link);
            },
          ),
        ),
      ],
    );
  }
}
