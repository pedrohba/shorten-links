import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_links/pages/widgets/url_input_field.dart';
import '../../test_helpers/widget_test_helpers.dart';

void main() {
  group('UrlInputField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display text field and send button', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onSendPressed() {}

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        UrlInputField(
          controller: controller,
          onSendPressed: onSendPressed,
          isShortening: false,
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Enter URL to shorten...'), findsOneWidget);
    });

    testWidgets('should show loading indicator when shortening', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onSendPressed() {}

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        UrlInputField(
          controller: controller,
          onSendPressed: onSendPressed,
          isShortening: true,
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should call onSendPressed when send button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var onSendPressedCalled = false;
      void onSendPressed() => onSendPressedCalled = true;

      await WidgetTestHelpers.pumpWidget(
        tester,
        UrlInputField(
          controller: controller,
          onSendPressed: onSendPressed,
          isShortening: false,
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      // Assert
      expect(onSendPressedCalled, isTrue);
    });

    testWidgets('should display text in text field', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onSendPressed() {}
      controller.text = 'https://example.com';

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        UrlInputField(
          controller: controller,
          onSendPressed: onSendPressed,
          isShortening: false,
        ),
      );

      // Assert
      expect(find.text('https://example.com'), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      void onSendPressed() {}

      // Act
      await WidgetTestHelpers.pumpWidget(
        tester,
        UrlInputField(
          controller: controller,
          onSendPressed: onSendPressed,
          isShortening: false,
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.text('Enter URL to shorten...'), findsOneWidget);
    });
  });
}
