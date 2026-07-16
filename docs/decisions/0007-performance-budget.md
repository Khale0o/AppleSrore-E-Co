# ADR 0007: Performance Budget

## Context

The vertical slice prioritizes cinematic product imagery and motion, which can cause jank or memory pressure without measurable constraints.

## Decision

Target smooth 60 FPS on a representative mid-range Android device, use profile mode for motion/scroll evaluation, and apply scene-specific limits on imagery, rebuilds, animation lifecycle, and add-to-bag concurrency. Treat emulator results as development feedback, not final approval.

## Alternatives considered

- Optimize every widget before implementation.
- Use emulator performance as final evidence.
- Set unsupported fixed memory targets before profiling.

## Consequences

Performance work is evidence-driven and focused on affected scenes. Phase 2 approval requires recorded profiling findings and reduced-motion validation.

## Revisit conditions

Revisit after real device profiling, supported high-refresh testing, or verified asset/motion complexity changes.

