import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shorten_links/domain/models/link.dart';
import 'package:shorten_links/pages/home_screen.dart';
import 'package:shorten_links/pages/home_view_model.dart';
import 'package:shorten_links/pages/home_state.dart';
import 'package:shorten_links/pages/widgets/links_list_view.dart';
import 'package:shorten_links/pages/widgets/url_input_field.dart';
import '../test_helpers/widget_test_helpers.dart';

@GenerateMocks([HomeViewModel])
import 'home_screen_test.mocks.dart';

void main() {
  group('HomeScreen', () {
    late MockHomeViewModel mockViewModel;
    late ValueNotifier<HomeState> stateNotifier;

    setUp(() {
      mockViewModel = MockHomeViewModel();
      stateNotifier = ValueNotifier(
        HomeState(links: [], isShortening: false, error: null),
      );

      when(mockViewModel.state).thenReturn(stateNotifier);
    });

    tearDown(() {
      stateNotifier.dispose();
    });

    testWidgets('should display empty state when no links', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: false,
        error: null,
      );

      // Act
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));

      // Assert
      expect(find.text('Shorten Links'), findsOneWidget);
      expect(
        find.text('No links found. Please add a link to shorten.'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
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

      stateNotifier.value = HomeState(
        links: testLinks,
        isShortening: false,
        error: null,
      );

      // Act
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));

      // Assert
      expect(find.text('Recently shortened links'), findsOneWidget);
      expect(find.byType(LinksListView), findsOneWidget);
    });

    testWidgets('should show loading state when shortening URL', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: true,
        error: null,
      );

      // Act
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));

      // Assert
      final urlInputField = tester.widget<UrlInputField>(
        find.byType(UrlInputField),
      );
      expect(urlInputField.isShortening, isTrue);
    });

    testWidgets('should show non-loading state when not shortening URL', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: false,
        error: null,
      );

      // Act
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));

      // Assert
      final urlInputField = tester.widget<UrlInputField>(
        find.byType(UrlInputField),
      );
      expect(urlInputField.isShortening, isFalse);
    });

    testWidgets('should display error message when error exists', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: false,
        error: 'Network error occurred',
      );

      // Act
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Network error occurred'), findsOneWidget);
    });

    testWidgets('should call shortenUrl when send button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: false,
        error: null,
      );
      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));
      await tester.enterText(find.byType(TextField), 'https://example.com');

      // Act
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      // Assert
      verify(mockViewModel.shortenUrl('https://example.com')).called(1);
    });

    testWidgets('should not call shortenUrl when text field is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      stateNotifier.value = HomeState(
        links: [],
        isShortening: false,
        error: null,
      );

      await WidgetTestHelpers.pumpPage(tester, HomeScreen(mockViewModel));

      // Act - tap send button without entering text
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      // Assert
      verifyNever(mockViewModel.shortenUrl(any));
    });
  });
}
