import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../home/presentation/home_products.dart';
import 'saved_state.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});
  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(savedProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Saved',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _SavedTab(
                      label: 'Products',
                      selected: tab == 0,
                      onTap: () => setState(() => tab = 0),
                    ),
                  ),
                  Expanded(
                    child: _SavedTab(
                      label: 'Collections',
                      selected: tab == 1,
                      onTap: () => setState(() => tab = 1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: tab == 1
                    ? const _CollectionsEmpty(key: ValueKey('collections'))
                    : items.isEmpty
                    ? const _SavedEmpty(key: ValueKey('empty'))
                    : ListView.separated(
                        key: ValueKey('saved-${items.length}'),
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final saved = items[index];
                          final product = productForIdOrNull(saved.productId);
                          if (product == null) return const SizedBox.shrink();
                          return _SavedProductRow(
                            product: product,
                            saved: saved,
                            onRemove: () =>
                                ref.read(savedProvider.notifier).remove(saved),
                            onOpen: () => context.pushNamed(
                              AppRoutes.product,
                              pathParameters: {'productId': product.id},
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTab extends StatelessWidget {
  const _SavedTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected ? StoreColors.red : StoreColors.line,
            width: selected ? 2 : 1,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? StoreColors.red : StoreColors.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _SavedProductRow extends StatelessWidget {
  const _SavedProductRow({
    required this.product,
    required this.saved,
    required this.onRemove,
    required this.onOpen,
  });
  final HomeProduct product;
  final SavedItem saved;
  final VoidCallback onRemove, onOpen;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 92,
              height: 100,
              child: ProductImage(path: saved.imagePath, label: product.name),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(saved.variantName),
                  const SizedBox(height: 12),
                  Text(
                    formatUsd(product.basePrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: StoreColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove from Saved',
              onPressed: onRemove,
              icon: const Icon(Icons.favorite_rounded, color: StoreColors.red),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SavedEmpty extends StatelessWidget {
  const _SavedEmpty({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite_border_rounded, size: 58, color: StoreColors.muted),
        SizedBox(height: 14),
        Text('Save products to compare them here.'),
      ],
    ),
  );
}

class _CollectionsEmpty extends StatelessWidget {
  const _CollectionsEmpty({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.collections_bookmark_outlined, size: 58),
        SizedBox(height: 14),
        Text('Collections are a UI-only preview.'),
      ],
    ),
  );
}
