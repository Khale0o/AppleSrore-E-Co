import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_motion.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import 'home_products.dart';
import 'production_phone_render.dart';

class HomePlaceholderPage extends ConsumerStatefulWidget {
  const HomePlaceholderPage({super.key});

  @override
  ConsumerState<HomePlaceholderPage> createState() =>
      _HomePlaceholderPageState();
}

class _HomePlaceholderPageState extends ConsumerState<HomePlaceholderPage> {
  late final PageController _controller;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _selected) return;
    _controller.animateToPage(
      index,
      duration: AppMotion.emphasis,
      curve: Curves.easeOutCubic,
    );
  }

  void _openProduct(HomeProduct product) {
    context.pushNamed(
      AppRoutes.product,
      pathParameters: {'productId': product.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    final selected = homeProducts[_selected];
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final page = _controller.hasClients
              ? (_controller.page ?? _selected.toDouble())
              : _selected.toDouble();
          final low = page.floor().clamp(0, homeProducts.length - 1);
          final high = page.ceil().clamp(0, homeProducts.length - 1);
          final amount = (page - low).clamp(0.0, 1.0);
          final start = Color.lerp(
            homeProducts[low].start,
            homeProducts[high].start,
            amount,
          )!;
          final end = Color.lerp(
            homeProducts[low].end,
            homeProducts[high].end,
            amount,
          )!;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [start, end],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    reduced: reduced,
                    onBag: () => context.goNamed(AppRoutes.cart),
                    onToggle: () => ref
                        .read(reducedMotionControllerProvider.notifier)
                        .toggleDevelopmentOverride(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                    child: _ProductCopy(product: selected),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: homeProducts.length,
                      onPageChanged: (index) =>
                          setState(() => _selected = index),
                      itemBuilder: (context, index) => _CarouselProduct(
                        controller: _controller,
                        product: homeProducts[index],
                        index: index,
                        reduced: reduced,
                        onOpen: () => _openProduct(homeProducts[index]),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('explore_action'),
                    onPressed: () => _openProduct(selected),
                    icon: const Icon(Icons.north_east_rounded),
                    label: const Text('Explore'),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                  _Indicator(
                    selected: _selected,
                    accent: selected.accent,
                    onSelect: _select,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.reduced,
    required this.onBag,
    required this.onToggle,
  });
  final bool reduced;
  final VoidCallback onBag;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 14, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'AETHER',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 3,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            IconButton(
              tooltip: 'Bag',
              onPressed: onBag,
              color: Colors.white,
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
            Switch(
              key: const Key('reduced_motion_toggle'),
              value: reduced,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ProductCopy extends StatelessWidget {
  const _ProductCopy({required this.product});
  final HomeProduct product;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: AppMotion.standard,
    child: Column(
      key: ValueKey(product.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          product.finish.toUpperCase(),
          style: TextStyle(
            color: product.accent,
            fontSize: 12,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.tagline,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .72),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${product.metadata} · ${product.price}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: .5),
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

class _CarouselProduct extends StatelessWidget {
  const _CarouselProduct({
    required this.controller,
    required this.product,
    required this.index,
    required this.reduced,
    required this.onOpen,
  });
  final PageController controller;
  final HomeProduct product;
  final int index;
  final bool reduced;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    child: Hero(
      key: Key('home_product_${product.id}'),
      tag: product.heroTag,
      child: ProductionPhoneRender(product: product),
    ),
    builder: (context, child) {
      final page = controller.hasClients
          ? (controller.page ?? controller.initialPage.toDouble())
          : controller.initialPage.toDouble();
      final delta = (page - index).clamp(-1.0, 1.0);
      final travel = reduced ? delta * 18 : delta * 72;
      return GestureDetector(
        onTap: delta.abs() < .08 ? onOpen : null,
        child: Center(
          child: Transform.translate(
            offset: Offset(-travel, reduced ? 0 : delta.abs() * 12),
            child: Transform.rotate(
              angle: reduced ? 0 : delta * math.pi / 60,
              child: Transform.scale(
                scale: reduced ? 1 : 1 - delta.abs() * .09,
                child: Opacity(
                  opacity: reduced ? 1 : 1 - delta.abs() * .25,
                  child: SizedBox(width: 220, child: child),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.selected,
    required this.accent,
    required this.onSelect,
  });
  final int selected;
  final Color accent;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      homeProducts.length,
      (index) => InkWell(
        key: Key('indicator_$index'),
        onTap: () => onSelect(index),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.all(7),
          height: 4,
          width: index == selected ? 32 : 10,
          decoration: BoxDecoration(
            color: index == selected
                ? accent
                : Colors.white.withValues(alpha: .28),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    ),
  );
}
