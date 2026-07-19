import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/product_image.dart';
import '../../home/presentation/home_products.dart';

class CatalogPlaceholderPage extends StatefulWidget {
  const CatalogPlaceholderPage({super.key});

  @override
  State<CatalogPlaceholderPage> createState() => _CatalogState();
}

class _CatalogState extends State<CatalogPlaceholderPage> {
  ProductCategory? category;
  String query = '';
  int sort = 0;

  @override
  Widget build(BuildContext context) {
    final products = homeProducts
        .where(
          (product) =>
              (category == null || product.category == category) &&
              product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (sort == 1) {
      products.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    }
    if (sort == 2) {
      products.sort((a, b) => b.basePrice.compareTo(a.basePrice));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050609),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COLLECTION',
                      style: TextStyle(
                        color: Color(0xFF9EDDF8),
                        letterSpacing: 2,
                        fontSize: 11,
                      ),
                    ),
                    const Text(
                      'Find your frame.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextField(
                      key: const Key('catalog_search'),
                      onChanged: (value) => setState(() => query = value),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Search the collection',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => setState(() => category = null),
                            child: Text(
                              'All',
                              style: TextStyle(
                                decoration: category == null
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                          ...ProductCategory.values.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => category = item),
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: category == item
                                        ? Colors.white
                                        : Colors.white54,
                                    decoration: category == item
                                        ? TextDecoration.underline
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${products.length} products',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const Spacer(),
                        DropdownButton<int>(
                          value: sort,
                          onChanged: (value) => setState(() => sort = value!),
                          items: const [
                            DropdownMenuItem(value: 0, child: Text('Featured')),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 60),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _CatalogTile(
                      product: products[index],
                      wide: index == 0,
                    ),
                  ),
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.product, required this.wide});

  final HomeProduct product;
  final bool wide;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.pushNamed(
      AppRoutes.product,
      pathParameters: {'productId': product.id},
    ),
    child: Container(
      height: wide ? 265 : 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: wide ? const Color(0xFF141A22) : const Color(0xFF0D0F14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: wide ? 6 : 4,
            child: ProductImage(
              path: product.assetPath,
              label: product.name,
              heroTag: product.heroTag,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.label.toUpperCase(),
                  style: TextStyle(
                    color: product.accent,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: wide ? 24 : 17,
                  ),
                ),
                Text(
                  product.price,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
