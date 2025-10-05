import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/pages/widgets/link_list_tile.dart';
import '../../test_helpers/widget_test_helpers.dart';

void main() {
  group('LinkListTile', () {
    testWidgets('should display all link information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testLink = Link(
        alias: 'abc123',
        url: 'https://example.com',
        shortUrl: 'https://short.ly/abc123',
      );

      // Act
      await WidgetTestHelpers.pumpWidget(tester, LinkListTile(link: testLink));

      // Assert
      expect(find.text('https://example.com'), findsOneWidget);
      expect(find.text('Alias: abc123'), findsOneWidget);
      expect(find.text('Short URL: https://short.ly/abc123'), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testLink = Link(
        alias: 'test',
        url: 'https://test.com',
        shortUrl: 'https://short.ly/test',
      );

      // Act
      await WidgetTestHelpers.pumpWidget(tester, LinkListTile(link: testLink));

      // Assert
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(3));
    });
  });
}
