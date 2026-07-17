import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpRoute(WidgetTester tester, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(const ProviderScope(child: AppleStoreApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Details displays product from productId', (t) async {
    await pumpRoute(t, '/product/aether-pro');
    expect(find.text('Aether Pro'), findsOneWidget);
  });
  testWidgets('Details shows fictional feature content', (t) async {
    await pumpRoute(t, '/product/aether-pro');
    expect(find.textContaining('Aerospace alloy frame'), findsOneWidget);
  });
  testWidgets('Configure opens with same productId', (t) async {
    await pumpRoute(t, '/product/aether-air');
    await t.tap(find.textContaining('Configure'));
    await t.pumpAndSettle();
    expect(find.text('Aether Air'), findsOneWidget);
  });
  testWidgets('Color selection updates selected finish', (t) async {
    await pumpRoute(t, '/product/aether-pro/configure');
    await t.tap(find.byKey(const Key('color_1')));
    await t.pumpAndSettle();
    expect(
      t.widget<ChoiceChip>(find.byKey(const Key('color_1'))).selected,
      isTrue,
    );
  });
  testWidgets('Storage selection updates price', (t) async {
    await pumpRoute(t, '/product/aether-pro/configure');
    await t.tap(find.byKey(const Key('storage_2')));
    await t.pumpAndSettle();
    expect(find.text('From 1149'), findsOneWidget);
  });
  testWidgets('Reduced Motion keeps configuration controls functional', (
    t,
  ) async {
    await pumpRoute(t, '/home');
    await t.tap(find.byKey(const Key('reduced_motion_toggle')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('explore_action')));
    await t.pumpAndSettle();
    await t.tap(find.textContaining('Configure'));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('storage_1')));
    await t.pumpAndSettle();
    expect(find.text('From 999'), findsOneWidget);
  });
  testWidgets('Invalid product ID shows fallback', (t) async {
    await pumpRoute(t, '/product/unknown');
    expect(find.text('PRODUCT UNAVAILABLE'), findsOneWidget);
  });
  testWidgets('Back navigation remains functional', (t) async {
    await pumpRoute(t, '/home');
    await t.tap(find.byKey(const Key('explore_action')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('details_back')));
    await t.pumpAndSettle();
    expect(find.text('Aether Pro'), findsOneWidget);
  });
}
