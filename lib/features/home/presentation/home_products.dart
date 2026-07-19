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

class ProductSpecificationGroup {
  const ProductSpecificationGroup({required this.title, required this.entries});
  final String title;
  final Map<String, String> entries;
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
    required this.specificationGroups,
    required this.compatibility,
    required this.includedItems,
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
  final List<ProductSpecificationGroup> specificationGroups;
  final List<String> compatibility, includedItems;
  final Color start, end, accent;
  final bool featured, isNew;
  String get heroTag => 'product-$id';
  String get price => 'From \$$basePrice';
  String get finish => finishes.first;
  String get shortDescription => tagline;
  String get longDescription => description;
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
}) {
  final content = _contentFor(id, name, category);
  return HomeProduct(
    id: id,
    name: name,
    category: category,
    basePrice: price,
    featured: featured,
    isNew: isNew,
    tagline: content.shortDescription,
    description: content.longDescription,
    assetPath: _assetFor(id),
    finishes: _finishesFor(id),
    optionGroups: _optionGroupsFor(id, category),
    features: content.highlights,
    specificationGroups: content.specificationGroups,
    compatibility: content.compatibility,
    includedItems: content.includedItems,
    start: _dark,
    end: const Color(0xFF172737),
    accent: category == ProductCategory.mac ? _silver : _blue,
  );
}

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

typedef _ProductContent = ({
  String shortDescription,
  String longDescription,
  List<String> highlights,
  List<ProductSpecificationGroup> specificationGroups,
  List<String> compatibility,
  List<String> includedItems,
});

_ProductContent _contentFor(String id, String name, ProductCategory category) {
  final copy = _copyFor(id);
  final specs = _specificationsFor(id);
  final entries = specs.entries.toList();
  final split = (entries.length / 2).ceil();
  final groupTitles = switch (category) {
    ProductCategory.iphone => ('Design & performance', 'Camera & connection'),
    ProductCategory.mac => ('Compute & memory', 'Display, ports & power'),
    ProductCategory.ipad => ('Display & performance', 'Creative connection'),
    ProductCategory.watch => ('Case & display', 'Health & connection'),
    ProductCategory.airpods => ('Audio system', 'Listening experience'),
    ProductCategory.accessories => ('Product details', 'Connection & fit'),
  };
  return (
    shortDescription: copy.short,
    longDescription: copy.long,
    highlights: [
      for (final entry in entries.take(3)) '${entry.key} — ${entry.value}',
    ],
    specificationGroups: [
      ProductSpecificationGroup(
        title: groupTitles.$1,
        entries: Map.fromEntries(entries.take(split)),
      ),
      ProductSpecificationGroup(
        title: groupTitles.$2,
        entries: Map.fromEntries(entries.skip(split)),
      ),
    ],
    compatibility: _compatibilityFor(id, category),
    includedItems: _includedItemsFor(name, category),
  );
}

