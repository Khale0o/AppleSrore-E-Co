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

enum ProductOptionType {
  storage,
  memory,
  chip,
  connectivity,
  caseSize,
  band,
  earTipSize,
  size,
  compatibility,
}

class ProductOptionValue {
  const ProductOptionValue({
    required this.id,
    required this.label,
    this.priceAdjustment = 0,
  });
  final String id, label;
  final int priceAdjustment;
}

class ProductOptionGroup {
  const ProductOptionGroup({
    required this.id,
    required this.label,
    required this.type,
    required this.values,
    required this.defaultValueId,
  });
  final String id, label, defaultValueId;
  final ProductOptionType type;
  final List<ProductOptionValue> values;
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
    required this.optionGroups,
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
  final List<String> finishes, features;
  final List<ProductOptionGroup> optionGroups;
  final Color start, end, accent;
  final bool featured, isNew;
  String get heroTag => 'product-$id';
  String get price => 'From \$$basePrice';
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
      'A thoughtfully configured product designed for effortless everyday use.',
  assetPath: _assetFor(id),
  finishes: _finishesFor(id),
  optionGroups: _optionGroupsFor(id, category),
  features: const [
    'Precision-crafted finish',
    'Connected ecosystem experience',
    'Advanced everyday performance',
  ],
  start: _dark,
  end: Color(0xFF172737),
  accent: category == ProductCategory.mac ? _silver : _blue,
);

String _assetFor(String id) => switch (id) {
  'iphone-17-pro' => 'assets/products/iphone/iphone-17-pro_red.png',
  'iphone-17-pro-max' => 'assets/products/iphone/iphone-17-pro-max_black.png',
  'iphone-air' => 'assets/products/iphone/iphone-air_blue.png',
  'iphone-17' => 'assets/products/iphone/iphone-17_blue.png',
  'iphone-17e' => 'assets/products/iphone/iphone-17e_white.png',
  'iphone-16' => 'assets/products/iphone/iphone-16_black.png',
  'macbook-air-13' => 'assets/products/mac/macbook-air-13_silver.png',
  'macbook-air-15' => 'assets/products/mac/macbook-air-15_midnight.png',
  'macbook-pro-14' => 'assets/products/mac/macbook-pro-14_space-black.png',
  'macbook-pro-16' => 'assets/products/mac/macbook-pro-16_silver.png',
  'imac' => 'assets/products/mac/imac_blue.png',
  'mac-mini' => 'assets/products/mac/mac-mini_silver.png',
  'mac-studio' => 'assets/products/mac/mac-studio_silver.png',
  'ipad-pro-11' => 'assets/products/ipad/ipad-pro-11_graphite.png',
  'ipad-pro-13' => 'assets/products/ipad/ipad-pro-13_silver.png',
  'ipad-air' => 'assets/products/ipad/ipad-air_blue.png',
  'ipad' => 'assets/products/ipad/ipad_yellow.png',
  'ipad-mini' => 'assets/products/ipad/ipad-mini_purple.png',
  'watch-series-11' => 'assets/products/watch/watch-series-11_red.png',
  'watch-ultra-3' => 'assets/products/watch/watch-ultra-3_titanium.png',
  'watch-se-3' => 'assets/products/watch/watch-se-3_silver.png',
  'airpods-pro-3' => 'assets/products/airpods/airpods-pro-3_white.png',
  'airpods-4' => 'assets/products/airpods/airpods-4_white.png',
  'airpods-max-2' => 'assets/products/airpods/airpods-max-2_midnight.png',
  'apple-pencil-pro' =>
    'assets/products/accessories/apple-pencil-pro_white.png',
  'magic-keyboard' => 'assets/products/accessories/magic-keyboard_black.png',
  'magsafe-charger' => 'assets/products/accessories/magsafe-charger_white.png',
  'airtag' => 'assets/products/accessories/airtag_silver.png',
  _ => throw ArgumentError.value(id, 'id', 'Unknown product asset'),
};

List<String> _finishesFor(String id) => switch (id) {
  'iphone-17-pro' => const ['Crimson Red', 'Deep Blue', 'Graphite Black'],
  'iphone-17-pro-max' || 'iphone-16' => const ['Graphite Black'],
  'iphone-air' || 'iphone-17' || 'imac' || 'ipad-air' => const ['Sky Blue'],
  'iphone-17e' ||
  'airpods-pro-3' ||
  'airpods-4' ||
  'apple-pencil-pro' ||
  'magsafe-charger' => const ['Soft White'],
  'macbook-air-15' || 'airpods-max-2' => const ['Midnight'],
  'macbook-pro-14' ||
  'ipad-pro-11' ||
  'magic-keyboard' => const ['Space Black'],
  'ipad' => const ['Yellow'],
  'ipad-mini' => const ['Purple'],
  'watch-series-11' => const ['Red'],
  'watch-ultra-3' => const ['Natural Titanium'],
  'watch-se-3' => const ['Silver / Blue'],
  _ => const ['Silver'],
};

