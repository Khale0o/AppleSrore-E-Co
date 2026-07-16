# ADR 0001: Feature-First Architecture

## Context

The first approved scope is a small cinematic vertical slice, while future ecosystem features may grow independently.

## Decision

Use the pragmatic feature-first structure described in `docs/architecture.md`. Add presentation, application, and data sublayers only when a feature needs them; use mock local product data until backend approval.

## Alternatives considered

- Strict Clean Architecture with repositories, use cases, and data sources from the outset.
- A flat, screen-first `lib/` structure.

## Consequences

Features own their implementation and shared code must earn its place through actual reuse. This reduces ceremony now but requires disciplined boundaries as complexity grows.

## Revisit conditions

Revisit when remote data, complex domain rules, multiple data sources, or several independently developed features require stronger boundaries.

