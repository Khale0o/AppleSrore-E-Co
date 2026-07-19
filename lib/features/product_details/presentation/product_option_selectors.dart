import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../home/presentation/home_products.dart';
import 'product_variants.dart';

class ProductOptionSelectors extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (product.optionGroups.isEmpty) return const SizedBox.shrink();
    final reduced = ref.watch(reducedMotionProvider);
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
                _OptionChoice(
                  key: Key('option-${group.id}-${value.id}'),
                  label: value.label,
                  selected:
                      selectedOptionValue(group, selection).id == value.id,
                  duration: Duration(milliseconds: reduced ? 0 : 170),
                  onTap: () => onSelected(group.id, value.id),
                ),
            ],
          ),
          const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _OptionChoice extends StatelessWidget {
  const _OptionChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.duration,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(minHeight: 46, minWidth: 72),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? StoreColors.softRed : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? StoreColors.red : StoreColors.line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? StoreColors.red : StoreColors.ink,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
