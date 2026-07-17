import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import 'cart_state.dart';

class CartBadge extends ConsumerWidget {
  const CartBadge({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final count = r.watch(cartCountProvider);
    return IconButton(
      key: const Key('cart_badge'),
      onPressed: () => c.goNamed(AppRoutes.cart),
      color: Colors.white,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
