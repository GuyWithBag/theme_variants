import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the default light theme and variant buttons', (
    tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Active theme: Clean Light'), findsOneWidget);
    expect(find.text('Button variants'), findsOneWidget);
    expect(find.text('Action'), findsNWidgets(6));
    expect(find.text('Compound'), findsOneWidget);
    expect(find.text('Overridden flashcard'), findsOneWidget);
    expect(find.text('Inherited flashcard'), findsOneWidget);
    expect(find.text('Card theme: Forest Light'), findsOneWidget);
    expect(find.text('Card theme: Clean Light'), findsOneWidget);
  });

  testWidgets('can force the dark theme independently', (tester) async {
    await tester.pumpWidget(const App());

    final darkThemeMode = find.text('Dark');
    await tester.ensureVisible(darkThemeMode);
    await tester.pumpAndSettle();

    await tester.tap(darkThemeMode);
    await tester.pumpAndSettle();

    expect(find.text('Active theme: Forest Dark'), findsOneWidget);
  });

  testWidgets('can switch the selected light theme', (tester) async {
    await tester.pumpWidget(const App());

    final lightThemeDropdown = find.byType(DropdownButton<String>).first;
    await tester.ensureVisible(lightThemeDropdown);
    await tester.pumpAndSettle();

    await tester.tap(lightThemeDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forest Light').last);
    await tester.pumpAndSettle();

    expect(find.text('Active theme: Forest Light'), findsOneWidget);
  });
}
