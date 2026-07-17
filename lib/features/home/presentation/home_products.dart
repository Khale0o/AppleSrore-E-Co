import 'package:flutter/material.dart';

enum ProductCategory { iphone, mac, ipad, watch, airpods, accessories }

extension ProductCategoryLabel on ProductCategory {
  String get label => switch (this) {
    ProductCategory.iphone => 'iPhone',
    ProductCategory.mac => 'Mac',
    ProductCategory.ipad => 'iPad',
    ProductCategory.watch => 'Watch',
    ProductCategory.airpods => 'AirPods',
    ProductCategory.accessories => 'Accessories',
  };
}

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.basePrice,
    required this.assetPath,
    required this.finishes,
    required this.configurations,
    required this.features,
    required this.start,
    required this.end,
    required this.accent,
    this.featured = false,
    this.isNew = false,
  });
  final String id, name, tagline, description, assetPath;
  final ProductCategory category;
  final int basePrice;
  final List<String> finishes, configurations, features;
  final Color start, end, accent;
  final bool featured, isNew;
  String get heroTag => 'product-$id';
  String get price => 'Demo/reference from \$$basePrice';
  String get finish => finishes.first;
}

const _dark = Color(0xFF07090D),
    _blue = Color(0xFF9EDDF8),
    _silver = Color(0xFFD8E0E5);
HomeProduct _p(
  String id,
  String name,
  ProductCategory category,
  int price, {
  bool featured = false,
  bool isNew = false,
}) => HomeProduct(
  id: id,
  name: name,
  category: category,
  basePrice: price,
  featured: featured,
  isNew: isNew,
  tagline: 'Designed for the moments that matter.',
  description:
      'A portfolio reference configuration. Pricing is demo/reference only.',
  assetPath: 'assets/products/${category.name}/$id.webp',
  finishes: const ['Silver', 'Midnight', 'Blue'],
  configurations: category == ProductCategory.accessories
      ? const ['Standard']
      : const ['128 GB', '256 GB', '512 GB'],
  features: const [
    'Precision-crafted finish',
    'Connected ecosystem experience',
    'Advanced everyday performance',
  ],
  start: _dark,
  end: Color(0xFF172737),
  accent: category == ProductCategory.mac ? _silver : _blue,
);

final homeProducts = <HomeProduct>[
  _p(
    'iphone-17-pro',
    'iPhone 17 Pro',
    ProductCategory.iphone,
    1099,
    featured: true,
    isNew: true,
  ),
  _p(
    'iphone-17-pro-max',
    'iPhone 17 Pro Max',
    ProductCategory.iphone,
    1199,
    isNew: true,
  ),
  _p('iphone-air', 'iPhone Air', ProductCategory.iphone, 999, isNew: true),
  _p('iphone-17', 'iPhone 17', ProductCategory.iphone, 799),
  _p('iphone-17e', 'iPhone 17e', ProductCategory.iphone, 599),
  _p('iphone-16', 'iPhone 16', ProductCategory.iphone, 699),
  _p(
    'macbook-air-13',
    'MacBook Air 13-inch',
    ProductCategory.mac,
    999,
    featured: true,
  ),
  _p('macbook-air-15', 'MacBook Air 15-inch', ProductCategory.mac, 1199),
  _p('macbook-pro-14', 'MacBook Pro 14-inch', ProductCategory.mac, 1599),
  _p('macbook-pro-16', 'MacBook Pro 16-inch', ProductCategory.mac, 2499),
  _p('imac', 'iMac', ProductCategory.mac, 1299),
  _p('mac-mini', 'Mac mini', ProductCategory.mac, 599),
  _p('mac-studio', 'Mac Studio', ProductCategory.mac, 1999),
  _p(
    'ipad-pro-11',
    'iPad Pro 11-inch',
    ProductCategory.ipad,
    999,
    featured: true,
  ),
  _p('ipad-pro-13', 'iPad Pro 13-inch', ProductCategory.ipad, 1299),
  _p('ipad-air', 'iPad Air', ProductCategory.ipad, 599),
  _p('ipad', 'iPad', ProductCategory.ipad, 349),
  _p('ipad-mini', 'iPad mini', ProductCategory.ipad, 499),
  _p(
    'watch-series-11',
    'Apple Watch Series 11',
    ProductCategory.watch,
    399,
    isNew: true,
  ),
  _p('watch-ultra-3', 'Apple Watch Ultra 3', ProductCategory.watch, 799),
  _p('watch-se-3', 'Apple Watch SE 3', ProductCategory.watch, 249),
  _p(
    'airpods-pro-3',
    'AirPods Pro 3',
    ProductCategory.airpods,
    249,
    featured: true,
  ),
  _p('airpods-4', 'AirPods 4', ProductCategory.airpods, 129),
  _p('airpods-max-2', 'AirPods Max 2', ProductCategory.airpods, 549),
  _p('apple-pencil-pro', 'Apple Pencil Pro', ProductCategory.accessories, 129),
  _p('magic-keyboard', 'Magic Keyboard', ProductCategory.accessories, 299),
  _p('magsafe-charger', 'MagSafe Charger', ProductCategory.accessories, 39),
  _p('airtag', 'AirTag', ProductCategory.accessories, 29),
];
HomeProduct productForId(String id) =>
    productForIdOrNull(id) ?? homeProducts.first;
HomeProduct? productForIdOrNull(String id) =>
    homeProducts.where((p) => p.id == id).firstOrNull;