({String short, String long}) _copyFor(String id) => switch (id) {
  'iphone-17-pro' => (
    short: 'Pro power, framed in a vivid new finish.',
    long:
        'iPhone 17 Pro pairs a compact ProMotion display with a three-camera system and sustained performance for demanding creative work.',
  ),
  'iphone-17-pro-max' => (
    short: 'The largest canvas for the most ambitious ideas.',
    long:
        'iPhone 17 Pro Max expands the pro experience with a generous display, longer video endurance, and extended optical reach.',
  ),
  'iphone-air' => (
    short: 'Remarkably thin. Ready for every day.',
    long:
        'iPhone Air balances an exceptionally light profile with a bright display, fast silicon, and a focused 48 MP camera.',
  ),
  'iphone-17' => (
    short: 'Colorful, capable, and effortlessly familiar.',
    long:
        'iPhone 17 brings a fluid display, versatile dual cameras, and dependable all-day performance to a refined everyday design.',
  ),
  'iphone-17e' => (
    short: 'Essential performance with a clean point of view.',
    long:
        'iPhone 17e focuses on the features that matter most: a crisp OLED display, a capable main camera, and efficient 5G performance.',
  ),
  'iphone-16' => (
    short: 'A proven favorite built for daily creativity.',
    long:
        'iPhone 16 combines responsive performance, a flexible dual-camera system, and familiar controls in a durable aluminum body.',
  ),
  'macbook-air-13' => (
    short: 'Portable performance in its most balanced form.',
    long:
        'MacBook Air 13-inch is tuned for mobile work with silent operation, a sharp Liquid Retina display, and day-long efficiency.',
  ),
  'macbook-air-15' => (
    short: 'More room to work, still easy to carry.',
    long:
        'MacBook Air 15-inch delivers an expansive workspace and immersive speakers without giving up the thin, fanless design.',
  ),
  'macbook-pro-14' => (
    short: 'Serious performance in a travel-ready studio.',
    long:
        'MacBook Pro 14-inch combines pro-class silicon, a high-contrast XDR display, and versatile ports for demanding production.',
  ),
  'macbook-pro-16' => (
    short: 'Maximum canvas and sustained pro performance.',
    long:
        'MacBook Pro 16-inch is designed for long creative sessions with a large XDR display, powerful cooling, and exceptional battery life.',
  ),
  'imac' => (
    short: 'A complete desktop shaped around color.',
    long:
        'iMac brings the computer, camera, speakers, and vivid 4.5K display together in one slim, expressive desktop.',
  ),
  'mac-mini' => (
    short: 'Big desktop capability in a remarkably small form.',
    long:
        'Mac mini is a flexible compact desktop with fast silicon, generous connectivity, and the freedom to choose your display.',
  ),
  'mac-studio' => (
    short: 'A compact creative engine for ambitious workflows.',
    long:
        'Mac Studio concentrates high-bandwidth performance, extensive ports, and quiet thermals into a desk-friendly enclosure.',
  ),
  'ipad-pro-11' => (
    short: 'Ultra-portable. Unmistakably pro.',
    long:
        'iPad Pro 11-inch pairs a vivid tandem-OLED display with desktop-class performance for drawing, editing, and mobile production.',
  ),
  'ipad-pro-13' => (
    short: 'The ultimate thin canvas for big ideas.',
    long:
        'iPad Pro 13-inch gives creative work more space with an expansive OLED panel, precise Pencil input, and pro-grade connectivity.',
  ),
  'ipad-air' => (
    short: 'Creative freedom in a light, colorful design.',
    long:
        'iPad Air balances powerful performance with Pencil and keyboard support for study, illustration, and everyday multitasking.',
  ),
  'ipad' => (
    short: 'A bright, versatile starting point for iPad.',
    long:
        'iPad makes notes, video calls, drawing, and entertainment approachable with a generous display and simple accessory support.',
  ),
  'ipad-mini' => (
    short: 'Full iPad capability in one hand.',
    long:
        'iPad mini fits reading, field notes, games, and Pencil sketches into a compact design that travels almost anywhere.',
  ),
  'watch-series-11' => (
    short: 'Everyday health insight with a polished profile.',
    long:
        'Apple Watch Series 11 combines a bright edge-to-edge display with useful health sensors, activity tools, and daily connectivity.',
  ),
  'watch-ultra-3' => (
    short: 'Built for distance, depth, and difficult terrain.',
    long:
        'Apple Watch Ultra 3 uses a rugged titanium case, precision GPS, and extended endurance for demanding outdoor sessions.',
  ),
  'watch-se-3' => (
    short: 'The essential smartwatch for staying connected.',
    long:
        'Apple Watch SE 3 covers activity, notifications, safety, and sleep in an approachable lightweight design.',
  ),
  'airpods-pro-3' => (
    short: 'Immersive sound with a more personal fit.',
    long:
        'AirPods Pro 3 combine adaptive noise control, detailed spatial audio, and four ear-tip sizes for focused everyday listening.',
  ),
  'airpods-4' => (
    short: 'Open-fit comfort with clearer, richer sound.',
    long:
        'AirPods 4 refine the open-ear shape while improving voice pickup, dynamic audio, and seamless device switching.',
  ),
  'airpods-max-2' => (
    short: 'Room-filling detail in an over-ear design.',
    long:
        'AirPods Max 2 pair sculpted ear cushions with high-fidelity drivers and active noise cancellation for long listening sessions.',
  ),
  'apple-pencil-pro' => (
    short: 'Precise creative control, right at your fingertips.',
    long:
        'Apple Pencil Pro adds pressure, tilt, squeeze, and haptic feedback for expressive drawing and exact annotation on compatible iPad models.',
  ),
  'magic-keyboard' => (
    short: 'A floating workspace for your iPad.',
    long:
        'Magic Keyboard combines a responsive keyboard, multi-touch trackpad, and adjustable viewing angle in a protective folding design.',
  ),
  'magsafe-charger' => (
    short: 'A precise magnetic connection for simple charging.',
    long:
        'MagSafe Charger aligns compatible devices automatically and delivers convenient wireless power through a compact USB-C cable.',
  ),
  'airtag' => (
    short: 'A simple way to keep track of everyday things.',
    long:
        'AirTag attaches to keys, bags, and luggage, combining nearby precision finding with a replaceable battery and privacy-minded alerts.',
  ),
  _ => throw ArgumentError.value(id, 'id', 'Missing product copy'),
};

