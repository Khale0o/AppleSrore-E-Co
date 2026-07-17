import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../cart/presentation/cart_badge.dart';
import '../../cart/presentation/cart_state.dart';
import '../../home/presentation/home_products.dart';

class ProductConfigurationPlaceholderPage extends ConsumerStatefulWidget {
  const ProductConfigurationPlaceholderPage({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  ConsumerState<ProductConfigurationPlaceholderPage> createState() =>
      _ConfigState();
}

class _ConfigState extends ConsumerState<ProductConfigurationPlaceholderPage> {
  int finish = 0, config = 0;
  bool showing = false;
  @override
  Widget build(BuildContext c) {
    final p = productForIdOrNull(widget.productId);
    if (p == null) {
      return const Scaffold(body: Center(child: Text('PRODUCT UNAVAILABLE')));
    }
    return Scaffold(
      backgroundColor: p.start,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => c.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  const CartBadge(),
                ],
              ),
              Expanded(
                child: Center(
                  child: Hero(
                    tag: p.heroTag,
                    child: Image.asset(
                      p.assetPath,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_outlined,
                        color: Colors.white38,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Configure ${p.name}',
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
              Wrap(
                children: List.generate(
                  p.finishes.length,
                  (i) => ChoiceChip(
                    label: Text(p.finishes[i]),
                    selected: finish == i,
                    onSelected: (_) => setState(() => finish = i),
                  ),
                ),
              ),
              Wrap(
                children: List.generate(
                  p.configurations.length,
                  (i) => ChoiceChip(
                    label: Text(p.configurations[i]),
                    selected: config == i,
                    onSelected: (_) => setState(() => config = i),
                  ),
                ),
              ),
              FilledButton(
                key: const Key('add_to_bag'),
                onPressed: () => _add(c, p),
                child: Text('Add to Bag \$${p.basePrice + config * 100}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _add(BuildContext c, HomeProduct p) {
    ref
        .read(cartProvider.notifier)
        .add(
          CartItem(
            productId: p.id,
            name: p.name,
            finish: p.finishes[finish],
            storage: p.configurations[config],
            unitPrice: p.basePrice + config * 100,
          ),
        );
    if (showing) return;
    showing = true;
    showModalBottomSheet<void>(
      context: c,
      builder: (c) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Added to Bag'),
            Text(p.name),
            TextButton(
              onPressed: () => c.goNamed(AppRoutes.cart),
              child: const Text('Open Cart'),
            ),
          ],
        ),
      ),
    ).whenComplete(() => showing = false);
  }
}
