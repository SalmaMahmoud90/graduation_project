import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:a_tareqaak/main.dart';

void main() {
  testWidgets(
    'App starts correctly',
    (WidgetTester tester) async {

      await tester.pumpWidget(
        const MyApp(
          initialLocale: Locale('ar'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    },
  );
}