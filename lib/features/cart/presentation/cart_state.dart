import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.name,
    required this.finish,
    required this.unitPrice,
    this.selectedOptions = const {},
    this.variantId = 'default',
    this.imagePath = '',
    this.quantity = 1,
  });
  final String productId, name, finish;
  final String variantId, imagePath;
  final Map<String, String> selectedOptions;
  final int unitPrice, quantity;
  String get key {
    final entries = selectedOptions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final options = entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('|');
    return '$productId|$variantId|$options';
  }

  String get optionSummary =>
      [if (finish.isNotEmpty) finish, ...selectedOptions.values].join(' / ');

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    name: name,
    finish: finish,
    unitPrice: unitPrice,
    selectedOptions: selectedOptions,
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
