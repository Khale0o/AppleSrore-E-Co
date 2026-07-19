import 'package:flutter/material.dart';

import '../../app/theme/store_theme_v2.dart';
import '../../features/home/presentation/home_products.dart';
import 'product_image.dart';

String formatUsd(num value) => '\$${value.toStringAsFixed(0)}';

class StoreSectionHeader extends StatelessWidget {
  const StoreSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
      if (actionLabel != null)
        TextButton(onPressed: onAction, child: Text(actionLabel!)),
    ],
  );
}

class StoreProductImageStage extends StatelessWidget {
  const StoreProductImageStage({
    super.key,
    required this.product,
    this.heroTag,
    this.imagePath,
    this.price,
    this.padding = const EdgeInsets.all(12),
    this.background = const Color(0xFFF0F1F4),
  });
  final HomeProduct product;
  final String? heroTag;
  final String? imagePath;
  final int? price;
  final EdgeInsets padding;
  final Color background;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: padding,
      child: ProductImage(
        path: imagePath ?? product.assetPath,
        label: product.name,
        heroTag: heroTag,
      ),
    ),
  );
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.selected,
    required this.onPressed,
  });
  final bool selected;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: selected ? 'Remove from Saved' : 'Save product',
    onPressed: onPressed,
    icon: AnimatedScale(
      duration: const Duration(milliseconds: 160),
      scale: selected ? 1.08 : 1,
      child: Icon(
        selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: selected ? StoreColors.red : StoreColors.ink,
      ),
    ),
  );
}

class StoreProductCard extends StatefulWidget {
  const StoreProductCard({
    super.key,
    required this.product,
    required this.saved,
    required this.onSaved,
    required this.onOpen,
    this.imagePath,
    this.price,
    this.discount,
    this.originalPrice,
  });
  final HomeProduct product;
  final String? imagePath;
  final int? price;
  final bool saved;
  final VoidCallback onSaved;
  final VoidCallback onOpen;
  final int? discount;
  final int? originalPrice;
  @override
  State<StoreProductCard> createState() => _StoreProductCardState();
}

class _StoreProductCardState extends State<StoreProductCard> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    scale: pressed ? 0.98 : 1,
    duration: const Duration(milliseconds: 110),
    child: Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onOpen,
        onHighlightChanged: (value) => setState(() => pressed = value),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: StoreProductImageStage(
                        product: widget.product,
                        imagePath: widget.imagePath,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: FavoriteButton(
                        selected: widget.saved,
                        onPressed: widget.onSaved,
                      ),
                    ),
                    if (widget.discount != null)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: StoreColors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            child: Text(
                              '-${widget.discount}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    formatUsd(widget.price ?? widget.product.basePrice),
                    style: const TextStyle(
                      color: StoreColors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (widget.originalPrice != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      formatUsd(widget.originalPrice!),
                      style: const TextStyle(
                        color: StoreColors.muted,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? StoreColors.red : Colors.white,
                border: Border.all(color: StoreColors.line),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : StoreColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: selected ? StoreColors.red : StoreColors.muted,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
