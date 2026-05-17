import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the default light theme and variant buttons', (
    tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Clean Light'), findsOneWidget);
    expect(find.text('Active tokens: Clean Light'), findsOneWidget);
    expect(find.text('Primary large'), findsOneWidget);
    expect(find.text('Danger small'), findsOneWidget);
  });

  testWidgets('can force the dark theme independently', (tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.text('Forest Dark'), findsOneWidget);
    expect(find.text('Active tokens: Forest Dark'), findsOneWidget);
  });

  testWidgets('can switch the selected light theme', (tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forest light').last);
    await tester.pumpAndSettle();

    expect(find.text('Forest Light'), findsOneWidget);
    expect(find.text('Active tokens: Forest Light'), findsOneWidget);
  });
}
