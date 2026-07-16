# Vertical Slice Scene Map

```text
Splash → Home Hero → Product Carousel → Product Details → Product Configuration → Add to Bag
```

## Splash

- **Purpose:** Establish an original premium identity, not a loading screen.
- **Composition:** Short dark intro with an original abstract identity symbol and silver/cool-light reveal.
- **Action:** Continue automatically or tap to enter.
- **Hero / transition:** The revealed element resolves into Home background lighting or product illumination.
- **Micro-interactions:** One controlled reveal only.
- **Reduced motion:** Static symbol with a short fade; repeat launches are planned to skip or shorten this scene, not implemented yet.
- **Performance risks:** Overdraw from full-screen blur or layered glows.
- **Assets:** Original project symbol; optional lightweight lighting texture.
- **Exit state:** The final light direction and palette become the Home Hero environment.

## Home Hero

- **Purpose:** Introduce the main smartphone and invite product exploration.
- **Composition:** Full-screen product scene, not a card; a large phone, minimal text, and one primary action. Supporting ecosystem elements remain background atmosphere only.
- **Action:** Open the carousel or featured product.
- **Hero / transition:** Product image and lighting establish stable Hero source bounds.
- **Micro-interactions:** Subtle depth, translation, and lighting response.
- **Reduced motion:** Static product composition with opacity-only emphasis.
- **Performance risks:** Large decoded images, excessive opacity layers, and continuous sensor-like motion.
- **Assets:** Main smartphone hero image and optional supporting atmosphere imagery.
- **Exit state:** Main product, cool lighting, and title position connect to Carousel.

## Product Carousel

- **Purpose:** Compare the main and secondary smartphones through purposeful movement.
- **Composition:** Product remains central; background and text are secondary and update in staggered timing.
- **Action:** Swipe or select an indicator directly.
- **Hero / transition:** Selected product becomes the Hero source for details.
- **Micro-interactions:** Previous product exits in swipe direction; next enters with controlled translation, scale, and slight rotation. Avoid exaggerated 3D motion.
- **Reduced motion:** Crossfade product and text, retaining direct indicator selection.
- **Performance risks:** Simultaneous transforms, image retention, and rapid gesture updates.
- **Assets:** Main and secondary smartphone images, concise product metadata.
- **Exit state:** The selected product, background color, and Hero tag continue to Details.

## Product Details

- **Purpose:** Tell the selected product story while preparing purchase configuration.
- **Composition:** Hero product remains visually dominant; information appears progressively rather than as a standard product page. A sticky purchase action is planned.
- **Action:** Continue to configuration.
- **Hero / transition:** Product image continues through the Hero transition from Carousel.
- **Micro-interactions:** Measured progressive disclosure and limited, measurable scroll response.
- **Reduced motion:** Immediate information reveal; no scroll-linked transforms.
- **Performance risks:** Unbounded scroll effects, image scaling, and sticky action repaints.
- **Assets:** Selected product perspective/front image and concise feature copy.
- **Exit state:** Product stays prominent while its selected identity carries into Configuration.

## Product Configuration

- **Purpose:** Choose color and storage with unambiguous state.
- **Composition:** Product image and background react to color; selection summary stays visible with restrained chrome.
- **Action:** Select color/storage, then add to bag.
- **Hero / transition:** Preserve product continuity; selected variant is the source for bag confirmation.
- **Micro-interactions:** Color changes update product/background; storage changes transition price.
- **Reduced motion:** Instant variant and price changes with clear selected states.
- **Performance risks:** Holding many large color variants in memory and animated rebuilds.
- **Assets:** Main phone color variants, storage metadata, and price data.
- **Exit state:** Selected color, storage, price, and thumbnail feed Add to Bag.

## Add to Bag

- **Purpose:** Confirm the selected configuration and make cart state visible.
- **Composition:** Premium bottom sheet summarizes the selected configuration.
- **Action:** Confirm addition and dismiss or continue exploring.
- **Hero / transition:** Product thumbnail follows a curved path to the bag icon.
- **Micro-interactions:** Bag makes a small bounce; badge and total update. Prevent overlapping flights during rapid taps.
- **Reduced motion:** Simple fade/scale confirmation instead of the flight.
- **Performance risks:** Multiple animation controllers, overlapping tap flights, and expensive curved clipping.
- **Assets:** Small bag-animation thumbnail and bag icon.
- **Exit state:** Cart badge/total persist while the product scene remains available for return navigation.

## Asset assumptions

Minimum assets: main smartphone hero image; main smartphone transparent front or perspective image; main smartphone color variants; secondary smartphone image; small bag-animation thumbnail; background lighting or texture assets if needed; and an original project symbol. Record every external asset and its usage rights later in `ASSET_SOURCES.md`.

