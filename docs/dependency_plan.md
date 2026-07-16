# Dependency Plan

No dependencies are installed by this task. Select exact versions from current compatible releases immediately before installation.

## Phase 1 candidates

| Dependency | Purpose | Why not SDK alone | Risks | Required immediately |
| --- | --- | --- | --- | --- |
| `flutter_riverpod` | Shared product configuration, shared carousel selection, cart state, reduced-motion preference, and repository access. | Flutter widget state is ideal for local state but becomes brittle for scoped state shared across the vertical slice. | Provider sprawl and unnecessary indirection. Keep local visual state in widgets. | Yes, when shared vertical-slice state is implemented. |
| `go_router` | Declarative navigation, stable paths/names, deep-link readiness, and custom page transitions. | Navigator can work, but route parsing, deep-link handling, and scalable declarative routing are less appropriate to hand-roll. | Premature route hierarchy and overuse of nested navigators. | Yes, when app navigation is implemented. |
| `flutter_svg` | Render licensed vector branding or interface assets. | Flutter has no native SVG renderer. | Asset rendering cost and unverified licensing. | No; add only if approved licensed SVG assets are used. |
| `shared_preferences` | Persist a simple user preference, such as reduced motion, when persistence is implemented. | Flutter does not provide cross-launch key-value preference storage. | Incorrectly treating it as secure or structured storage. | No; add only with a real persistence requirement. |

## Add only when needed later

- `freezed` and `json_serializable`: only when model complexity or repetitive immutable code justifies code generation.
- `dio`: only when a remote API requires advanced networking capabilities.
- `cached_network_image`: only when remote product imagery is approved.
- `flutter_secure_storage`: only when sensitive credentials or tokens exist.
- Firebase packages: only after backend work is explicitly approved.
- Rive or Lottie: only for approved, purposeful motion that cannot be delivered efficiently with Flutter.
- A local database package: only when product, cart, or offline data exceeds simple preferences.
- Crash reporting: only when a release/operational plan calls for it.

## Avoid by default

- Carousel packages; use Flutter scrolling/page primitives for the direction-aware carousel.
- Animation helper packages; use Flutter's animation APIs unless a clear gap emerges.
- Glassmorphism, responsive scaling, parallax, and unmaintained fake-3D packages.
- Packages that replace simple Flutter SDK widgets.

