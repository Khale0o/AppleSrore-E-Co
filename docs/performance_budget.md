# Performance Budget and Profiling Plan

## Target environment

- Primary development target: Android emulator, Android 14 API 34.
- Final approval must happen later on a representative mid-range Android device.
- Do not use debug mode for final performance conclusions. Use profile mode for animation/scrolling evaluation and release mode for final confirmation when needed.

## Frame targets

- Target smooth 60 FPS on a mid-range Android device; support 90/120 Hz devices where practical without device-specific animation logic.
- At 60 Hz, total frame time should usually stay below approximately 16.7 ms; at 120 Hz, below approximately 8.3 ms.
- Isolated first-decode spikes may occur, but repeated jank is unacceptable. Do not claim 120 FPS support until it is measured on suitable hardware.

## Scene budgets

### Splash

Keep it short; avoid shader-compilation dependencies and multiple full-screen blurred layers. Preload only assets immediately needed by Home.

### Home Hero

Use one dominant high-quality product image, limit continuously animated layers, avoid sensor-driven/endless motion, and stop or settle motion when inactive.

### Product Carousel

Keep only current, previous, and next product representations active where practical. Do not retain all full-resolution variants or rebuild unrelated text/navigation on each drag; gesture response must be immediate.

### Product Details

Limit active scroll transforms and simultaneous large-image decodes. Let sticky purchase UI repaint independently of heavy imagery where justified; never use blur as a persistent scroll effect.

### Product Configuration

Precache only the likely next color variant, avoid maximum-resolution decoding of every color, localize price/selection animation, and prevent business-state changes from rebuilding the scene.

### Add to Bag

Run one flight at a time using a small thumbnail. Cart state updates independently of visual completion; avoid expensive clipping and continuously recalculated paths.

## Image and memory rules

- Use layout-appropriate decode dimensions and dedicated hero/thumbnail files where roles differ.
- Limit simultaneous full-resolution product decodes and precache selectively, never globally.
- Dispose controllers and release scene references when no longer needed.
- Record real Phase 2 memory observations rather than inventing a fixed MB limit now.

## Rebuild and repaint rules

- Use `const` where appropriate; split stable from animated content.
- Prefer `AnimatedBuilder` with stable `child` content and keep providers/listeners narrowly scoped.
- Do not rebuild entire pages for carousel progress or configuration changes.
- Add `RepaintBoundary` only after repaint inspection or a clear isolation benefit.
- Avoid nested opacity, unnecessary clipping, and large save-layer effects.

## Animation lifecycle

Dispose every controller; stop loops/tickers off-screen with `TickerMode` or equivalent scene-aware behavior; settle/cancel motion safely on route changes; and do not let rapid input create uncontrolled controllers.

## Approval gates

The vertical slice is not approved until Splash-to-Home is stable; Carousel dragging/settling has no repeated visible jank; Hero works both directions without flicker; color switching avoids blank frames; Add-to-Bag does not overlap or leak; no persistent overflow/layout thrashing/repeated frame drops appear; Reduced Motion preserves function while removing expensive motion; `flutter analyze` and relevant tests pass; and Phase 2 findings are recorded.

## Measurement workflow

1. Confirm function in debug mode, then use the Android emulator for layout/interaction checks.
2. Evaluate animation and scrolling in profile mode.
3. Use Flutter DevTools Performance when visible jank occurs; inspect rebuilds/repaints only in the affected scene.
4. Test first and repeated interactions separately, including rapid swipes and rapid Add-to-Bag taps.
5. Test Reduced Motion, then re-test on a mid-range Android device before Phase 2 approval.
6. Record findings and remaining risks instead of applying speculative optimization.

## Anti-patterns

Do not optimize every widget before measuring, add `RepaintBoundary` everywhere, use large persistent blur or nested `Opacity`, rebuild pages from scroll position, load the ecosystem library at startup, keep all variants decoded, run long decorative animations, treat emulator results as final device proof, or hide jank by shortening animation without fixing its cause.

