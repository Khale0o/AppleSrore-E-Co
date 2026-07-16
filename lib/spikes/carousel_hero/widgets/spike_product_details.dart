import 'package:flutter/material.dart';

import '../spike_product.dart';
import 'spike_phone_render.dart';

class SpikeProductDetails extends StatelessWidget {
  const SpikeProductDetails({
    super.key,
    required this.product,
    required this.reducedMotion,
  });

  final SpikeProduct product;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.backgroundStart,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [product.backgroundStart, product.backgroundEnd],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    key: const Key('details_back'),
                    tooltip: 'Back',
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final phoneWidth = constraints.maxHeight < 650
                          ? 145.0
                          : 235.0;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
                        child: Column(
                          children: [
                            Hero(
                              tag: product.heroTag,
                              child: SizedBox(
                                width: phoneWidth,
                                child: SpikePhoneRender(
                                  product: product,
                                  details: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product.tagline,
                                style: TextStyle(
                                  color: product.accent,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            ...product.features.map(
                              (feature) => Padding(
                                padding: const EdgeInsets.only(bottom: 9),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    feature,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: .7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.tune_rounded, size: 16),
                                label: const Text('Configure'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white.withValues(
                                    alpha: .75,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
