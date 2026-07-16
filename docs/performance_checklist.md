# Performance Checklist

## Before implementation

- [ ] Define layout-appropriate asset sizes and decode strategy.
- [ ] Identify only the next likely hero/variant for precaching.
- [ ] Define Reduced Motion behavior for every planned motion path.

## During implementation

- [ ] Dispose controllers and stop off-screen animations/tickers.
- [ ] Keep carousel/configuration rebuild scope narrow; split stable and animated content.
- [ ] Avoid persistent blur, nested opacity, unnecessary clipping, and speculative `RepaintBoundary` use.
- [ ] Test rapid swipes and repeated Add-to-Bag taps.

## Before task completion

- [ ] Observe the changed scene in profile mode when it has motion, scrolling, or large imagery.
- [ ] Run `flutter analyze` and relevant tests after production-code changes.
- [ ] Record findings, jank risks, asset observations, and unresolved issues in the task report.

## Phase 2 profiling gate

- [ ] Profile Splash-to-Home, Carousel, Hero transition, color switching, and Add-to-Bag.
- [ ] Confirm Reduced Motion preserves interactions while removing expensive motion.
- [ ] Check first versus repeated interaction behavior.
- [ ] Re-test on a representative mid-range Android device.
- [ ] Record profile-mode findings before approval.

