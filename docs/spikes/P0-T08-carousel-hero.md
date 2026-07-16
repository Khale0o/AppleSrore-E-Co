# P0-T08: Carousel and Hero Spike

## Prototype structure

All spike code is isolated in `lib/spikes/carousel_hero/`: `carousel_hero_spike.dart` owns local carousel/reduced-motion state and direct `Navigator` routing; `spike_product.dart` holds two fictional products; `spike_motion.dart` holds timing values; widgets provide carousel, phone render, copy, indicator, and details scene.

## Animation approach

`PageController.page` supplies fractional progress. Each product's signed delta from its index determines dominant horizontal translation, subtle scale/opacity/vertical depth, and rotation capped at 3 degrees. The selected index is authoritative after page settling; indicator taps infer direction from the prior index and use the same controller motion. Background start/end/accent colors interpolate from the fractional page. Copy uses a short directional fade/slide switch, while the indicator has restrained width/color transitions.

## Hero strategy

Hero tags use `carousel-hero-product-<product-id>`. The source and destination share the same `SpikePhoneRender`, transparent padding, alignment, and aspect ratio; the reverse route returns to the preserved selected carousel product. Default Flutter Hero behavior was used; no custom shuttle was needed for the initial implementation.

## Reduced Motion

The temporary local toggle removes rotation, large translation, and drag-linked lighting depth. It retains swipe navigation, indicator selection, Hero navigation, and state changes; selection uses short controller movement and the existing crossfade/scale-friendly composition.

## What worked

- SDK-only isolated implementation with two original placeholder product renders.
- Direction-aware page-progress transforms and interpolated dark scene palettes are implemented.
- Matching Hero geometry and reverse navigation are implemented in code.

## Known limitations

- Placeholder-render quality is intentionally limited; no production imagery or device profiling has been completed.
- The spike has only two products, direct `Navigator` routing, local state, and a temporary Reduced Motion toggle.
- Emulator manual observations depend on the requested launch succeeding in the local terminal.

## Recommendation

**recommended with revisions.** The interaction pattern is appropriate for a later production feature, subject to real assets, device profiling, final routing/state architecture, and accessibility review.

## Production cautions

Do not copy the spike-local state structure, hard-coded fictional data, temporary Reduced Motion toggle, direct `Navigator` routing, placeholder renderer, or spike-only timing directly into production. Do not copy the entire spike directory into final features.

