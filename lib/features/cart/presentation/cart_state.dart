import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.name,
    required this.finish,
    required this.storage,
    required this.unitPrice,
    this.variantId = 'default',
    this.imagePath = '',
    this.quantity = 1,
  });
  final String productId, name, finish, storage;
  final String variantId, imagePath;
  final int unitPrice, quantity;
  String get key => '$productId|$variantId|$finish|$storage';
  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    name: name,
    finish: finish,
    storage: storage,
    unitPrice: unitPrice,
    variantId: variantId,
    imagePath: imagePath,
    quantity: quantity ?? this.quantity,
  );
}

class CartController extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];
  void add(CartItem item) {
    final i = state.indexWhere((e) => e.key == item.key);
    state = i < 0
        ? [...state, item]
        : [
            for (var n = 0; n < state.length; n++)
              n == i
                  ? state[n].copyWith(quantity: state[n].quantity + 1)
                  : state[n],
          ];
  }

  void change(CartItem item, int delta) {
    final next = item.quantity + delta;
    state = next <= 0
        ? state.where((e) => e.key != item.key).toList()
        : [
            for (final e in state)
              e.key == item.key ? e.copyWith(quantity: next) : e,
          ];
  }

  void remove(CartItem item) =>
      state = state.where((e) => e.key != item.key).toList();
  void clear() => state = [];
  int get count => state.fold(0, (v, e) => v + e.quantity);
  int get subtotal => state.fold(0, (v, e) => v + e.unitPrice * e.quantity);
}

final cartProvider = NotifierProvider<CartController, List<CartItem>>(
  CartController.new,
);
final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).fold(0, (v, e) => v + e.quantity),
);
final cartSubtotalProvider = Provider<int>(
  (ref) =>
      ref.watch(cartProvider).fold(0, (v, e) => v + e.unitPrice * e.quantity),
);
