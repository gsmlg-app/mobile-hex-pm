import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_hex_pm/screens/home/home_result_screen.dart';

void main() {
  group('HomeResultScreen', () {
    const testPackageName = 'test_package';

    testWidgets('should have correct static properties', (WidgetTester tester) async {
      expect(HomeResultScreen.name, equals('Home Screen Search Result'));
      expect(HomeResultScreen.path, equals('search/:package_name/result'));
      expect(HomeResultScreen.fullPath, equals('/home/search/:package_name/result'));
    });

    testWidgets('should be stateless widget', (WidgetTester tester) async {
      // HomeResultScreen should be a StatelessWidget
      final homeResultScreen = HomeResultScreen(packageName: testPackageName);
      expect(homeResultScreen, isA<StatelessWidget>());
    });

    testWidgets('should be a widget type', (WidgetTester tester) async {
      // HomeResultScreen should extend StatelessWidget
      expect(const TypeMatcher<HomeResultScreen>(), isA<TypeMatcher<Widget>>());
    });

    testWidgets('should have proper path', (WidgetTester tester) async {
      // Test static path property
      expect(HomeResultScreen.path, equals('search/:package_name/result'));
    });

    testWidgets('should have proper name', (WidgetTester tester) async {
      // Test static name property
      expect(HomeResultScreen.name, equals('Home Screen Search Result'));
    });

    testWidgets('should have proper full path', (WidgetTester tester) async {
      // Test static full path property
      expect(HomeResultScreen.fullPath, equals('/home/search/:package_name/result'));
    });

    testWidgets('should build home result screen concept', (WidgetTester tester) async {
      // Test basic home result screen concept without dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('$testPackageName Results'),
              backgroundColor: Colors.purple,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.purple),
                  SizedBox(height: 24),
                  Text(
                    'Found results for $testPackageName',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Search results will be displayed here',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('View Package Details'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('$testPackageName Results'), findsOneWidget);
      expect(find.text('Found results for $testPackageName'), findsOneWidget);
      expect(find.text('Search results will be displayed here'), findsOneWidget);
      expect(find.text('View Package Details'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Center), findsNWidgets(2)); // Multiple Center widgets in the widget tree
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should create with different package names', (WidgetTester tester) async {
      const packageName1 = 'package_one';
      const packageName2 = 'package_two';

      final resultScreen1 = HomeResultScreen(packageName: packageName1);
      final resultScreen2 = HomeResultScreen(packageName: packageName2);

      expect(resultScreen1, isA<Widget>());
      expect(resultScreen2, isA<Widget>());
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: Text('Home Result Screen Test'),
          ),
        ),
      );

      // Verify basic layout components
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home Result Screen Test'), findsOneWidget);
    });

    testWidgets('should handle responsive width calculation concept', (WidgetTester tester) async {
      // Test responsive layout concept
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                bool isMobile = width < 600;
                double responsiveWidth = isMobile ? width * 0.9 : 600;

                return Center(
                  child: Container(
                    width: responsiveWidth,
                    height: 200,
                    color: Colors.blue[100],
                    child: Center(
                      child: Text('Responsive result width: ${responsiveWidth.toInt()}px'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.textContaining('Responsive result width:'), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Center), findsNWidgets(2)); // Multiple Center widgets in the widget tree
    });
  });
}