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
    () => expect(productForId('ipad-air').optionGroups, isNotEmpty),
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
            selectedOptions: {'storage': '128 GB'},
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
      selectedOptions: {'size': '1 Pack'},
      unitPrice: 29,
    );
    c.read(cartProvider.notifier).add(item);
    c.read(cartProvider.notifier).add(item);
    expect(c.read(cartProvider).single.quantity, 2);
  });
  test('different applicable options separate cart lines', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final n = c.read(cartProvider.notifier);
    n.add(
      const CartItem(
        productId: 'iphone-17',
        name: 'iPhone 17',
        finish: 'Blue',
        selectedOptions: {'storage': '128 GB'},
        unitPrice: 799,
      ),
    );
    n.add(
      const CartItem(
        productId: 'iphone-17',
        name: 'iPhone 17',
        finish: 'Blue',
        selectedOptions: {'storage': '256 GB'},
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
      selectedOptions: {'memory': '16 GB', 'storage': '512 GB'},
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

  testWidgets('Details renders only product-specific option groups', (
    tester,
  ) async {
    await pumpRoute(tester, '/product/airpods-4');
    expect(find.text('Storage'), findsNothing);
    expect(find.textContaining('GB'), findsNothing);

    await pumpRoute(tester, '/product/iphone-17');
    expect(find.text('Storage'), findsOneWidget);

    await pumpRoute(tester, '/product/watch-series-11');
    expect(find.text('Case Size'), findsOneWidget);
    expect(find.text('Storage'), findsNothing);

    await pumpRoute(tester, '/product/macbook-pro-14');
    expect(find.text('Memory'), findsOneWidget);
    expect(find.text('Storage'), findsOneWidget);

    await pumpRoute(tester, '/product/magsafe-charger');
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('Configuration never adds storage to AirPods', (tester) async {
    await pumpRoute(tester, '/product/airpods-pro-3/configure');
    expect(find.text('Ear Tip Size'), findsOneWidget);
    expect(find.text('Storage'), findsNothing);
    expect(find.textContaining('GB'), findsNothing);
  });

  testWidgets('invalid product route renders fallback', (tester) async {
    await pumpRoute(tester, '/product/not-a-product');
    expect(find.text('PRODUCT UNAVAILABLE'), findsOneWidget);
  });

  test('selection preserves a valid variant and product option', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final product = productForId('iphone-17-pro');
    final controller = container.read(productSelectionsProvider.notifier);
    final variant = variantsFor(product).first;
    controller.setVariant(product, variant.id);
    controller.setOption(product, 'storage', '256gb');
    final selection = controller.forProduct(product);
    expect(selection.variantId, variant.id);
    expect(selection.optionValueIds['storage'], '256gb');
  });

  test('flagship finishes use distinct existing local image files', () {
    final product = productForId('iphone-17-pro');
    final variants = variantsFor(product);
    expect(variants, hasLength(3));
    expect(variants.map((variant) => variant.imagePath).toSet(), hasLength(3));
    for (final variant in variants) {
      expect(File(variant.imagePath).existsSync(), isTrue, reason: variant.id);
    }
  });

  test('product options are category-appropriate across the catalog', () {
    final airPods = productForId('airpods-pro-3');
    expect(
      airPods.optionGroups.any(
        (group) => group.type == ProductOptionType.storage,
      ),
      isFalse,
    );
    expect(
      productForId('iphone-17').optionGroups.map((group) => group.label),
      contains('Storage'),
    );
    expect(
      productForId('watch-series-11').optionGroups.map((group) => group.label),
      contains('Case Size'),
    );
    expect(
      productForId('watch-series-11').optionGroups.map((group) => group.label),
      isNot(contains('Storage')),
    );
    expect(
      productForId('macbook-pro-14').optionGroups.map((group) => group.label),
      containsAll(['Memory', 'Storage']),
    );
    expect(productForId('magsafe-charger').optionGroups, isEmpty);
    expect(
      productForId('magic-keyboard').optionGroups.map((group) => group.label),
      orderedEquals(['Size']),
    );
  });

  test('cart description contains only applicable selected options', () {
    const item = CartItem(
      productId: 'airpods-pro-3',
      name: 'AirPods Pro 3',
      finish: 'Soft White',
      selectedOptions: {'ear-tip-size': 'M'},
      unitPrice: 249,
      variantId: 'airpods-pro-3-soft-white',
    );
    expect(item.optionSummary, 'Soft White / M');
    expect(item.optionSummary, isNot(contains('GB')));
  });

  test('different variants separate while identical variants merge', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final cart = container.read(cartProvider.notifier);
    const red = CartItem(
      productId: 'iphone-17',
      name: 'iPhone 17',
      finish: 'Red',
      selectedOptions: {'storage': '128 GB'},
      unitPrice: 799,
      variantId: 'red',
    );
    const blue = CartItem(
      productId: 'iphone-17',
      name: 'iPhone 17',
      finish: 'Blue',
      selectedOptions: {'storage': '128 GB'},
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
      variantId: 'ipad-air-sky-blue',
      variantName: 'Sky Blue',
      imagePath: 'assets/products/ipad/ipad-air_blue.png',
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

  testWidgets('primary screens fit a 360px portrait viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final route in [
      '/home',
      '/catalog',
      '/saved',
      '/profile',
      '/product/iphone-17-pro',
      '/product/iphone-17-pro/configure',
    ]) {
      appRouter.go(route);
      await tester.pumpWidget(const ProviderScope(child: AppleStoreApp()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  testWidgets('one-item Cart fits a 360px portrait viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    appRouter.go('/cart');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cartProvider.overrideWith(_SeededCartController.new)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('iPhone 17 Pro'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('simulated checkout completes all four steps', (tester) async {
    appRouter.go('/checkout');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cartProvider.overrideWith(_SeededCartController.new)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Shipping'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout_continue')));
    await tester.pumpAndSettle();
    expect(find.text('Delivery'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout_continue')));
    await tester.pumpAndSettle();
    expect(find.text('Payment'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout_continue')));
    await tester.pumpAndSettle();
    expect(find.text('Review'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checkout_continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('checkout_confirmation')), findsOneWidget);
  });
}

class _ReducedMotionTestController extends ReducedMotionController {
  @override
  ReducedMotionState build() => const ReducedMotionState(override: true);
}

class _SeededCartController extends CartController {
  @override
  List<CartItem> build() => const [
    CartItem(
      productId: 'iphone-17-pro',
      name: 'iPhone 17 Pro',
      finish: 'Silver',
      selectedOptions: {'storage': '128 GB'},
      unitPrice: 1099,
      variantId: 'iphone-17-pro-red',
      imagePath: 'assets/products/iphone/iphone-17-pro_red.png',
    ),
  ];
}
