# Architecture

## Direction

AppleStore will use pragmatic feature-first Flutter architecture, not strict Clean Architecture. The project is intentionally small until its premium vertical slice is approved, so structure must support change without creating empty layers.

```text
lib/
  app/
    app.dart
    router/
    theme/
    design_system/
  core/
    animations/
    extensions/
    performance/
    utils/
  shared/
    models/
    widgets/
  features/
    splash/
    home/
    catalog/
    product_details/
    product_configuration/
    cart/
```

This is a proposed structure only; these directories must not be created until implementation tasks need them.

## Boundaries

- Each feature may add `presentation`, `application`, and `data` only when its needs justify them.
- Do not automatically create repository, use-case, or data-source layers.
- Place code in `shared/` only when it is genuinely reused across features; otherwise keep it with its feature.
- Use mock local product data until a backend is explicitly approved.
- Keep business state outside visual animation widgets. UI-only ephemeral animation state may stay inside the owning widget.
- `app/` owns application composition, routing, theme, and the design system. `core/` contains low-level, non-feature-specific capabilities.