Map<String, String> _specificationsFor(String id) => switch (id) {
  'iphone-17-pro' => const {
    'Display': '6.3-inch ProMotion OLED',
    'Chip': 'A19 Pro',
    'Cameras': '48 MP triple system',
    'Material': 'Titanium frame',
    'Battery': 'Up to 31 hours video',
    'Connectivity': '5G, Wi-Fi 7, USB-C',
  },
  'iphone-17-pro-max' => const {
    'Display': '6.9-inch ProMotion OLED',
    'Chip': 'A19 Pro',
    'Cameras': '48 MP triple system, 6x reach',
    'Material': 'Titanium frame',
    'Battery': 'Up to 37 hours video',
    'Connectivity': '5G, Wi-Fi 7, USB-C',
  },
  'iphone-air' => const {
    'Display': '6.6-inch OLED',
    'Chip': 'A19',
    'Cameras': '48 MP Fusion camera',
    'Material': 'Thin recycled aluminum',
    'Battery': 'Up to 27 hours video',
    'Connectivity': '5G, Wi-Fi 7, USB-C',
  },
  'iphone-17' => const {
    'Display': '6.3-inch high-refresh OLED',
    'Chip': 'A19',
    'Cameras': '48 MP dual system',
    'Material': 'Color-infused glass and aluminum',
    'Battery': 'Up to 26 hours video',
    'Connectivity': '5G, Wi-Fi 7, USB-C',
  },
  'iphone-17e' => const {
    'Display': '6.1-inch OLED',
    'Chip': 'A18',
    'Cameras': '48 MP single camera',
    'Material': 'Matte aluminum',
    'Battery': 'Up to 25 hours video',
    'Connectivity': '5G, Wi-Fi 6, USB-C',
  },
  'iphone-16' => const {
    'Display': '6.1-inch Super Retina OLED',
    'Chip': 'A18',
    'Cameras': '48 MP main + 12 MP ultra wide',
    'Material': 'Aerospace-grade aluminum',
    'Battery': 'Up to 22 hours video',
    'Connectivity': '5G, Wi-Fi 6E, USB-C',
  },
  'macbook-air-13' => const {
    'Chip': 'M-series 10-core platform',
    'Memory': '16–32 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display': '13.6-inch Liquid Retina',
    'Ports': 'MagSafe, 2× Thunderbolt',
    'Battery': 'Up to 18 hours',
  },
  'macbook-air-15' => const {
    'Chip': 'M-series 10-core platform',
    'Memory': '16–32 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display': '15.3-inch Liquid Retina',
    'Ports': 'MagSafe, 2× Thunderbolt',
    'Battery': 'Up to 18 hours',
  },
  'macbook-pro-14' => const {
    'Chip': 'Pro or Max platform',
    'Memory': '16–64 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display': '14.2-inch Liquid Retina XDR',
    'Ports': 'HDMI, SDXC, 3× Thunderbolt',
    'Battery': 'Up to 22 hours',
  },
  'macbook-pro-16' => const {
    'Chip': 'Pro or Max platform',
    'Memory': '16–64 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display': '16.2-inch Liquid Retina XDR',
    'Ports': 'HDMI, SDXC, 3× Thunderbolt',
    'Battery': 'Up to 24 hours',
  },
  'imac' => const {
    'Chip': 'M-series 8-core platform',
    'Memory': '16–32 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display': '24-inch 4.5K Retina',
    'Ports': 'Up to 4× USB-C',
    'Camera': '12 MP Center Stage',
  },
  'mac-mini' => const {
    'Chip': 'Pro or standard platform',
    'Memory': '16–32 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display support': 'Up to three external displays',
    'Ports': 'HDMI, Ethernet, Thunderbolt',
    'Power': 'Quiet 155 W integrated supply',
  },
  'mac-studio' => const {
    'Chip': 'Max or Ultra platform',
    'Memory': '32–128 GB unified',
    'Storage': '512 GB–2 TB SSD',
    'Display support': 'Up to five external displays',
    'Ports': 'Thunderbolt, HDMI, 10 Gb Ethernet',
    'Cooling': 'Dual-fan high-flow thermal system',
  },
  'ipad-pro-11' => const {
    'Display': '11-inch tandem OLED',
    'Chip': 'M-series pro platform',
    'Cameras': '12 MP wide + depth scanner',
    'Connectivity': 'Wi-Fi 6E or cellular',
    'Pencil': 'Apple Pencil Pro',
    'Keyboard': 'Magic Keyboard 11-inch',
  },
  'ipad-pro-13' => const {
    'Display': '13-inch tandem OLED',
    'Chip': 'M-series pro platform',
    'Cameras': '12 MP wide + depth scanner',
    'Connectivity': 'Wi-Fi 6E or cellular',
    'Pencil': 'Apple Pencil Pro',
    'Keyboard': 'Magic Keyboard 13-inch',
  },
  'ipad-air' => const {
    'Display': '11-inch Liquid Retina',
    'Chip': 'M-series performance platform',
    'Cameras': '12 MP front and rear',
    'Connectivity': 'Wi-Fi 6E or cellular',
    'Pencil': 'Apple Pencil Pro and USB-C',
    'Keyboard': 'Magic Keyboard compatible',
  },
  'ipad' => const {
    'Display': '10.9-inch Liquid Retina',
    'Chip': 'A-series efficiency platform',
    'Cameras': '12 MP landscape front and rear',
    'Connectivity': 'Wi-Fi 6 or cellular',
    'Pencil': 'USB-C Pencil support',
    'Keyboard': 'Keyboard Folio compatible',
  },
  'ipad-mini' => const {
    'Display': '8.3-inch Liquid Retina',
    'Chip': 'A-series compact platform',
    'Cameras': '12 MP front and rear',
    'Connectivity': 'Wi-Fi 6E or cellular',
    'Pencil': 'Apple Pencil Pro',
    'Keyboard': 'Bluetooth keyboards',
  },
  'watch-series-11' => const {
    'Case': '42 mm or 46 mm aluminum',
    'Display': 'Always-on edge-to-edge OLED',
    'Sensors': 'Heart rate, temperature, depth',
    'Battery': 'Up to 24 hours',
    'Connectivity': 'GPS or cellular',
    'Bands': 'Sport and woven quick-release',
  },
  'watch-ultra-3' => const {
    'Case': '49 mm natural titanium',
    'Display': 'High-brightness flat OLED',
    'Sensors': 'Depth, temperature, heart rate',
    'Battery': 'Up to 72 hours low-power',
    'Connectivity': 'Precision dual-band GPS + cellular',
    'Bands': 'Trail and ocean compatible',
  },
  'watch-se-3' => const {
    'Case': '40 mm or 44 mm aluminum',
    'Display': 'Bright LTPO OLED',
    'Sensors': 'Heart rate and motion safety',
    'Battery': 'Up to 18 hours',
    'Connectivity': 'GPS or cellular',
    'Bands': 'Universal compact band system',
  },
  'airpods-pro-3' => const {
    'Audio': 'Custom high-excursion driver',
    'Noise control': 'Adaptive active cancellation',
    'Microphones': 'Beamforming voice array',
    'Listening time': 'Up to 7 hours per charge',
    'Charging case': 'USB-C and wireless charging',
    'Fit': 'XS, S, M, L silicone tips',
  },
  'airpods-4' => const {
    'Audio': 'Low-distortion open-fit driver',
    'Noise control': 'Adaptive transparency',
    'Microphones': 'Voice-isolating dual array',
    'Listening time': 'Up to 6 hours per charge',
    'Charging case': 'Compact USB-C case',
    'Fit': 'Open-fit contoured shell',
  },
  'airpods-max-2' => const {
    'Audio': '40 mm dynamic driver',
    'Noise control': 'Over-ear active cancellation',
    'Microphones': 'Nine-microphone array',
    'Listening time': 'Up to 20 hours',
    'Charging': 'USB-C fast charge',
    'Fit': 'Memory-foam oval cushions',
  },
  'apple-pencil-pro' => const {
    'Compatibility': 'Selected iPad Pro and iPad Air models',
    'Material': 'Matte polymer body',
    'Dimensions': '166 mm × 8.9 mm',
    'Connection': 'Magnetic pairing',
    'Charging': 'Wireless magnetic charging',
    'Controls': 'Squeeze, roll, double tap',
  },
  'magic-keyboard' => const {
    'Compatibility': '11-inch or 13-inch iPad',
    'Material': 'Woven polyurethane shell',
    'Layout': 'Backlit low-profile keys',
    'Connection': 'Smart magnetic connector',
    'Charging': 'USB-C pass-through',
    'Adjustment': 'Floating multi-angle hinge',
  },
  'magsafe-charger' => const {
    'Compatibility': 'Magnetic wireless-charge devices',
    'Material': 'Aluminum and soft polymer',
    'Dimensions': 'Compact 60 mm charging disc',
    'Connection': 'Integrated USB-C cable',
    'Charging': 'Up to 15 W wireless',
    'Alignment': 'Automatic magnetic placement',
  },
  'airtag' => const {
    'Compatibility': 'Find My compatible devices',
    'Material': 'Polished steel and polymer',
    'Dimensions': '31.9 mm round enclosure',
    'Connection': 'Bluetooth and ultra-wideband',
    'Battery': 'Replaceable CR2032',
    'Resistance': 'IP67 dust and water resistance',
  },
  _ => throw ArgumentError.value(id, 'id', 'Missing specifications'),
};

