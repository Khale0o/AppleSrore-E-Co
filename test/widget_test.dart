import 'dart:io';

import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:applestore/core/accessibility/reduced_motion_controller.dart';
import 'package:applestore/features/cart/presentation/cart_state.dart';
import 'package:applestore/features/home/presentation/home_products.dart';
import 'package:applestore/features/product_details/presentation/product_variants.dart';
import 'package:applestore/features/saved/presentation/saved_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpRoute(WidgetTester tester, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(const ProviderScope(child: AppleStoreApp()));
  await tester.pumpAndSettle();
}

void main() {
  test(
    'catalog contains all six required categories',
    () => expect(ProductCategory.values, hasLength(6)),
  );
  test(
    'catalog has supplied ecosystem products',
    () => expect(homeProducts, hasLength(28)),
  );
  test(
    'category selection data filters products',
    () => expect(
      homeProducts.where((p) => p.category == ProductCategory.mac),
      hasLength(7),
    ),
  );
  test(
    'product search data finds product',
    () => expect(
      homeProducts.where((p) => p.name.toLowerCase().contains('airpods')),
      hasLength(3),
    ),
  );
  test('product sort by price works', () {
    final p = [...homeProducts]
      ..sort((a, b) => a.basePrice.compareTo(b.basePrice));
    expect(p.first.name, 'AirTag');
  });
  test(
    'product IDs resolve correct Details data',
    () => expect(productForIdOrNull('iphone-17-pro')!.name, 'iPhone 17 Pro'),
  );
  test(
    'invalid product ID has fallback data result',
    () => expect(productForIdOrNull('invalid'), isNull),
  );
  test(
    'configuration data exposes options',
    () => expect(productForId('ipad-air').configurations, isNotEmpty),
  );
  test('configured real product adds to Cart', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c
        .read(cartProvider.notifier)
        .add(
          const CartItem(
            productId: 'ipad-air',
            name: 'iPad Air',
            finish: 'Blue',
            storage: '128 GB',
            unitPrice: 599,
          ),
        );
    expect(c.read(cartProvider).single.name, 'iPad Air');
  });
  test('same cart configuration merges', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    const item = CartItem(
      productId: 'airtag',
      name: 'AirTag',
      finish: 'Silver',
      storage: 'Standard',
      unitPrice: 29,
    );
    c.read(cartProvider.notifier).add(item);
    c.read(cartProvider.notifier).add(item);
    expect(c.read(cartProvider).single.quantity, 2);
  });
  test('different configuration separates cart lines', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final n = c.read(cartProvider.notifier);
    n.add(
      const CartItem(
        productId: 'iphone-17',
        name: 'iPhone 17',
        finish: 'Blue',
        storage: '128 GB',
        unitPrice: 799,
      ),
    );
    n.add(
      const CartItem(
        productId: 'iphone-17',
        name: 'iPhone 17',
        finish: 'Silver',
        storage: '128 GB',
        unitPrice: 799,
      ),
    );
    expect(c.read(cartProvider), hasLength(2));
  });
  test('cart total and removal work in the session', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    const item = CartItem(
      productId: 'mac-mini',
      name: 'Mac mini',
      finish: 'Silver',
      storage: '256 GB',
      unitPrice: 599,
    );
    final n = c.read(cartProvider.notifier);
    n.add(item);
    n.change(item, 1);
    expect(c.read(cartSubtotalProvider), 1198);
    n.remove(item);
    expect(c.read(cartProvider), isEmpty);
  });

  testWidgets('navigation shell switches tabs', (tester) async {
    await pumpRoute(tester, '/home');
    expect(find.text('AppleStore Concept'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Explore'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Home exposes campaign and commerce sections', (tester) async {
    await pumpRoute(tester, '/home');
    expect(find.text('Shop now'), findsWidgets);
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -520),
    );
    await tester.pumpAndSettle();
    expect(find.text('Flash Deals'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Best Selling'),
      360,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Best Selling'), findsOneWidget);
  });

  testWidgets('catalog category filtering works', (tester) async {
    await pumpRoute(tester, '/catalog');
    await tester.tap(find.text('Mac'));
    await tester.pumpAndSettle();
    expect(find.textContaining('7 products'), findsOneWidget);
    expect(find.text('MacBook Air 13-inch'), findsWidgets);
  });

  testWidgets('catalog product search works', (tester) async {
    await pumpRoute(tester, '/catalog');
    await tester.enterText(
      find.byKey(const Key('catalog_search')),
      'AirPods Pro 3',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('1 products'), findsOneWidget);
    expect(find.text('AirPods Pro 3'), findsWidgets);
  });

  testWidgets('Details renders the requested product', (tester) async {
    await pumpRoute(tester, '/product/ipad-air');
    expect(find.text('iPad Air'), findsOneWidget);
    expect(find.byKey(const Key('details_add_to_cart')), findsOneWidget);
  });

  testWidgets('invalid product route renders fallback', (tester) async {
    await pumpRoute(tester, '/product/not-a-product');
    expect(find.text('PRODUCT UNAVAILABLE'), findsOneWidget);
  });

  test('selection preserves a valid variant and configuration', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final product = productForId('iphone-17-pro');
    final controller = container.read(productSelectionsProvider.notifier);
    final variant = variantsFor(product).first;
    controller.setVariant(product, variant.id);
    controller.setConfiguration(product, product.configurations[1]);
    final selection = controller.forProduct(product);
    expect(selection.variantId, variant.id);
    expect(selection.configuration, product.configurations[1]);
  });

  test('different variants separate while identical variants merge', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final cart = container.read(cartProvider.notifier);
    const red = CartItem(
      productId: 'iphone-17',
      name: 'iPhone 17',
      finish: 'Red',
      storage: '128 GB',
      unitPrice: 799,
      variantId: 'red',
    );
    const blue = CartItem(
      productId: 'iphone-17',
      name: 'iPhone 17',
      finish: 'Blue',
      storage: '128 GB',
      unitPrice: 799,
      variantId: 'blue',
    );
    cart.add(red);
    cart.add(red);
    cart.add(blue);
    expect(container.read(cartProvider), hasLength(2));
    expect(container.read(cartProvider).first.quantity, 2);
  });

  test('Saved state adds and removes a selected variant', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    const item = SavedItem(
      productId: 'ipad-air',
      variantId: 'ipad-air-default',
      variantName: 'Silver',
      imagePath: 'assets/products/ipad/ipad-family.png',
    );
    container.read(savedProvider.notifier).toggle(item);
    expect(container.read(savedProvider), contains(item));
    container.read(savedProvider.notifier).toggle(item);
    expect(container.read(savedProvider), isEmpty);
  });

  testWidgets('Reduced Motion preserves shell interactions', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reducedMotionControllerProvider.overrideWith(
            _ReducedMotionTestController.new,
          ),
        ],
        child: const AppleStoreApp(),
      ),
    );
    appRouter.go('/home');
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsWidgets);
  });

  test('every normal product and variant path exists locally', () {
    for (final product in homeProducts) {
      expect(File(product.assetPath).existsSync(), isTrue, reason: product.id);
      for (final variant in variantsFor(product)) {
        expect(
          File(variant.imagePath).existsSync(),
          isTrue,
          reason: variant.id,
        );
      }
    }
  });
}

class _ReducedMotionTestController extends ReducedMotionController {
  @override
  ReducedMotionState build() => const ReducedMotionState(override: true);
}
