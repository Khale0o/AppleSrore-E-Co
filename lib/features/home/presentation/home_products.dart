import 'package:flutter/material.dart';

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.finish,
    required this.tagline,
    required this.metadata,
    required this.price,
    required this.start,
    required this.end,
    required this.accent,
    required this.cameraCount,
    required this.widthFactor,
  });
  final String id, name, finish, tagline, metadata, price;
  final Color start, end, accent;
  final int cameraCount;
  final double widthFactor;
  String get heroTag => 'home-product-$id';
}

const homeProducts = <HomeProduct>[
  HomeProduct(
    id: 'aether-pro',
    name: 'Aether Pro',
    finish: 'Graphite Alloy',
    tagline: 'Clarity, shaped for the dark.',
    metadata: '6.5-inch cinematic display',
    price: 'From 899',
    start: Color(0xFF04070B),
    end: Color(0xFF162C3B),
    accent: Color(0xFF9EDDF8),
    cameraCount: 3,
    widthFactor: 1,
  ),
  HomeProduct(
    id: 'aether-air',
    name: 'Aether Air',
    finish: 'Frost Silver',
    tagline: 'Thin form. Expansive presence.',
    metadata: '6.2-inch luminous display',
    price: 'From 749',
    start: Color(0xFF071012),
    end: Color(0xFF2D3840),
    accent: Color(0xFFC8F5FF),
    cameraCount: 2,
    widthFactor: .91,
  ),
  HomeProduct(
    id: 'aether-mini',
    name: 'Aether Mini',
    finish: 'Midnight Blue',
    tagline: 'Essential light, held close.',
    metadata: '5.8-inch focused display',
    price: 'From 599',
    start: Color(0xFF06080D),
    end: Color(0xFF18233D),
    accent: Color(0xFF9DBAFF),
    cameraCount: 2,
    widthFactor: .82,
  ),
];
HomeProduct productForId(String id) => homeProducts.firstWhere(
  (product) => product.id == id,
  orElse: () => homeProducts.first,
);
