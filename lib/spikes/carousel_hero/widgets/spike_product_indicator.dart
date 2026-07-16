import 'package:flutter/material.dart';

import '../spike_product.dart';

class SpikeProductIndicator extends StatelessWidget {
  const SpikeProductIndicator({
    super.key,
    required this.products,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<SpikeProduct> products;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Product selector',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(products.length, (index) {
          final selected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              key: Key('indicator_$index'),
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: selected ? 38 : 24,
                height: 34,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: selected ? 30 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: selected
                        ? products[index].accent
                        : Colors.white.withValues(alpha: .32),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
