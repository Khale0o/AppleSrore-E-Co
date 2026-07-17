import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../cart/presentation/cart_badge.dart';
import '../../home/presentation/home_products.dart';

class ProductDetailsPlaceholderPage extends StatelessWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext c) {
    final p = productForIdOrNull(productId);
    if (p == null) {
      return const Scaffold(body: Center(child: Text('PRODUCT UNAVAILABLE')));
    }
    final related = homeProducts
        .where((x) => x.category == p.category && x.id != p.id)
        .take(3);
    return Scaffold(
      backgroundColor: p.start,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => c.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    const CartBadge(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: p.heroTag,
                        child: SizedBox(
                          height: 260,
                          child: Image.asset(
                            p.assetPath,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white38,
                                  size: 100,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      p.category.label.toUpperCase(),
                      style: TextStyle(color: p.accent, letterSpacing: 2),
                    ),
                    Text(
                      p.name,
                      style: const TextStyle(color: Colors.white, fontSize: 38),
                    ),
                    Text(
                      p.tagline,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(p.price, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    ...p.features.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '— $f',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: p.finishes
                          .map((f) => Chip(label: Text(f)))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => c.pushNamed(
                        AppRoutes.configure,
                        pathParameters: {'productId': p.id},
                      ),
                      child: const Text('Configure'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'More ${p.category.label}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: related
                      .map(
                        (x) => TextButton(
                          onPressed: () => c.pushNamed(
                            AppRoutes.product,
                            pathParameters: {'productId': x.id},
                          ),
                          child: Text(x.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
