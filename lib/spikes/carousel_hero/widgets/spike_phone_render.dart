import 'package:flutter/material.dart';

import '../spike_product.dart';

class SpikePhoneRender extends StatelessWidget {
  const SpikePhoneRender({
    super.key,
    required this.product,
    this.details = false,
  });

  final SpikeProduct product;
  final bool details;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .5),
              blurRadius: 34,
              offset: const Offset(0, 22),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              product.accent.withValues(alpha: .85),
              const Color(0xFF1A2027),
              const Color(0xFF050608),
            ],
            stops: const [0, .12, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF05070A),
              borderRadius: BorderRadius.circular(39),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      gradient: RadialGradient(
                        center: const Alignment(.2, -.8),
                        radius: 1.2,
                        colors: [
                          product.accent.withValues(alpha: .32),
                          const Color(0xFF0A0E13),
                          const Color(0xFF030405),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 20,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xCC10151B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .12),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: product.accent.withValues(alpha: .75),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(.1, .42),
                  child: Container(
                    width: details ? 86 : 68,
                    height: details ? 86 : 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: .18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 26,
                  left: 25,
                  right: 25,
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: .14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
