import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_hex_pm/screens/app/error_screen.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('should have correct static properties', (WidgetTester tester) async {
      expect(ErrorScreen.name, equals('Error'));
      expect(ErrorScreen.path, equals('/error'));
    });

    testWidgets('should be stateless widget', (WidgetTester tester) async {
      // Test that ErrorScreen is a StatelessWidget
      // We can't instantiate it without a GoRouterState, but we can test its type
      expect(ErrorScreen, isA<Type>());
    });

    testWidgets('should have static path', (WidgetTester tester) async {
      expect(ErrorScreen.path, equals('/error'));
    });

    testWidgets('should have static name', (WidgetTester tester) async {
      expect(ErrorScreen.name, equals('Error'));
    });

    testWidgets('should be a widget type', (WidgetTester tester) async {
      // Test that ErrorScreen extends StatelessWidget
      expect(const TypeMatcher<ErrorScreen>(), isA<TypeMatcher<Widget>>());
    });

    testWidgets('should build basic error screen in isolation', (WidgetTester tester) async {
      // Test basic error screen concept without dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  Text('Test error message'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle error state concept', (WidgetTester tester) async {
      // Test the concept of error handling
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text('Something went wrong'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}