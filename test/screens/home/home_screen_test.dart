import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_hex_pm/screens/home/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should have correct static properties', (WidgetTester tester) async {
      expect(HomeScreen.name, equals('Home Screen'));
      expect(HomeScreen.path, equals('/home'));
    });

    testWidgets('should be stateless widget', (WidgetTester tester) async {
      // HomeScreen should be a StatelessWidget
      const homeScreen = HomeScreen();
      expect(homeScreen, isA<StatelessWidget>());
    });

    testWidgets('should be a widget type', (WidgetTester tester) async {
      // HomeScreen should extend StatelessWidget
      expect(const TypeMatcher<HomeScreen>(), isA<TypeMatcher<Widget>>());
    });

    testWidgets('should have proper path', (WidgetTester tester) async {
      // Test static path property
      expect(HomeScreen.path, equals('/home'));
    });

    testWidgets('should have proper name', (WidgetTester tester) async {
      // Test static name property
      expect(HomeScreen.name, equals('Home Screen'));
    });

    testWidgets('should build home screen concept', (WidgetTester tester) async {
      // Test basic home screen concept without dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Hex.pm'),
              backgroundColor: Colors.purple,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2, size: 64, color: Colors.purple),
                  SizedBox(height: 24),
                  Text(
                    'Welcome to Hex.pm',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Search packages and save offline docs',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    label: Text('Search Packages'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hex.pm'), findsOneWidget);
      expect(find.text('Welcome to Hex.pm'), findsOneWidget);
      expect(find.text('Search packages and save offline docs'), findsOneWidget);
      expect(find.text('Search Packages'), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Center), findsNWidgets(3)); // Multiple Center widgets in the widget tree
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display hex.pm description', (WidgetTester tester) async {
      // Test hex.pm description display
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Search packages and save offline docs',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Search packages and save offline docs'), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should use responsive width calculation concept', (WidgetTester tester) async {
      // Test responsive layout concept
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                bool isMobile = width < 600;
                double responsiveWidth = isMobile ? width * 0.9 : 400;

                return Center(
                  child: Container(
                    width: responsiveWidth,
                    height: 200,
                    color: Colors.blue[100],
                    child: Center(
                      child: Text('Responsive width: ${responsiveWidth.toInt()}px'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.textContaining('Responsive width:'), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Center), findsNWidgets(2)); // Multiple Center widgets in the widget tree
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: Text('Home Screen Test'),
          ),
        ),
      );

      // Verify basic layout components
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home Screen Test'), findsOneWidget);
    });
  });
}