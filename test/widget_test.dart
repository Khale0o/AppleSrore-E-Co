import 'package:applestore/features/cart/presentation/cart_state.dart';
import 'package:applestore/features/home/presentation/home_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