List<String> _compatibilityFor(String id, ProductCategory category) =>
    switch (id) {
      'apple-pencil-pro' => const [
        'iPad Pro 11-inch',
        'iPad Pro 13-inch',
        'iPad Air',
      ],
      'magic-keyboard' => const ['iPad Pro', 'iPad Air'],
      'magsafe-charger' => const [
        'Magnetic-charge phones',
        'Wireless-charge earbuds',
      ],
      'airtag' => const ['Find My network', 'Precision-finding phones'],
      _ => switch (category) {
        ProductCategory.iphone => const [
          'MagSafe accessories',
          'USB-C accessories',
        ],
        ProductCategory.mac => const [
          'External displays',
          'USB-C and Thunderbolt accessories',
        ],
        ProductCategory.ipad => const [
          'Apple Pencil',
          'Bluetooth and keyboard accessories',
        ],
        ProductCategory.watch => const [
          'Quick-release bands',
          'Bluetooth audio',
        ],
        ProductCategory.airpods => const [
          'Bluetooth phones, tablets, and computers',
          'USB-C charging',
        ],
        ProductCategory.accessories => const [],
      },
    };

List<String> _includedItemsFor(String name, ProductCategory category) => [
  name,
  switch (category) {
    ProductCategory.iphone || ProductCategory.ipad => 'USB-C charge cable',
    ProductCategory.mac => 'Power adapter and charge cable',
    ProductCategory.watch => 'Magnetic charging cable',
    ProductCategory.airpods => 'USB-C charging case or cable as shown',
    ProductCategory.accessories => 'Product documentation',
  },
];

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
