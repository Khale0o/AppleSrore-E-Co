import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';
import 'cart_state.dart';

class CartPlaceholderPage extends ConsumerWidget {
  const CartPlaceholderPage({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final items = r.watch(cartProvider);
    final subtotal = r.watch(cartSubtotalProvider);
    if (items.isEmpty) {
      return AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text('YOUR BAG IS QUIET', style: AppTypography.label),
            const SizedBox(height: 12),
            const Text('Nothing selected yet.', style: AppTypography.headline),
            const Spacer(),
            AppTextButton(
              label: 'Continue Exploring',
              onPressed: () => c.goNamed(AppRoutes.home),
            ),
          ],
        ),
      );
    }
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BAG', style: AppTypography.label),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: items
                  .map(
                    (i) => ListTile(
                      title: Text(i.name),
                      subtitle: Text('${i.finish} · ${i.storage}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                r.read(cartProvider.notifier).change(i, -1),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${i.quantity}'),
                          IconButton(
                            onPressed: () =>
                                r.read(cartProvider.notifier).change(i, 1),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () =>
                                r.read(cartProvider.notifier).remove(i),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Text('Subtotal  $subtotal', style: AppTypography.title),
          AppTextButton(
            label: 'Continue Exploring',
            onPressed: () => c.goNamed(AppRoutes.home),
          ),
          const Text('Checkout unavailable', style: AppTypography.caption),
        ],
      ),
    );
  }
}
