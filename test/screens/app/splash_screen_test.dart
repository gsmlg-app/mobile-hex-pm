import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_hex_pm/screens/app/splash_screen.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('should display splash screen without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SplashScreen(),
        ),
      );

      // Verify splash screen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('should have correct static properties', (WidgetTester tester) async {
      expect(SplashScreen.name, equals('Splash Screen'));
      expect(SplashScreen.path, equals('/'));
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SplashScreen(),
        ),
      );

      // Verify layout components
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsNWidgets(2)); // Multiple Center widgets in the widget tree
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should use theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const SplashScreen(),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(ColorScheme.fromSeed(seedColor: Colors.blue).surface));
    });

    testWidgets('should be stateful widget', (WidgetTester tester) async {
      // SplashScreen should be a StatefulWidget
      const splashScreen = SplashScreen();
      expect(splashScreen, isA<StatefulWidget>());
    });
  });
}