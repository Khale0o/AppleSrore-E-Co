import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../cart/presentation/cart_state.dart';
import '../../home/presentation/home_products.dart';
import '../../product_details/presentation/product_variants.dart';

class ProductConfigurationPlaceholderPage extends ConsumerStatefulWidget {
  const ProductConfigurationPlaceholderPage({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  ConsumerState<ProductConfigurationPlaceholderPage> createState() =>
      _ConfigurationState();
}

class _ConfigurationState
    extends ConsumerState<ProductConfigurationPlaceholderPage>
    with TickerProviderStateMixin {
  late final AnimationController _flightController;
  late final AnimationController _bagController;
  OverlayEntry? _flightEntry;
  final productKey = GlobalKey();
  final bagKey = GlobalKey();
  bool showingBack = false;

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _bagController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 170),
    );
  }

  @override
  void dispose() {
    _flightEntry?.remove();
    _flightEntry = null;
    _flightController.dispose();
    _bagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = productForIdOrNull(widget.productId);
    if (product == null) {
      return const Scaffold(body: Center(child: Text('PRODUCT UNAVAILABLE')));
    }
    ref.watch(productSelectionsProvider);
    final controller = ref.read(productSelectionsProvider.notifier);
    final selection = controller.forProduct(product);
    final variants = variantsFor(product);
    final variant = variants.firstWhere(
      (item) => item.id == selection.variantId,
      orElse: () => variants.first,
    );
    final reduced = ref.watch(reducedMotionProvider);
    final configurationIndex = product.configurations.indexOf(
      selection.configuration,
    );
    final price =
        product.basePrice +
        variant.priceAdjustment +
        (configurationIndex < 0 ? 0 : configurationIndex * 100);
    final imagePath = showingBack && variant.backImagePath != null
        ? variant.backImagePath!
        : (variant.frontImagePath ?? variant.imagePath);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        centerTitle: true,
        title: const Text('Configure'),
        actions: [
          ScaleTransition(
            key: bagKey,
            scale: Tween<double>(begin: 1, end: 1.12).animate(
              CurvedAnimation(
                parent: _bagController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: IconButton(
              onPressed: () => context.goNamed('cart'),
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                key: productKey,
                                height: 300,
                                child: AnimatedSwitcher(
                                  duration: Duration(
                                    milliseconds: reduced ? 80 : 210,
                                  ),
                                  child: DecoratedBox(
                                    key: ValueKey(
                                      '${product.id}-${variant.id}-$showingBack',
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        Colors.white,
                                        variant.swatch,
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(26),
                                      child: ProductImage(
                                        path: imagePath,
                                        label: product.name,
                                        heroTag: product.heroTag,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (variant.hasFrontBack) ...[
                                const SizedBox(height: 12),
                                Center(
                                  child: SegmentedButton<bool>(
                                    segments: const [
                                      ButtonSegment(
                                        value: false,
                                        label: Text('Front'),
                                      ),
                                      ButtonSegment(
                                        value: true,
                                        label: Text('Back'),
                                      ),
                                    ],
                                    selected: {showingBack},
                                    onSelectionChanged: (value) => setState(
                                      () => showingBack = value.first,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              Text(
                                'Choose a finish',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: variants
                                    .map(
                                      (item) => ChoiceChip(
                                        selected: item.id == variant.id,
                                        avatar: CircleAvatar(
                                          backgroundColor: item.swatch,
                                          radius: 8,
                                        ),
                                        label: Text(item.displayName),
                                        onSelected: (_) => controller
                                            .setVariant(product, item.id),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Choose storage or size',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: product.configurations
                                    .map(
                                      (value) => ChoiceChip(
                                        selected:
                                            value == selection.configuration,
                                        label: Text(value),
                                        onSelected: (_) => controller
                                            .setConfiguration(product, value),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: ProductImage(
                                          path: imagePath,
                                          label: product.name,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            Text(
                                              '${variant.displayName} · ${selection.configuration}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        formatUsd(price),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: StoreColors.line)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  key: const Key('add_to_bag'),
                  onPressed: () => _add(
                    product: product,
                    variant: variant,
                    configuration: selection.configuration,
                    imagePath: imagePath,
                    price: price,
                    reduced: reduced,
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text('Add to Bag · ${formatUsd(price)}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add({
    required HomeProduct product,
    required ProductVariant variant,
    required String configuration,
    required String imagePath,
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
            storage: configuration,
            unitPrice: price,
            variantId: variant.id,
            imagePath: imagePath,
          ),
        );
    if (!reduced) await _runFlight(product, imagePath);
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to bag')));
  }

  Future<void> _runFlight(HomeProduct product, String imagePath) async {
    if (_flightController.isAnimating || _flightEntry != null) return;
    final startBox =
        productKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = bagKey.currentContext?.findRenderObject() as RenderBox?;
    if (startBox == null || endBox == null) return;
    final start = startBox.localToGlobal(startBox.size.center(Offset.zero));
    final end = endBox.localToGlobal(endBox.size.center(Offset.zero));
    _flightEntry = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _flightController,
          builder: (context, child) {
            final t = Curves.easeInOutCubic.transform(_flightController.value);
            final position =
                Offset.lerp(start, end, t)! + Offset(0, -72 * 4 * t * (1 - t));
            return Stack(
              children: [
                Positioned(
                  left: position.dx - 28,
                  top: position.dy - 34,
                  child: Opacity(
                    opacity: 1 - t * 0.25,
                    child: Transform.scale(
                      scale: 1 - t * 0.55,
                      child: SizedBox(
                        width: 56,
                        height: 68,
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
