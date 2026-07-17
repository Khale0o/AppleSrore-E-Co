import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpRoute(WidgetTester tester, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(const ProviderScope(child: AppleStoreApp()));
  await tester.pumpAndSettle();
  /*test('cart adds, merges, separates, changes subtotal, and removes', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final cart = c.read(cartProvider.notifier);
    final a = const CartItem(
      productId: 'aether-pro',
      name: 'Aether Pro',
      finish: 'Graphite',
      storage: '128 GB',
      unitPrice: 899,
    );
    final b = const CartItem(
      productId: 'aether-pro',
      name: 'Aether Pro',
      finish: 'Blue',
      storage: '128 GB',
      unitPrice: 899,
    );
    cart.add(a);
    expect(c.read(cartProvider), hasLength(1));
    cart.add(a);
    expect(c.read(cartProvider).single.quantity, 2);
    cart.add(b);
    expect(c.read(cartProvider), hasLength(2));
    cart.change(a, -1);
    expect(c.read(cartSubtotalProvider), 1798);
    cart.remove(b);
    expect(c.read(cartProvider), hasLength(1));
  });*/
  /*testWidgets('empty cart renders and cart badge opens Cart', (t) async {
    await pumpRoute(t, '/home');
    await t.tap(find.byKey(const Key('cart_badge')));
    await t.pumpAndSettle();
    expect(find.text('Nothing selected yet.'), findsOneWidget);
  });
  testWidgets('Add to Bag confirms and opens Cart', (t) async {
    await pumpRoute(t, '/product/aether-pro/configure');
    await t.tap(find.byKey(const Key('add_to_bag')));
    await t.pumpAndSettle();
    expect(find.text('Added to Bag'), findsOneWidget);
    await t.tap(find.textContaining('Open Cart'));
    await t.pumpAndSettle();
    expect(find.text('Subtotal  899'), findsOneWidget);
  });*/
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
