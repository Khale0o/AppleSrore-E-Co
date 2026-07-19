import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../home/presentation/home_products.dart';
import 'cart_state.dart';

class CartPlaceholderPage extends ConsumerWidget {
  const CartPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final estimatedTax = items.isEmpty ? 0 : (subtotal * 0.07).round();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: items.isEmpty
            ? _EmptyCart(onExplore: () => context.goNamed(AppRoutes.catalog))
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your Cart',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Dismissible(
                          key: ValueKey(item.key),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) =>
                              ref.read(cartProvider.notifier).remove(item),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            decoration: BoxDecoration(
                              color: StoreColors.red,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                            ),
                          ),
                          child: _CartLine(
                            item: item,
                            onDecrease: () => ref
                                .read(cartProvider.notifier)
                                .change(item, -1),
                            onIncrease: () =>
                                ref.read(cartProvider.notifier).change(item, 1),
                            onRemove: () =>
                                ref.read(cartProvider.notifier).remove(item),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    sliver: SliverToBoxAdapter(
                      child: _OrderSummary(
                        subtotal: subtotal,
                        estimatedTax: estimatedTax,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });
  final CartItem item;
  final VoidCallback onDecrease, onIncrease, onRemove;
  @override
  Widget build(BuildContext context) {
    final product = productForIdOrNull(item.productId);
    final path = item.imagePath.isNotEmpty
        ? item.imagePath
        : (product?.assetPath ?? '');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 88,
              height: 108,
              child: ProductImage(path: path, label: item.name),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Remove',
                        onPressed: onRemove,
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
                    ],
                  ),
                  Text('${item.finish} / ${item.storage}'),
                  const SizedBox(height: 8),
                  Text(
                    formatUsd(item.unitPrice),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: StoreColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: onDecrease,
                          icon: const Icon(Icons.remove_rounded, size: 18),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 140),
                          child: Text(
                            '${item.quantity}',
                            key: ValueKey(item.quantity),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: onIncrease,
                          icon: const Icon(Icons.add_rounded, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.subtotal, required this.estimatedTax});
  final int subtotal, estimatedTax;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: formatUsd(subtotal)),
          const SizedBox(height: 10),
          const _SummaryRow(label: 'Shipping', value: 'Free'),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Estimated Tax', value: formatUsd(estimatedTax)),
          const Divider(height: 26),
          _SummaryRow(
            label: 'Total',
            value: formatUsd(subtotal + estimatedTax),
            emphasized: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock_outline_rounded),
              label: const Text('Checkout — UI Only'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label, value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
            fontSize: emphasized ? 18 : 14,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
          fontSize: emphasized ? 18 : 14,
        ),
      ),
    ],
  );
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Cart', style: Theme.of(context).textTheme.displaySmall),
        const Spacer(),
        const Center(
          child: Column(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 64),
              SizedBox(height: 14),
              Text('Your bag is ready for something great.'),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onExplore,
            child: const Text('Explore products'),
          ),
        ),
      ],
    ),
  );
}
