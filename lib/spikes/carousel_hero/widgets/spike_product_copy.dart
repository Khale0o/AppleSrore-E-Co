import 'package:flutter/material.dart';

import '../spike_motion.dart';
import '../spike_product.dart';

class SpikeProductCopy extends StatelessWidget {
  const SpikeProductCopy({
    super.key,
    required this.product,
    required this.direction,
  });

  final SpikeProduct product;
  final int direction;

  @override
  Widget build(BuildContext context) {
    final offset = Offset(direction * .06, 0);
    return AnimatedSwitcher(
      duration: SpikeMotion.standard,
      switchInCurve: SpikeMotion.enter,
      switchOutCurve: SpikeMotion.exit,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
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
          const SizedBox(height: 8),
          Text(
            product.finish.toUpperCase(),
            style: TextStyle(
              color: product.accent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.tagline,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .72),
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
