# Motion System

## Principles

- Product motion is deliberate, weighted, and visually dominant; controls move faster and a shorter distance.
- Motion communicates hierarchy, direction, continuity, or state. Do not animate every visible element.
- Prefer transforms and opacity over expensive blur or clipping. Gesture animations must be interruptible.
- Navigation remains functional when animation is disabled.

## Motion levels

### Hero motion

Use Hero continuity for Carousel-to-Details product imagery, Splash identity resolving into Home lighting, and the product thumbnail moving to the bag. Keep source and destination geometry stable, avoid large shape changes and competing Heroes, and introduce custom flights only when Flutter's default Hero behavior is insufficient.

### Page transitions

Use page transitions for Splash-to-Home, Home-to-Carousel, Carousel-to-Details, and Details-to-Configuration. Product continuity takes priority over full-page movement; background and product may move separately. Avoid generic horizontal slides unless direction is meaningful. Back navigation should reverse or gracefully simplify the forward transition.

### Micro-interactions

Use for press states, carousel indicators, color/storage selection, price updates, bag bounce, badge updates, and bottom-sheet entry. Keep distance small, duration short, and feedback immediate. Do not repeat bounce or overshoot without a functional reason.

## Motion tokens

```text
instant: 80–120 ms
fast: 140–200 ms
standard: 240–320 ms
emphasis: 360–480 ms
hero: 500–700 ms
```

Use standard enter, standard exit, emphasized enter, and gesture-following linear-progress curve families. Reserve a gentle spring for bag/badge feedback only. Tune exact values after profile testing; do not proliferate custom curves.

## Choreography

- Product entrance begins before secondary text finishes appearing; the primary title may lead supporting metadata by a 40–80 ms stagger.
- Begin an exit slightly before the next scene fully enters, without long sequential chains.
- Make user controls usable before decorative motion completes.

## Direction-aware carousel

- Swipe direction determines entry and exit direction; product translation is dominant.
- Use scale and rotation only as subtle secondary effects; rotation usually stays within 2–4 degrees.
- Do not aggressively combine scale, rotation, blur, and opacity.
- Rapid swipes settle to one authoritative selected index. Direct indicator taps use the same directional rules.

## Scroll-driven motion

- Convert scroll offset to normalized, clamped progress and animate only the relevant scene range.
- Avoid rebuilding the whole page on each scroll update, continuous blur, and large clipping operations.
- Pause or simplify off-screen effects. Effects enhance depth and must not block reading.

## Add to bag

- Run only one product-flight animation at a time. During flight, ignore extra taps, queue one, or update quantity without another flight.
- Use transform-based curved positioning rather than expensive clipping.
- Cart state updates independently of animation completion; bag bounce and badge changes stay subtle.

## Reduced motion

- Prefer fade and short scale; remove product rotation, large travel distances, and scroll-linked transforms.
- Replace the product-to-bag flight with an immediate state update and compact confirmation.
- Preserve every interaction and state change. Reduced motion is first-class behavior.

## Interruption and lifecycle

- Gesture-controlled motion follows the gesture. Dispose every controller and cancel or settle motion when routes change.
- Do not leave loops active off-screen or restart identical animations from rapid taps.
- App lifecycle pauses must not corrupt state.

## Initial implementation policy

- Prefer Flutter SDK animation APIs; do not add Rive, Lottie, animation-helper packages, or shaders in the first vertical slice.
- Use `AnimationController` only when implicit widgets are insufficient.
- Use `AnimatedBuilder` with stable child widgets for expensive compositions.
- Introduce `RepaintBoundary` only when profiling or repaint isolation justifies it.

