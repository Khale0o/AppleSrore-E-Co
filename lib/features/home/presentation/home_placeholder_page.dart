import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../cart/presentation/cart_badge.dart';
import 'home_products.dart';

class HomePlaceholderPage extends ConsumerStatefulWidget {
  const HomePlaceholderPage({super.key});

  @override
  ConsumerState<HomePlaceholderPage> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePlaceholderPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _entranceController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (!mounted) return;
        setState(() => _scrollOffset = _scrollController.offset);
      });
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(reducedMotionProvider)) {
        _entranceController.value = 1;
      } else {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = homeProducts.first;
    final featured = homeProducts.where((item) => item.featured).toList();
    final reduced = ref.watch(reducedMotionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050609),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Text(
                      'APPLestore',
                      style: TextStyle(color: Colors.white, letterSpacing: 2),
                    ),
                    const Spacer(),
                    const CartBadge(),
                    Switch(
                      key: const Key('reduced_motion_toggle'),
                      value: reduced,
                      onChanged: (_) => ref
                          .read(reducedMotionControllerProvider.notifier)
                          .toggleDevelopmentOverride(),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _Hero(
                product: product,
                scrollOffset: _scrollOffset,
                reduced: reduced,
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionReveal(
                animation: _entranceController,
                index: 0,
                reduced: reduced,
                child: _CategoryRail(
                  onTap: () => context.pushNamed(AppRoutes.catalog),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionReveal(
                animation: _entranceController,
                index: 1,
                reduced: reduced,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 42, 24, 16),
                  child: Text(
                    'Selected in context',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionReveal(
                animation: _entranceController,
                index: 2,
                reduced: reduced,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _WideProduct(product: featured[0]),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _SmallProduct(product: featured[1])),
                          const SizedBox(width: 14),
                          Expanded(child: _SmallProduct(product: featured[2])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionReveal(
                animation: _entranceController,
                index: 3,
                reduced: reduced,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 58, 24, 56),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10151C), Color(0xFF030405)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 18,
                          top: 20,
                          width: 105,
                          height: 175,
                          child: ProductImage(
                            path: homeProducts[0].assetPath,
                            label: homeProducts[0].name,
                          ),
                        ),
                        Positioned(
                          right: 14,
                          top: 42,
                          width: 190,
                          height: 120,
                          child: ProductImage(
                            path: homeProducts[6].assetPath,
                            label: homeProducts[6].name,
                          ),
                        ),
                        const Positioned(
                          left: 22,
                          bottom: 18,
                          child: Text(
                            'Everything, in concert.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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

class _Hero extends StatelessWidget {
  const _Hero({
    required this.product,
    required this.scrollOffset,
    required this.reduced,
  });

  final HomeProduct product;
  final double scrollOffset;
  final bool reduced;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 510,
    child: Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.55, -0.4),
                radius: 1.1,
                colors: [
                  Color(0xFF203044),
                  Color(0xFF080A0F),
                  Color(0xFF030405),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -25,
          top: 40,
          width: 270,
          height: 340,
          child: Transform.translate(
            offset: Offset(0, reduced ? 0 : scrollOffset * 0.18),
            child: ProductImage(
              path: product.assetPath,
              label: product.name,
              heroTag: product.heroTag,
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 32,
          child: Transform.translate(
            offset: Offset(0, reduced ? 0 : scrollOffset * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEW PERSPECTIVE',
                  style: TextStyle(
                    color: product.accent,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    height: 0.95,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.tagline,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => context.pushNamed(
                        AppRoutes.product,
                        pathParameters: {'productId': product.id},
                      ),
                      child: const Text('Explore'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => context.pushNamed(
                        AppRoutes.configure,
                        pathParameters: {'productId': product.id},
                      ),
                      child: const Text('Configure'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _SectionReveal extends StatelessWidget {
  const _SectionReveal({
    required this.animation,
    required this.index,
    required this.reduced,
    required this.child,
  });

  final Animation<double> animation;
  final int index;
  final bool reduced;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (reduced) return child;
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final start = index * 0.12;
        final value = CurvedAnimation(
          parent: animation,
          curve: Interval(
            start,
            (start + 0.58).clamp(0, 1),
            curve: Curves.easeOutCubic,
          ),
        ).value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    child: Row(
      children: ProductCategory.values
          .map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 24),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: category == ProductCategory.iphone
                      ? Colors.white
                      : Colors.white54,
                ),
                onPressed: onTap,
                child: Text(
                  category.label,
                  style: TextStyle(
                    decoration: category == ProductCategory.iphone
                        ? TextDecoration.underline
                        : null,
                    decorationColor: const Color(0xFF9EDDF8),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _WideProduct extends StatelessWidget {
  const _WideProduct({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) =>
      _EditorialProduct(product: product, height: 275, wide: true);
}

class _SmallProduct extends StatelessWidget {
  const _SmallProduct({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) =>
      _EditorialProduct(product: product, height: 215);
}

class _EditorialProduct extends StatelessWidget {
  const _EditorialProduct({
    required this.product,
    required this.height,
    this.wide = false,
  });

  final HomeProduct product;
  final double height;
  final bool wide;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.pushNamed(
      AppRoutes.product,
      pathParameters: {'productId': product.id},
    ),
    child: Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: wide ? const Color(0xFF121820) : const Color(0xFF0B0D12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ProductImage(path: product.assetPath, label: product.name),
          ),
          Text(
            product.category.label.toUpperCase(),
            style: TextStyle(
              color: product.accent,
              fontSize: 10,
              letterSpacing: 1.3,
            ),
          ),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: wide ? 22 : 15),
          ),
        ],
      ),
    ),
  );
}
