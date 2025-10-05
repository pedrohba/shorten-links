import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for common widget test utilities
class WidgetTestHelpers {
  /// Wraps a widget in MaterialApp and Scaffold for testing
  static Widget wrapForTesting(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  /// Wraps a page widget in MaterialApp for testing (no Scaffold needed)
  static Widget wrapPageForTesting(Widget child) {
    return MaterialApp(home: child);
  }

  /// Pumps a widget wrapped in MaterialApp and Scaffold
  static Future<void> pumpWidget(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(wrapForTesting(widget));
  }

  /// Pumps a page widget wrapped in MaterialApp (no Scaffold needed)
  static Future<void> pumpPage(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(wrapPageForTesting(page));
  }

  /// Pumps a widget and waits for animations to settle
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(wrapForTesting(widget));
    await tester.pumpAndSettle();
  }
}
