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

class ProductDetailsPlaceholderPage extends ConsumerStatefulWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailsPlaceholderPage> createState() =>
      _ProductDetailsState();
}

class _ProductDetailsState extends ConsumerState<ProductDetailsPlaceholderPage>
    with TickerProviderStateMixin {
  late final AnimationController _flightController;
  late final AnimationController _bagController;
  late final AnimationController _revealController;
  final _productKey = GlobalKey();
  final _bagKey = GlobalKey();
  OverlayEntry? _flightEntry;

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
    _bagController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 170),
    );
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    )..forward();
  }

  @override
  void dispose() {
    _flightEntry?.remove();
    _flightEntry = null;
    _flightController.dispose();
    _bagController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = productForIdOrNull(widget.productId);
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
    final optionLabels = selectedOptionsForCart(product, selection);
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
                    optionLabels: optionLabels,
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
          ScaleTransition(
            key: _bagKey,
            scale: Tween<double>(begin: 1, end: 1.12).animate(
              CurvedAnimation(parent: _bagController, curve: Curves.easeOut),
            ),
            child: IconButton(
              tooltip: 'Bag',
              onPressed: () => context.goNamed(AppRoutes.cart),
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
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
                        _Reveal(
                          animation: _revealController,
                          reduced: reduced,
                          start: 0,
                          end: 0.62,
                          child: SizedBox(
                            key: _productKey,
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
                                  background: Color.lerp(
                                    Colors.white,
                                    variant.swatch,
                                    0.08,
                                  )!,
                                  padding: const EdgeInsets.all(28),
                                ),
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
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: reduced ? 70 : 180),
                          child: Text(
                            formatUsd(price),
                            key: ValueKey(price),
                            style: const TextStyle(
                              color: StoreColors.ink,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(product.longDescription),
                        const SizedBox(height: 22),
                        if (variants.length > 1) ...[
                          Text(
                            'Finish',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: variants
                                .map(
                                  (item) => _FinishChoice(
                                    key: Key('finish-${item.id}'),
                                    label: item.displayName,
                                    swatch: item.swatch,
                                    selected: item.id == variant.id,
                                    reduced: reduced,
                                    onTap: () =>
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
                          'Why you’ll love it',
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
                        const SizedBox(height: 30),
                        Text(
                          'Specifications',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        ...product.specificationGroups.map(
                          (group) => _SpecificationPanel(group: group),
                        ),
                        if (product.compatibility.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          _EditorialList(
                            title: 'Compatibility',
                            values: product.compatibility,
                          ),
                        ],
                        if (product.includedItems.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          _EditorialList(
                            title: 'What’s in the box',
                            values: product.includedItems,
                          ),
                        ],
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
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: StoreColors.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: reduced ? 60 : 180),
                      child: Text(
                        formatUsd(price),
                        key: ValueKey('sticky-$price'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      [variant.displayName, ...optionLabels.values].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: StoreColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  key: const Key('details_add_to_bag'),
                  onPressed: () => _addToBag(
                    product: product,
                    variant: variant,
                    optionLabels: optionLabels,
                    price: price,
                    reduced: reduced,
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Add to Bag'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToBag({
    required HomeProduct product,
    required ProductVariant variant,
    required Map<String, String> optionLabels,
    required int price,
    required bool reduced,
  }) async {
    ref
        .read(cartProvider.notifier)
        .add(
          CartItem(
            productId: product.id,
            name: product.name,
            finish: variant.displayName,
            selectedOptions: optionLabels,
            unitPrice: price,
            variantId: variant.id,
            imagePath: variant.imagePath,
          ),
        );
    if (!reduced) await _runFlight(product, variant.imagePath);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Added to bag')));
  }

  Future<void> _runFlight(HomeProduct product, String imagePath) async {
    if (_flightController.isAnimating || _flightEntry != null) return;
    final startBox =
        _productKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = _bagKey.currentContext?.findRenderObject() as RenderBox?;
    if (startBox == null || endBox == null) return;
    final start = startBox.localToGlobal(startBox.size.center(Offset.zero));
    final end = endBox.localToGlobal(endBox.size.center(Offset.zero));
    _flightEntry = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _flightController,
          builder: (context, child) {
            final t = Curves.easeInOutCubic.transform(_flightController.value);
            final curve = Offset(0, -74 * 4 * t * (1 - t));
            final position = Offset.lerp(start, end, t)! + curve;
            return Stack(
              children: [
                Positioned(
                  left: position.dx - 29,
                  top: position.dy - 35,
                  child: Opacity(
                    opacity: 1 - t * 0.28,
                    child: Transform.scale(
                      scale: 1 - t * 0.56,
                      child: SizedBox(
                        width: 58,
                        height: 70,
                        child: ProductImage(
                          path: imagePath,
                          label: product.name,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_flightEntry!);
    await _flightController.forward(from: 0);
    _flightEntry?.remove();
    _flightEntry = null;
    if (!mounted) return;
    await _bagController.forward(from: 0);
    if (mounted) await _bagController.reverse();
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.reduced,
    required this.start,
    required this.end,
    required this.child,
  });
  final Animation<double> animation;
  final bool reduced;
  final double start, end;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (reduced) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class _FinishChoice extends StatelessWidget {
  const _FinishChoice({
    super.key,
    required this.label,
    required this.swatch,
    required this.selected,
    required this.reduced,
    required this.onTap,
  });
  final String label;
  final Color swatch;
  final bool selected, reduced;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$label finish',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: reduced ? 0 : 170),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? StoreColors.softRed : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? StoreColors.red : StoreColors.line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: swatch,
                border: Border.all(color: Colors.black12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? StoreColors.red : StoreColors.ink,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SpecificationPanel extends StatelessWidget {
  const _SpecificationPanel({required this.group});
  final ProductSpecificationGroup group;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: StoreColors.line),
      borderRadius: BorderRadius.circular(14),
    ),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        group.title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      children: [
        for (final entry in group.entries.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(color: StoreColors.muted),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _EditorialList extends StatelessWidget {
  const _EditorialList({required this.title, required this.values});
  final String title;
  final List<String> values;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      for (final value in values)
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 16, color: StoreColors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(value)),
            ],
          ),
        ),
    ],
  );
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
