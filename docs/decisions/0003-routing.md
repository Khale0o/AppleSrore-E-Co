# ADR 0003: Routing

## Context

The cinematic product journey needs stable navigation paths, custom transitions, and future deep-link readiness.

## Decision

Adopt `go_router` when routing is implemented. Use declarative routes with stable names and paths, preserve feature ownership of Hero tags, and use custom page transitions where they support continuity.

## Alternatives considered

- Imperative Navigator-only routing.
- A custom RouteInformationParser/router implementation.

## Consequences

Navigation is structured for deep links without hand-built parsing. Do not add nested navigators or shell routes during the first vertical slice unless a real requirement emerges.

## Revisit conditions

Revisit when a verified navigation flow requires independent navigation stacks or a shell layout.

