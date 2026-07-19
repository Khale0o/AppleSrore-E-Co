import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../home/presentation/home_products.dart';
import '../../product_details/presentation/product_variants.dart';
import '../../saved/presentation/saved_state.dart';

class CatalogPlaceholderPage extends ConsumerStatefulWidget {
  const CatalogPlaceholderPage({super.key});
  @override
  ConsumerState<CatalogPlaceholderPage> createState() => _CatalogState();
}

class _CatalogState extends ConsumerState<CatalogPlaceholderPage> {
  ProductCategory? category;
  String query = '';
  int sort = 0;

  List<HomeProduct> get products {
    final values = homeProducts
        .where(
          (product) =>
              (category == null || product.category == category) &&
              product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (sort == 1) values.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    if (sort == 2) values.sort((a, b) => b.basePrice.compareTo(a.basePrice));
    return values;
  }

  void _toggleSaved(HomeProduct product) {
    final variant = _selectedVariant(product);
    final selection = ref
        .read(productSelectionsProvider.notifier)
        .forProduct(product);
    ref
        .read(savedProvider.notifier)
        .toggle(
          SavedItem(
            productId: product.id,
            variantId: variant.id,
            variantName: variant.displayName,
            imagePath: variant.imagePath,
            optionValueIds: selection.optionValueIds,
            optionLabels: selectedOptionsForCart(product, selection),
            price: _selectedPrice(product),
          ),
        );
  }

  ProductVariant _selectedVariant(HomeProduct product) {
    final selection = ref
        .read(productSelectionsProvider.notifier)
        .forProduct(product);
    final variants = variantsFor(product);
    return variants.firstWhere(
      (variant) => variant.id == selection.variantId,
      orElse: () => variants.first,
    );
  }

  int _selectedPrice(HomeProduct product) {
    final selection = ref
        .read(productSelectionsProvider.notifier)
        .forProduct(product);
    return product.basePrice +
        _selectedVariant(product).priceAdjustment +
        selectedOptionsPriceAdjustment(product, selection);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products;
    final saved = ref.watch(savedProvider);
    ref.watch(productSelectionsProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 800 ? 3 : 2;
            final horizontal = constraints.maxWidth >= 700
                ? (constraints.maxWidth - 720) / 2 + 20
                : 20.0;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontal, 18, horizontal, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key('catalog_search'),
                                onChanged: (value) =>
                                    setState(() => query = value),
                                decoration: const InputDecoration(
                                  hintText: 'Search products',
                                  prefixIcon: Icon(Icons.search_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filledTonal(
                              tooltip: 'Filters',
                              onPressed: () {},
                              icon: const Icon(Icons.tune_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 52,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: horizontal),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryTab(
                          label: 'All',
                          selected: category == null,
                          onTap: () => setState(() => category = null),
                        ),
                        ...ProductCategory.values.map(
                          (item) => _CategoryTab(
                            label: item.label,
                            selected: category == item,
                            onTap: () => setState(() => category = item),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 18),
                  sliver: SliverToBoxAdapter(
                    child: _CatalogBanner(
                      product: homeProducts[2],
                      imagePath: _selectedVariant(homeProducts[2]).imagePath,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          '${filtered.length} products',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: sort,
                              isDense: true,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(12),
                              onChanged: (value) =>
                                  setState(() => sort = value!),
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('Featured'),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Price: low'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Price: high'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 52,
                            color: StoreColors.muted,
                          ),
                          SizedBox(height: 12),
                          Text('No products match your search.'),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      12,
                      horizontal,
                      28,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 260,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = filtered[index];
                        return StoreProductCard(
                          product: product,
                          imagePath: _selectedVariant(product).imagePath,
                          price: _selectedPrice(product),
                          saved: saved.any(
                            (item) => item.productId == product.id,
                          ),
                          onSaved: () => _toggleSaved(product),
                          onOpen: () => context.pushNamed(
                            AppRoutes.product,
                            pathParameters: {'productId': product.id},
                          ),
                        );
                      }, childCount: filtered.length),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? StoreColors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? StoreColors.red : StoreColors.muted,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

class _CatalogBanner extends StatelessWidget {
  const _CatalogBanner({required this.product, required this.imagePath});
  final HomeProduct product;
  final String imagePath;
  @override
  Widget build(BuildContext context) => Container(
    height: 166,
    padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
    decoration: BoxDecoration(
      color: StoreColors.ink,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SEASONAL EDIT',
                style: TextStyle(
                  color: StoreColors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'A curated lineup for work, play, and everything between.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 138,
          child: ProductImage(path: imagePath, label: product.name),
        ),
      ],
    ),
  );
}
