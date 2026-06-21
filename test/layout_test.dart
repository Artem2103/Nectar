// Layout regression test at a real phone surface (393 x 852, iPhone logical px).
//
// Guards against horizontal overflow in the app shell: the streak pill and the
// add-meal FAB must sit fully within the viewport. A RenderFlex overflow is
// reported to the test binding and fails the test automatically, so reaching
// the geometry assertions already implies an overflow-free layout.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/app/app.dart';

void main() {
  const phone = Size(393, 852);

  testWidgets('shell fits within a phone viewport without overflow',
      (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1.0
      ..physicalSize = phone;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: NectarApp()));
    await tester.pumpAndSettle();

    // The add-meal FAB is fully on-screen (right edge within viewport width).
    final fabRight = tester.getBottomRight(find.bySemanticsLabel('Add meal'));
    expect(fabRight.dx, lessThanOrEqualTo(phone.width));

    // The streak pill on the header is visible within the viewport.
    final streak = find.text('0');
    expect(streak, findsOneWidget);
    expect(tester.getTopRight(streak).dx, lessThanOrEqualTo(phone.width));
  });
}
