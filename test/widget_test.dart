import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_flutter_app/main.dart';

import 'support/attachments.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await attachScreenshot(tester, '1_start');

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await attachScreenshot(tester, '2_after_tap');

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  group('Counter', () {
    testWidgets('fails on purpose to show a failure screenshot', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await attachScreenshot(tester, 'failure');
      attach(utf8.encode('Counter after one tap: 1, expected: 2\n'), 'log', extension: 'txt');

      expect(find.text('2'), findsOneWidget);
    });
  });
}
