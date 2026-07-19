import 'package:flutter/material.dart';

import '../../home/presentation/home_products.dart';
import 'product_variants.dart';

class ProductOptionSelectors extends StatelessWidget {
  const ProductOptionSelectors({
    super.key,
    required this.product,
    required this.selection,
    required this.onSelected,
  });
  final HomeProduct product;
  final ProductSelection selection;
  final void Function(String groupId, String valueId) onSelected;

  @override
  Widget build(BuildContext context) {
    if (product.optionGroups.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in product.optionGroups) ...[
          Text(group.label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in group.values)
                ChoiceChip(
                  label: Text(value.label),
                  selected:
                      selectedOptionValue(group, selection).id == value.id,
                  onSelected: (_) => onSelected(group.id, value.id),
                ),
            ],
          ),
          const SizedBox(height: 18),
        ],
      ],
    );
  }
}
