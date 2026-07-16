# ADR 0002: State Management

## Context

The vertical slice needs state shared across product configuration, cart, reduced-motion preference, repository access, and possibly carousel selection.

## Decision

Adopt `flutter_riverpod` when shared state is implemented. Keep simple local visual and ephemeral animation state in Flutter widgets. Do not introduce code generation initially; reconsider Riverpod annotations/generator only if later complexity justifies them.

## Alternatives considered

- Flutter widget state only.
- InheritedWidget/Provider-style manual state propagation.
- Bloc or Redux-style architectures.

## Consequences

Shared business state is explicit and testable without promoting every UI value to a provider. The project must avoid provider sprawl.

## Revisit conditions

Revisit if application state remains purely local, or if generated providers materially reduce proven complexity.

