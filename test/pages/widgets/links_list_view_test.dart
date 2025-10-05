import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/pages/widgets/links_list_view.dart';
import '../../test_helpers/widget_test_helpers.dart';

void main() {
  group('LinksListView', () {
    testWidgets('should display empty state with default message', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyLinks = <Link>[];

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        LinksListView(links: emptyLinks),
      );

      // Assert
      expect(find.text('The links list is empty.'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should display empty state with custom message', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyLinks = <Link>[];
      const customMessage = 'No links found. Please add a link to shorten.';

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        LinksListView(links: emptyLinks, emptyMessage: customMessage),
      );

      // Assert
      expect(find.text(customMessage), findsOneWidget);
      expect(find.text('The links list is empty.'), findsNothing);
    });

    testWidgets('should display links list when links exist', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testLinks = [
        Link(
          alias: 'abc123',
          url: 'https://example.com',
          shortUrl: 'https://short.ly/abc123',
        ),
        Link(
          alias: 'def456',
          url: 'https://google.com',
          shortUrl: 'https://short.ly/def456',
        ),
      ];

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        LinksListView(links: testLinks),
      );

      // Assert
      expect(find.text('Recently shortened links'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget); // One divider between items
      expect(find.text('https://example.com'), findsOneWidget);
      expect(find.text('https://google.com'), findsOneWidget);
    });

    testWidgets('should display single link correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final singleLink = [
        Link(
          alias: 'single123',
          url: 'https://single.com',
          shortUrl: 'https://short.ly/single123',
        ),
      ];

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        LinksListView(links: singleLink),
      );

      // Assert
      expect(find.text('Recently shortened links'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Divider), findsNothing); // No dividers for single item
      expect(find.text('https://single.com'), findsOneWidget);
    });
  });
}
