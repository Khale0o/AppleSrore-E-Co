import 'package:flutter/material.dart';

import 'spike_motion.dart';
import 'spike_product.dart';
import 'widgets/cinematic_product_carousel.dart';
import 'widgets/spike_product_copy.dart';
import 'widgets/spike_product_details.dart';
import 'widgets/spike_product_indicator.dart';

class CarouselHeroSpikeApp extends StatelessWidget {
  const CarouselHeroSpikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aether Motion Spike',
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const CarouselHeroSpike(),
    );
  }
}

class CarouselHeroSpike extends StatefulWidget {
  const CarouselHeroSpike({super.key});

  @override
  State<CarouselHeroSpike> createState() => _CarouselHeroSpikeState();
}

class _CarouselHeroSpikeState extends State<CarouselHeroSpike> {
  late final PageController _controller;
  int _selectedIndex = 0;
  int _direction = 1;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _selectedIndex) return;
    setState(() => _direction = index > _selectedIndex ? 1 : -1);
    _controller.animateToPage(
      index,
      duration: _reducedMotion ? SpikeMotion.fast : SpikeMotion.emphasis,
      curve: SpikeMotion.enter,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _direction = index == _selectedIndex
          ? _direction
          : (index > _selectedIndex ? 1 : -1);
      _selectedIndex = index;
    });
  }

  void _openDetails(SpikeProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SpikeProductDetails(
          product: product,
          reducedMotion: _reducedMotion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = spikeProducts[_selectedIndex];
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final page = _controller.hasClients
              ? (_controller.page ?? _selectedIndex.toDouble())
              : _selectedIndex.toDouble();
          final lower = page.floor().clamp(0, spikeProducts.length - 1);
          final upper = page.ceil().clamp(0, spikeProducts.length - 1);
          final t = (page - lower).clamp(0.0, 1.0);
          final start = Color.lerp(
            spikeProducts[lower].backgroundStart,
            spikeProducts[upper].backgroundStart,
            t,
          )!;
          final end = Color.lerp(
            spikeProducts[lower].backgroundEnd,
            spikeProducts[upper].backgroundEnd,
            t,
          )!;
          final accent = Color.lerp(
            spikeProducts[lower].accent,
            spikeProducts[upper].accent,
            t,
          )!;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [start, end],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 70,
                  right: -90 + (page - _selectedIndex) * 18,
                  child: IgnorePointer(
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(
                          alpha: _reducedMotion ? .08 : .15,
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26, 10, 18, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AETHER',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .72),
                                letterSpacing: 3,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Semantics(
                              label: 'Reduced Motion',
                              child: Row(
                                children: [
                                  Text(
                                    'Motion',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: .62,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Switch(
                                    key: const Key('reduced_motion_toggle'),
                                    value: _reducedMotion,
                                    onChanged: (value) =>
                                        setState(() => _reducedMotion = value),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                        child: SpikeProductCopy(
                          product: product,
                          direction: _direction,
                        ),
                      ),
                      Expanded(
                        child: CinematicProductCarousel(
                          controller: _controller,
                          products: spikeProducts,
                          reducedMotion: _reducedMotion,
                          onProductTap: _openDetails,
                          onPageChanged: _onPageChanged,
                        ),
                      ),
                      TextButton.icon(
                        key: const Key('explore_action'),
                        onPressed: () => _openDetails(product),
                        icon: const Icon(Icons.north_east_rounded, size: 18),
                        label: const Text('Explore'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(letterSpacing: 1.2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SpikeProductIndicator(
                        products: spikeProducts,
                        selectedIndex: _selectedIndex,
                        onSelected: _select,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
