import 'dart:io';

import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:applestore/core/accessibility/reduced_motion_controller.dart';
import 'package:applestore/features/cart/presentation/cart_state.dart';
import 'package:applestore/features/home/presentation/home_products.dart';
import 'package:applestore/features/onboarding/application/onboarding_store.dart';
import 'package:applestore/features/product_details/presentation/product_variants.dart';
import 'package:applestore/features/saved/presentation/saved_state.dart';
import 'package:applestore/shared/widgets/product_image.dart';
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
    expect(find.text('iPad Air'), findsWidgets);
    expect(find.byKey(const Key('details_add_to_bag')), findsOneWidget);
    expect(find.text('Add to Bag'), findsOneWidget);
    expect(find.text('Configure'), findsNothing);
  });

  testWidgets('Details selection reaches Saved and Cart exactly', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    appRouter.go('/product/iphone-17-pro');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();

    final blueFinish = find.byKey(const Key('finish-iphone-17-pro-blue'));
    await tester.ensureVisible(blueFinish);
    await tester.pumpAndSettle();
    await tester.tap(blueFinish);
    final storage = find.byKey(const Key('option-storage-256gb'));
    await tester.ensureVisible(storage);
    await tester.pumpAndSettle();
    await tester.tap(storage);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ProductImage &&
            widget.path == 'assets/products/iphone/iphone-17-pro_blue.png',
      ),
      findsWidgets,
    );

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pumpAndSettle();
    final saved = container.read(savedProvider).single;
    expect(saved.variantId, 'iphone-17-pro-blue');
    expect(saved.optionValueIds['storage'], '256gb');
    expect(saved.imagePath, 'assets/products/iphone/iphone-17-pro_blue.png');

    await tester.tap(find.byKey(const Key('details_add_to_bag')));
    await tester.pumpAndSettle();
    final cartItem = container.read(cartProvider).single;
    expect(cartItem.variantId, 'iphone-17-pro-blue');
    expect(cartItem.selectedOptions, {'storage': '256 GB'});
    expect(cartItem.imagePath, 'assets/products/iphone/iphone-17-pro_blue.png');
    expect(cartItem.unitPrice, 1199);
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
    expect(find.text('Finish'), findsNothing);
    expect(find.text('Storage'), findsNothing);
    expect(find.text('Size'), findsNothing);
    expect(find.text('Compatibility'), findsOneWidget);
  });

  testWidgets('AirPods Details never add storage options', (tester) async {
    await pumpRoute(tester, '/product/airpods-pro-3');
    expect(find.text('Ear Tip Size'), findsOneWidget);
    expect(find.text('Storage'), findsNothing);
    expect(find.textContaining('GB'), findsNothing);
  });

  testWidgets('each category renders its own specification groups', (
    tester,
  ) async {
    for (final id in [
      'iphone-17-pro',
      'macbook-pro-14',
      'ipad-air',
      'watch-series-11',
      'airpods-pro-3',
      'magic-keyboard',
    ]) {
      final product = productForId(id);
      await pumpRoute(tester, '/product/$id');
      expect(find.text('Specifications'), findsOneWidget, reason: id);
      expect(
        find.text(product.specificationGroups.first.title),
        findsOneWidget,
        reason: id,
      );
    }
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

  test('all products expose distinct content and category specifications', () {
    expect(
      homeProducts.map((product) => product.longDescription).toSet(),
      hasLength(homeProducts.length),
    );
    for (final product in homeProducts) {
      expect(product.features, isNotEmpty, reason: product.id);
      expect(product.specificationGroups, isNotEmpty, reason: product.id);
      expect(
        product.specificationGroups.expand((group) => group.entries.entries),
        isNotEmpty,
        reason: product.id,
      );
      expect(product.includedItems, isNotEmpty, reason: product.id);
    }
    expect(
      productForId(
        'iphone-17-pro',
      ).specificationGroups.expand((group) => group.entries.keys),
      containsAll(['Display', 'Chip', 'Cameras', 'Battery', 'Connectivity']),
    );
    expect(
      productForId(
        'macbook-pro-14',
      ).specificationGroups.expand((group) => group.entries.keys),
      containsAll(['Chip', 'Memory', 'Storage', 'Display', 'Ports', 'Battery']),
    );
    expect(
      productForId(
        'airpods-pro-3',
      ).specificationGroups.expand((group) => group.entries.keys),
      containsAll(['Audio', 'Noise control', 'Listening time', 'Fit']),
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

  testWidgets('Reduced Motion preserves Details selection and purchase', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        reducedMotionControllerProvider.overrideWith(
          _ReducedMotionTestController.new,
        ),
      ],
    );
    addTearDown(container.dispose);
    appRouter.go('/product/iphone-17');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    final storage = find.byKey(const Key('option-storage-256gb'));
    await tester.ensureVisible(storage);
    await tester.pumpAndSettle();
    await tester.tap(storage);
    await tester.pump();
    await tester.tap(find.byKey(const Key('details_add_to_bag')));
    await tester.pump();
    expect(container.read(cartProvider).single.selectedOptions, {
      'storage': '256 GB',
    });
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
      '/onboarding?preview=true',
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

  testWidgets('Cart opens the simulated checkout journey', (tester) async {
    appRouter.go('/cart');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cartProvider.overrideWith(_SeededCartController.new)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('start_checkout')));
    await tester.pumpAndSettle();
    expect(find.text('Shipping'), findsOneWidget);
    expect(find.text('Preview checkout'), findsOneWidget);
  });

  testWidgets('first launch routes Splash to Onboarding', (tester) async {
    final store = _MemoryOnboardingStore();
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();
    expect(find.text('Everything you love.\nIn one place.'), findsOneWidget);
    expect(store.completed, isFalse);
  });

  testWidgets('completed onboarding routes Splash directly Home', (
    tester,
  ) async {
    final store = _MemoryOnboardingStore(completed: true);
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();
    expect(find.text('AppleStore Concept'), findsOneWidget);
    expect(find.text('Everything you love.\nIn one place.'), findsNothing);
  });

  testWidgets('Skip completes onboarding and Home does not reopen it', (
    tester,
  ) async {
    final store = _MemoryOnboardingStore();
    appRouter.go('/onboarding');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();
    expect(store.completed, isTrue);
    expect(store.writes, 1);
    expect(find.text('AppleStore Concept'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Everything you love.\nIn one place.'), findsNothing);
  });

  testWidgets('Back, Next, and Start exploring control onboarding', (
    tester,
  ) async {
    final store = _MemoryOnboardingStore();
    appRouter.go('/onboarding');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(find.text('Choose every detail.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('onboarding_back')));
    await tester.pumpAndSettle();
    expect(find.text('Everything you love.\nIn one place.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(find.text('From discovery\nto delivery.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('onboarding_start')));
    await tester.tap(find.byKey(const Key('onboarding_start')));
    await tester.pumpAndSettle();
    expect(store.writes, 1);
    expect(find.text('AppleStore Concept'), findsOneWidget);
  });

  testWidgets('Profile opens onboarding for manual replay', (tester) async {
    final store = _MemoryOnboardingStore(completed: true);
    appRouter.go('/profile');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('View onboarding'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('View onboarding'));
    await tester.pumpAndSettle();
    expect(find.text('Everything you love.\nIn one place.'), findsOneWidget);
  });

  testWidgets('Reduced Motion onboarding works at narrow mobile width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = _MemoryOnboardingStore();
    appRouter.go('/onboarding');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingStoreProvider.overrideWithValue(store),
          reducedMotionControllerProvider.overrideWith(
            _ReducedMotionTestController.new,
          ),
        ],
        child: const AppleStoreApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('onboarding_start')));
    await tester.pumpAndSettle();
    expect(store.completed, isTrue);
    expect(find.text('AppleStore Concept'), findsOneWidget);
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

class _MemoryOnboardingStore implements OnboardingStore {
  _MemoryOnboardingStore({this.completed = false});
  bool completed;
  int writes = 0;

  @override
  Future<void> complete() async {
    writes++;
    completed = true;
  }

  @override
  Future<bool> isComplete() async => completed;
}
