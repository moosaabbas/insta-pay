import 'package:insta_pay/components/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  const String name = 'TestUser';
  const String imageURL = 'assets/images/settings.png'; // Valid asset image path

  testWidgets('TopBar Widget Test', (WidgetTester tester) async {
    // Build the TopBar widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: Container(),
        ),
        body: TopBar(
          scaffoldKey: scaffoldKey,
          name: name,
          imageURL: imageURL, // Pass asset image path
        ),
      ),
    ));

    // Verify the TopBar displays the right text
    expect(find.text('Hi, $name'), findsOneWidget);

    // Verify the TopBar is currently not displaying the drawer
    expect(scaffoldKey.currentState!.isDrawerOpen, isFalse);

    // Tap the avatar and trigger a frame
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    // Verify the TopBar is now displaying the drawer
    expect(scaffoldKey.currentState!.isDrawerOpen, isTrue);
  });
}