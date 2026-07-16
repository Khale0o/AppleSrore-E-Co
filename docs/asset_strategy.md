# Asset Strategy

## Goals

Product imagery must stay consistent across scenes and support Hero transitions, color changes, responsive layouts, and future optimization. The first slice uses one main smartphone, one secondary smartphone, and minimal ecosystem atmosphere; do not collect the full ecosystem asset set yet.

## Required first-slice assets

### Branding

- Original project symbol, with light/dark variants only if needed. Never use the Apple logo.

### Main smartphone

- Hero perspective; transparent front or three-quarter perspective; color variants; optional back/side view; and a dedicated small bag-flight thumbnail.

### Secondary smartphone

- One high-quality transparent or isolated render.

### Backgrounds and icons

- Optional lightweight lighting and subtle gradient/noise textures. Prefer Flutter-generated gradients over large full-screen rasters.
- Prefer Flutter built-in icons where suitable. Add custom SVG only when design requires it and licensing is clear.

## Proposed directories

```text
assets/
  branding/
  products/
    smartphones/
      main_phone/
        colors/
          graphite/
          silver/
          blue/
        hero/
        thumbnails/
      secondary_phone/
  backgrounds/
  textures/
  icons/
  placeholders/
```

Create these directories only when assets are introduced.

## Naming

Use lowercase `snake_case`, include product/color where relevant and the asset role, and never use spaces or vague names such as `image1.png`.

```text
main_phone_graphite_hero.webp
main_phone_silver_perspective.webp
main_phone_blue_bag_thumbnail.webp
secondary_phone_graphite_front.webp
```

## Source and licensing

Allowed sources: official press/media assets when their terms permit intended use, licensed stock, original assets, generated placeholders with clear provenance, and rights-cleared mock product renders.

Do not use random copied website images, unverified marketplace images, hotlinked final-app images, or assets without a recorded source and usage note. Record every external asset in `ASSET_SOURCES.md` before production use.

## Processing pipeline

1. Identify the required role and target scene.
2. Verify source and usage rights, download locally, and record the source immediately.
3. Remove backgrounds only when legally and visually appropriate; crop excess transparent space.
4. Normalize canvas and visual scale across variants; create thumbnails separately.
5. Convert to WebP when quality/transparency allow, then compress without visible degradation.
6. Add to `pubspec.yaml` only when first used; verify every declared asset is used.
7. Replace weak placeholders without blocking unrelated implementation.

## Formats

- WebP is the preferred raster default when suitable; retain PNG when transparency quality or tooling requires it.
- Use SVG only for approved vector branding/icons.
- Do not use AVIF in the first slice unless Flutter/device support and decoding performance are explicitly validated.
- Do not use animated image formats for product motion.

## Resolution and memory

- Do not load oversized original marketing renders directly. Prepare practical sizes only for real layouts.
- Precache only the next likely hero/variant; never decode every color variant at full resolution simultaneously.
- Bag thumbnails are small dedicated files, not scaled hero images. Keep transparent padding consistent to prevent Hero jumps.
- Test imagery on the representative Android emulator and later on a mid-range device.

## Placeholders and acceptance

Missing assets must not block unrelated work: use a clearly labeled original placeholder, record it in the task report, and never silently ship it as final.

Approve an asset only when its source/usage basis is recorded; resolution is sufficient but not excessive; background, crop, color variants, and transparent padding are consistent; compression has no obvious artifacts; light/dark contexts work where needed; and it has a clear in-project role.

