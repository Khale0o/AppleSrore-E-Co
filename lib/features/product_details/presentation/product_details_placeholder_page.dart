import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../cart/presentation/cart_state.dart';
import '../../home/presentation/home_products.dart';
import '../../saved/presentation/saved_state.dart';
import 'product_option_selectors.dart';
import 'product_variants.dart';

class ProductDetailsPlaceholderPage extends ConsumerWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = productForIdOrNull(productId);
    if (product == null) return const _ProductUnavailable();

    ref.watch(productSelectionsProvider);
    final selections = ref.read(productSelectionsProvider.notifier);
    final selection = selections.forProduct(product);
    final variants = variantsFor(product);
    final variant = variants.firstWhere(
      (item) => item.id == selection.variantId,
      orElse: () => variants.first,
    );
    final saved = ref
        .watch(savedProvider)
        .any(
          (item) =>
              item.productId == product.id && item.variantId == variant.id,
        );
    final reduced = ref.watch(reducedMotionProvider);
    final price =
        product.basePrice +
        variant.priceAdjustment +
        selectedOptionsPriceAdjustment(product, selection);
    final related = homeProducts
        .where(
          (item) => item.category == product.category && item.id != product.id,
        )
        .take(4)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: StoreColors.background,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          FavoriteButton(
            selected: saved,
            onPressed: () => ref
                .read(savedProvider.notifier)
                .toggle(
                  SavedItem(
                    productId: product.id,
                    variantId: variant.id,
                    variantName: variant.displayName,
                    imagePath: variant.imagePath,
                    optionValueIds: selection.optionValueIds,
                    optionLabels: selectedOptionsForCart(product, selection),
                    price: price,
                  ),
                ),
          ),
          IconButton(
            tooltip: 'Share',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product ready to share.')),
            ),
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 330,
                          child: Hero(
                            tag: product.heroTag,
                            child: AnimatedSwitcher(
                              duration: Duration(
                                milliseconds: reduced ? 80 : 220,
                              ),
                              child: StoreProductImageStage(
                                key: ValueKey('${product.id}-${variant.id}'),
                                product: product,
                                imagePath: variant.imagePath,
                                background: Colors.white,
                                padding: const EdgeInsets.all(28),
                              ),
                            ),
                          ),
                        ),
                        if (variants.length > 1) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 62,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: variants.length,
                              itemBuilder: (context, index) {
                                final item = variants[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    onTap: () =>
                                        selections.setVariant(product, item.id),
                                    child: Container(
                                      width: 62,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: item.id == variant.id
                                              ? StoreColors.red
                                              : StoreColors.line,
                                          width: item.id == variant.id ? 2 : 1,
                                        ),
                                      ),
                                      child: ProductImage(
                                        path: item.imagePath,
                                        label:
                                            '${product.name} ${item.displayName}',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          product.category.label,
                          style: const TextStyle(
                            color: StoreColors.red,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 10),
                        const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 4,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star_half_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text('4.8 · 2.3k reviews'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          formatUsd(price),
                          style: const TextStyle(
                            color: StoreColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(product.description),
                        const SizedBox(height: 22),
                        if (variants.length > 1) ...[
                          Text(
                            'Finish',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: variants
                                .map(
                                  (item) => ChoiceChip(
                                    label: Text(item.displayName),
                                    avatar: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: item.swatch,
                                    ),
                                    selected: item.id == variant.id,
                                    onSelected: (_) =>
                                        selections.setVariant(product, item.id),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                        ],
                        ProductOptionSelectors(
                          product: product,
                          selection: selection,
                          onSelected: (groupId, valueId) =>
                              selections.setOption(product, groupId, valueId),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'About this product',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        ...product.features.map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: StoreColors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(feature)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            key: const Key('details_add_to_cart'),
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .add(
                                    CartItem(
                                      productId: product.id,
                                      name: product.name,
                                      finish: variant.displayName,
                                      selectedOptions: selectedOptionsForCart(
                                        product,
                                        selection,
                                      ),
                                      unitPrice: price,
                                      variantId: variant.id,
                                      imagePath: variant.imagePath,
                                    ),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to bag')),
                              );
                            },
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: const Text('Add to Cart'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => context.pushNamed(
                              AppRoutes.configure,
                              pathParameters: {'productId': product.id},
                            ),
                            child: const Text('Configure'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const StoreSectionHeader(title: 'Related products'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: related.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final item = related[index];
                              return SizedBox(
                                width: 144,
                                child: Card(
                                  child: InkWell(
                                    onTap: () => context.pushNamed(
                                      AppRoutes.product,
                                      pathParameters: {'productId': item.id},
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ProductImage(
                                              path: item.assetPath,
                                              label: item.name,
                                            ),
                                          ),
                                          Text(
                                            item.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductUnavailable extends StatelessWidget {
  const _ProductUnavailable();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 56),
            const SizedBox(height: 12),
            const Text('PRODUCT UNAVAILABLE'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.goNamed(AppRoutes.home),
              child: const Text('Back Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
