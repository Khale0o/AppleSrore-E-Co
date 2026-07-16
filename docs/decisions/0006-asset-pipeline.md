# ADR 0006: Asset Pipeline

## Context

The cinematic slice depends on consistent, rights-cleared product imagery, while oversized or uncontrolled assets can compromise Hero continuity and Android performance.

## Decision

Use a role-first, locally recorded asset pipeline: verify rights before download, record every external source, normalize transparent canvases, create dedicated thumbnails, and prefer WebP where suitable. Add assets and `pubspec.yaml` declarations only when implementation first uses them.

## Alternatives considered

- Collect a broad ecosystem library before the slice is built.
- Use hotlinked or unverified web images.
- Use full-size marketing renders for all layouts.

## Consequences

Asset acquisition is deliberate and traceable, with more up-front source recording. Consistent crops and targeted image sizes improve Hero transitions and memory behavior.

## Revisit conditions

Revisit when verified platform support, production asset volume, or an approved remote image pipeline requires changes.

