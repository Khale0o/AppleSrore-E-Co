import 'package:flutter/material.dart';

import '../spike_motion.dart';
import '../spike_product.dart';
import 'spike_phone_render.dart';

class CinematicProductCarousel extends StatelessWidget {
  const CinematicProductCarousel({
    super.key,
    required this.controller,
    required this.products,
    required this.reducedMotion,
    required this.onProductTap,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<SpikeProduct> products;
  final bool reducedMotion;
  final ValueChanged<SpikeProduct> onProductTap;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: products.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: controller,
        child: Hero(
          tag: products[index].heroTag,
          child: SpikePhoneRender(product: products[index]),
        ),
        builder: (context, child) {
          final page = controller.hasClients
              ? (controller.page ?? controller.initialPage.toDouble())
              : controller.initialPage.toDouble();
          final delta = SpikeMotion.clamp(page - index.toDouble());
          final translation = reducedMotion ? delta * 18 : delta * 74;
          final scale = reducedMotion ? 1.0 : 1 - delta.abs() * .10;
          final rotation = reducedMotion ? 0.0 : SpikeMotion.degrees(delta * 3);
          final opacity = reducedMotion ? 1.0 : 1 - delta.abs() * .28;
          return GestureDetector(
            key: Key('product_${products[index].id}'),
            behavior: HitTestBehavior.opaque,
            onTap: delta.abs() < .08
                ? () => onProductTap(products[index])
                : null,
            child: Center(
              child: Transform.translate(
                offset: Offset(-translation, delta.abs() * 14),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateY(rotation),
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: SizedBox(width: 230, child: child),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
