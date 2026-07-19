import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.path,
    required this.label,
    this.heroTag,
  });
  final String path, label;
  final String? heroTag;
  @override
  Widget build(BuildContext context) {
    final image = path.isEmpty
        ? _fallback()
        : Image.asset(
            path,
            fit: BoxFit.contain,
            semanticLabel: label,
            errorBuilder: (context, error, stackTrace) => _fallback(),
          );
    return heroTag == null ? image : Hero(tag: heroTag!, child: image);
  }

  Widget _fallback() => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xFF26313D), Color(0xFF0E1118)]),
      shape: BoxShape.circle,
    ),
    child: const Center(
      child: Icon(Icons.auto_awesome_outlined, color: Colors.white54, size: 38),
    ),
  );
}
