# ADR 0005: Motion Strategy

## Context

The cinematic vertical slice needs consistent product-led motion without harming input responsiveness, readability, or mid-range Android performance.

## Decision

Use a three-level Flutter-SDK motion system: restrained Hero continuity, purposeful page transitions, and short micro-interactions. Use transform/opacity-first implementation, gesture interruption, and reduced motion as first-class behavior.

## Alternatives considered

- Decorative animation on most visible elements.
- Animation packages, Rive, Lottie, or shaders for the initial slice.
- Static navigation with no visual continuity.

## Consequences

Motion remains original, accessible, and easier to profile, but requires discipline in choreography and controller lifecycle handling. Product assets must support stable transition geometry.

## Revisit conditions

Revisit after device profiling, reduced-motion testing, or a demonstrated visual requirement that Flutter SDK APIs cannot meet efficiently.