const _phoneStorage = ProductOptionGroup(
  id: 'storage',
  label: 'Storage',
  type: ProductOptionType.storage,
  defaultValueId: '128gb',
  values: [
    ProductOptionValue(id: '128gb', label: '128 GB'),
    ProductOptionValue(id: '256gb', label: '256 GB', priceAdjustment: 100),
    ProductOptionValue(id: '512gb', label: '512 GB', priceAdjustment: 300),
  ],
);
const _ipadConnectivity = ProductOptionGroup(
  id: 'connectivity',
  label: 'Connectivity',
  type: ProductOptionType.connectivity,
  defaultValueId: 'wifi',
  values: [
    ProductOptionValue(id: 'wifi', label: 'Wi-Fi'),
    ProductOptionValue(
      id: 'wifi-cellular',
      label: 'Wi-Fi + Cellular',
      priceAdjustment: 150,
    ),
  ],
);
const _macMemory = ProductOptionGroup(
  id: 'memory',
  label: 'Memory',
  type: ProductOptionType.memory,
  defaultValueId: '16gb',
  values: [
    ProductOptionValue(id: '16gb', label: '16 GB'),
    ProductOptionValue(id: '24gb', label: '24 GB', priceAdjustment: 200),
    ProductOptionValue(id: '32gb', label: '32 GB', priceAdjustment: 400),
  ],
);
const _macStorage = ProductOptionGroup(
  id: 'storage',
  label: 'Storage',
  type: ProductOptionType.storage,
  defaultValueId: '512gb',
  values: [
    ProductOptionValue(id: '512gb', label: '512 GB'),
    ProductOptionValue(id: '1tb', label: '1 TB', priceAdjustment: 200),
    ProductOptionValue(id: '2tb', label: '2 TB', priceAdjustment: 600),
  ],
);
const _macChip = ProductOptionGroup(
  id: 'chip',
  label: 'Chip',
  type: ProductOptionType.chip,
  defaultValueId: 'pro',
  values: [
    ProductOptionValue(id: 'pro', label: 'Pro'),
    ProductOptionValue(id: 'max', label: 'Max', priceAdjustment: 300),
  ],
);
const _watchCase = ProductOptionGroup(
  id: 'case-size',
  label: 'Case Size',
  type: ProductOptionType.caseSize,
  defaultValueId: '42mm',
  values: [
    ProductOptionValue(id: '42mm', label: '42 mm'),
    ProductOptionValue(id: '46mm', label: '46 mm', priceAdjustment: 30),
  ],
);
const _watchBand = ProductOptionGroup(
  id: 'band',
  label: 'Band Type',
  type: ProductOptionType.band,
  defaultValueId: 'sport',
  values: [
    ProductOptionValue(id: 'sport', label: 'Sport Band'),
    ProductOptionValue(id: 'woven', label: 'Woven Band', priceAdjustment: 50),
  ],
);
const _watchConnectivity = ProductOptionGroup(
  id: 'connectivity',
  label: 'Connectivity',
  type: ProductOptionType.connectivity,
  defaultValueId: 'gps',
  values: [
    ProductOptionValue(id: 'gps', label: 'GPS'),
    ProductOptionValue(
      id: 'gps-cellular',
      label: 'GPS + Cellular',
      priceAdjustment: 100,
    ),
  ],
);

List<ProductOptionGroup> _optionGroupsFor(
  String id,
  ProductCategory category,
) => switch (category) {
  ProductCategory.iphone => const [_phoneStorage],
  ProductCategory.ipad => const [_phoneStorage, _ipadConnectivity],
  ProductCategory.mac => switch (id) {
    'macbook-pro-14' ||
    'macbook-pro-16' ||
    'mac-mini' ||
    'mac-studio' => const [_macChip, _macMemory, _macStorage],
    _ => const [_macMemory, _macStorage],
  },
  ProductCategory.watch => const [_watchCase, _watchBand, _watchConnectivity],
  ProductCategory.airpods =>
    id == 'airpods-pro-3'
        ? const [
            ProductOptionGroup(
              id: 'ear-tip-size',
              label: 'Ear Tip Size',
              type: ProductOptionType.earTipSize,
              defaultValueId: 'medium',
              values: [
                ProductOptionValue(id: 'xs', label: 'XS'),
                ProductOptionValue(id: 'small', label: 'S'),
                ProductOptionValue(id: 'medium', label: 'M'),
                ProductOptionValue(id: 'large', label: 'L'),
              ],
            ),
          ]
        : const [],
  ProductCategory.accessories => switch (id) {
    'apple-pencil-pro' => const [
      ProductOptionGroup(
        id: 'compatibility',
        label: 'Compatibility',
        type: ProductOptionType.compatibility,
        defaultValueId: 'ipad-pro-air',
        values: [
          ProductOptionValue(id: 'ipad-pro-air', label: 'iPad Pro / Air'),
        ],
      ),
    ],
    'magic-keyboard' => const [
      ProductOptionGroup(
        id: 'size',
        label: 'Size',
        type: ProductOptionType.size,
        defaultValueId: '11-inch',
        values: [
          ProductOptionValue(id: '11-inch', label: '11-inch'),
          ProductOptionValue(
            id: '13-inch',
            label: '13-inch',
            priceAdjustment: 50,
          ),
        ],
      ),
    ],
    'airtag' => const [
      ProductOptionGroup(
        id: 'size',
        label: 'Pack Size',
        type: ProductOptionType.size,
        defaultValueId: 'one-pack',
        values: [
          ProductOptionValue(id: 'one-pack', label: '1 Pack'),
          ProductOptionValue(
            id: 'four-pack',
            label: '4 Pack',
            priceAdjustment: 70,
          ),
        ],
      ),
    ],
    _ => const [],
  },
};

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
