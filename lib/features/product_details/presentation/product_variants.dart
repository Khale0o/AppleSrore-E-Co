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

List<ProductVariant> variantsFor(HomeProduct product) => [
  ProductVariant(
    id: '${product.id}-default',
    displayName: product.finish,
    swatch: product.accent,
    imagePath: product.assetPath,
  ),
];

class ProductSelection {
  const ProductSelection({
    required this.variantId,
    required this.configuration,
  });
  final String variantId, configuration;
  ProductSelection copyWith({String? variantId, String? configuration}) =>
      ProductSelection(
        variantId: variantId ?? this.variantId,
        configuration: configuration ?? this.configuration,
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
        configuration: product.configurations.first,
      );
  void setVariant(HomeProduct product, String variantId) => state = {
    ...state,
    product.id: forProduct(product).copyWith(variantId: variantId),
  };
  void setConfiguration(HomeProduct product, String configuration) => state = {
    ...state,
    product.id: forProduct(product).copyWith(configuration: configuration),
  };
}

final productSelectionsProvider =
    NotifierProvider<
      ProductSelectionsController,
      Map<String, ProductSelection>
    >(ProductSelectionsController.new);
