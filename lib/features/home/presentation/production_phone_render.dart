import 'package:flutter/material.dart';
import 'home_products.dart';

class ProductionPhoneRender extends StatelessWidget {
  const ProductionPhoneRender({super.key, required this.product});
  final HomeProduct product;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: .54 * product.widthFactor,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            product.accent.withValues(alpha: .86),
            const Color(0xFF171D24),
            const Color(0xFF050609),
          ],
          stops: const [0, .12, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .52),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF07090D),
            borderRadius: BorderRadius.circular(37),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: RadialGradient(
                      center: const Alignment(.15, -.82),
                      radius: 1.15,
                      colors: [
                        product.accent.withValues(alpha: .29),
                        const Color(0xFF0B0F15),
                        const Color(0xFF030405),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 18,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: List.generate(
                    product.cameraCount,
                    (_) => Container(
                      width: 19,
                      height: 19,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10161D),
                        border: Border.all(
                          color: product.accent.withValues(alpha: .45),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
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
