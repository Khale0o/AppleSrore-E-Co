import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/presentation/home_products.dart';

class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.displayName,
    required this.swatch,
    required this.imagePath,
    this.frontImagePath,
    this.backImagePath,
    this.priceAdjustment = 0,
  });
  final String id, displayName, imagePath;
  final Color swatch;
  final String? frontImagePath, backImagePath;
  final int priceAdjustment;
  bool get hasFrontBack => frontImagePath != null && backImagePath != null;
}

List<ProductVariant> variantsFor(HomeProduct product) {
  if (product.id == 'iphone-17-pro') {
    return const [
      ProductVariant(
        id: 'iphone-17-pro-red',
        displayName: 'Crimson Red',
        swatch: Color(0xFFE31E2B),
        imagePath: 'assets/products/iphone/iphone-17-pro_red.png',
      ),
      ProductVariant(
        id: 'iphone-17-pro-blue',
        displayName: 'Deep Blue',
        swatch: Color(0xFF315F8A),
        imagePath: 'assets/products/iphone/iphone-17-pro_blue.png',
      ),
      ProductVariant(
        id: 'iphone-17-pro-black',
        displayName: 'Graphite Black',
        swatch: Color(0xFF25272B),
        imagePath: 'assets/products/iphone/iphone-17-pro_black.png',
      ),
    ];
  }
  final metadata = _variantMetadata(product.id);
  return [
    ProductVariant(
      id: '${product.id}-${metadata.name.toLowerCase().replaceAll(' ', '-')}',
      displayName: metadata.name,
      swatch: metadata.swatch,
      imagePath: product.assetPath,
    ),
  ];
}

({String name, Color swatch}) _variantMetadata(String id) => switch (id) {
  'iphone-17-pro-max' ||
  'iphone-16' => (name: 'Graphite Black', swatch: const Color(0xFF25272B)),
  'iphone-air' ||
  'iphone-17' ||
  'imac' ||
  'ipad-air' => (name: 'Sky Blue', swatch: const Color(0xFF8DB8D8)),
  'iphone-17e' ||
  'airpods-pro-3' ||
  'airpods-4' ||
  'apple-pencil-pro' ||
  'magsafe-charger' => (name: 'Soft White', swatch: const Color(0xFFF2F2F0)),
  'macbook-air-15' ||
  'airpods-max-2' => (name: 'Midnight', swatch: const Color(0xFF253047)),
  'macbook-pro-14' ||
  'ipad-pro-11' ||
  'magic-keyboard' => (name: 'Space Black', swatch: const Color(0xFF383A3D)),
  'ipad' => (name: 'Yellow', swatch: const Color(0xFFF2D878)),
  'ipad-mini' => (name: 'Purple', swatch: const Color(0xFF8D72A8)),
  'watch-series-11' => (name: 'Red', swatch: const Color(0xFFC9202C)),
  'watch-ultra-3' => (
    name: 'Natural Titanium',
    swatch: const Color(0xFFBDB7A8),
  ),
  'watch-se-3' => (name: 'Silver / Blue', swatch: const Color(0xFF8CB5D3)),
  _ => (name: 'Silver', swatch: const Color(0xFFC8CDD1)),
};

class ProductSelection {
  const ProductSelection({
    required this.variantId,
    required this.optionValueIds,
  });
  final String variantId;
  final Map<String, String> optionValueIds;
  ProductSelection copyWith({
    String? variantId,
    Map<String, String>? optionValueIds,
  }) => ProductSelection(
    variantId: variantId ?? this.variantId,
    optionValueIds: optionValueIds ?? this.optionValueIds,
  );
}

class ProductSelectionsController
    extends Notifier<Map<String, ProductSelection>> {
  @override
  Map<String, ProductSelection> build() => {};
  ProductSelection forProduct(HomeProduct product) =>
      state[product.id] ??
      ProductSelection(
        variantId: variantsFor(product).first.id,
        optionValueIds: {
          for (final group in product.optionGroups)
            group.id: group.defaultValueId,
        },
      );
  void setVariant(HomeProduct product, String variantId) => state = {
    ...state,
    product.id: forProduct(product).copyWith(variantId: variantId),
  };
  void setOption(HomeProduct product, String groupId, String valueId) {
    final current = forProduct(product);
    state = {
      ...state,
      product.id: current.copyWith(
        optionValueIds: {...current.optionValueIds, groupId: valueId},
      ),
    };
  }

  void setOptions(HomeProduct product, Map<String, String> optionValueIds) {
    final current = forProduct(product);
    state = {
      ...state,
      product.id: current.copyWith(optionValueIds: optionValueIds),
    };
  }
}

ProductOptionValue selectedOptionValue(
  ProductOptionGroup group,
  ProductSelection selection,
) => group.values.firstWhere(
  (value) => value.id == selection.optionValueIds[group.id],
  orElse: () => group.values.firstWhere(
    (value) => value.id == group.defaultValueId,
    orElse: () => group.values.first,
  ),
);

int selectedOptionsPriceAdjustment(
  HomeProduct product,
  ProductSelection selection,
) => product.optionGroups.fold(
  0,
  (total, group) =>
      total + selectedOptionValue(group, selection).priceAdjustment,
);

Map<String, String> selectedOptionsForCart(
  HomeProduct product,
  ProductSelection selection,
) => {
  for (final group in product.optionGroups)
    group.id: selectedOptionValue(group, selection).label,
};

final productSelectionsProvider =
    NotifierProvider<
      ProductSelectionsController,
      Map<String, ProductSelection>
    >(ProductSelectionsController.new);
