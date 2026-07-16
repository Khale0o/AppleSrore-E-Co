import 'package:flutter/material.dart';

@immutable
class SpikeProduct {
  const SpikeProduct({
    required this.id,
    required this.name,
    required this.finish,
    required this.metadata,
    required this.tagline,
    required this.backgroundStart,
    required this.backgroundEnd,
    required this.accent,
    required this.features,
  });

  final String id;
  final String name;
  final String finish;
  final String metadata;
  final String tagline;
  final Color backgroundStart;
  final Color backgroundEnd;
  final Color accent;
  final List<String> features;

  String get heroTag => 'carousel-hero-product-$id';
}

const spikeProducts = <SpikeProduct>[
  SpikeProduct(
    id: 'aether_one',
    name: 'Aether One',
    finish: 'Graphite',
    metadata: '6.4-inch luminous display',
    tagline: 'Precision shaped around light.',
    backgroundStart: Color(0xFF030508),
    backgroundEnd: Color(0xFF182634),
    accent: Color(0xFF9EDCFF),
    features: [
      'Ceramic-light body',
      'Quiet edge illumination',
      'All-day atmospheric power',
    ],
  ),
  SpikeProduct(
    id: 'aether_one_air',
    name: 'Aether One Air',
    finish: 'Frost Silver',
    metadata: '6.1-inch ambient display',
    tagline: 'Thin form. Expansive presence.',
    backgroundStart: Color(0xFF071013),
    backgroundEnd: Color(0xFF27323A),
    accent: Color(0xFFC7F5FF),
    features: [
      'Feathered metal frame',
      'Diffuse studio glow',
      'Calm, focused performance',
    ],
  ),
];
