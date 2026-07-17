import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
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
    var products = homeProducts
        .where(
          (p) =>
              (category == null || p.category == category) &&
              p.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (sort == 1) products.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    if (sort == 2) products.sort((a, b) => b.basePrice.compareTo(a.basePrice));
    return Scaffold(
      backgroundColor: const Color(0xFF07090D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COLLECTION',
                    style: TextStyle(color: Colors.white, letterSpacing: 2),
                  ),
                  const Text(
                    'The connected edit.',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  TextField(
                    key: const Key('catalog_search'),
                    onChanged: (v) => setState(() => query = v),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search products',
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => category = null),
                          child: const Text('All'),
                        ),
                        ...ProductCategory.values.map(
                          (c) => FilterChip(
                            label: Text(c.label),
                            selected: category == c,
                            onSelected: (_) => setState(() => category = c),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${products.length} products',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const Spacer(),
                      DropdownButton<int>(
                        value: sort,
                        onChanged: (v) => setState(() => sort = v!),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Featured')),
                          DropdownMenuItem(value: 1, child: Text('Price: low')),
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
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 320,
                            mainAxisExtent: 220,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemCount: products.length,
                      itemBuilder: (c, i) => _Tile(p: products[i]),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Unofficial portfolio concept. Product names and imagery belong to their respective owners.',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.p});
  final HomeProduct p;
  @override
  Widget build(BuildContext c) => InkWell(
    onTap: () =>
        c.pushNamed(AppRoutes.product, pathParameters: {'productId': p.id}),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.end,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: p.heroTag,
              child: Image.asset(
                p.assetPath,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white38,
                    size: 55,
                  ),
                ),
              ),
            ),
          ),
          Text(
            p.category.label.toUpperCase(),
            style: TextStyle(color: p.accent, fontSize: 11),
          ),
          Text(
            p.name,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            p.price,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}
