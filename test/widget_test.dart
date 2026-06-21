// Smoke test for the Nectar app shell.
//
// Verifies the app boots into the Home tab and that the four bottom-navigation
// destinations are wired up via the routing shell.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/app/app.dart';

void main() {
  testWidgets('boots into Home with all navigation destinations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NectarApp()));
    await tester.pumpAndSettle();

    // Home content is shown on launch.
    expect(find.bySemanticsLabel('Nectar'), findsOneWidget);
    expect(find.text('Recently uploaded'), findsOneWidget);

    // All four tabs are present in the bottom bar.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Ranks'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('navigates to the Groups maintenance screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NectarApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ranks'));
    await tester.pumpAndSettle();

    expect(find.text('Groups'), findsOneWidget);
    expect(find.text('Under Maintenance'), findsOneWidget);
  });
}
