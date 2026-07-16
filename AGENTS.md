# AppleStore Project Rules

## Project

- Project name: AppleStore; Flutter package: `applestore`.
- Unofficial educational and portfolio concept. Do not claim affiliation with or endorsement by Apple Inc.
- Do not use the Apple logo as the application identity.
- External assets must have documented usage rights.

## Working rules

- Complete one task only. Inspect existing files before editing and do not start future tasks.
- Do not rewrite working code without a clear reason; keep the project runnable.
- Do not add dependencies without justification; prefer Flutter SDK capabilities over unnecessary packages.
- Use feature-first architecture without excessive abstraction.
- Do not introduce Firebase or backend work before the premium vertical slice is approved.
- Record important decisions under `docs/decisions/` and external asset sources in `ASSET_SOURCES.md`.

## Quality priorities

1. User experience
2. Performance
3. Complete vertical slice
4. Code quality
5. Feature count

## Validation

- Format changed Dart files.
- Run `flutter analyze` after production-code changes.
- Run relevant tests after logic or widget changes.
- Do not rerun slow Flutter commands for documentation-only tasks.
- Report commands that were not run and explain why.

## Motion and performance

- Target smooth 60 FPS on a mid-range Android device and support high-refresh-rate devices where possible.
- Avoid excessive blur, opacity layers, overdraw, and large decoded images.
- Stop or reduce off-screen animations, support reduced motion, and give every animation a functional purpose.

## Documentation

- Create a concise task report after each task and a comprehensive handoff report at the end of each phase.
- Document incomplete or deferred work explicitly.

