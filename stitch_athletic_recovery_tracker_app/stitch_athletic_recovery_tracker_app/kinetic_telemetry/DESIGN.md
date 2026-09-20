---
name: Kinetic Telemetry
colors:
  surface: '#121317'
  surface-dim: '#121317'
  surface-bright: '#38393d'
  surface-container-lowest: '#0d0e12'
  surface-container-low: '#1a1b1f'
  surface-container: '#1e1f23'
  surface-container-high: '#292a2e'
  surface-container-highest: '#343539'
  on-surface: '#e3e2e7'
  on-surface-variant: '#bccbb7'
  inverse-surface: '#e3e2e7'
  inverse-on-surface: '#2f3034'
  outline: '#869583'
  outline-variant: '#3d4a3b'
  surface-tint: '#47e266'
  primary: '#55ee71'
  on-primary: '#003910'
  primary-container: '#30d158'
  on-primary-container: '#00541b'
  inverse-primary: '#006e26'
  secondary: '#ffc07a'
  on-secondary: '#482900'
  secondary-container: '#fa9b00'
  on-secondary-container: '#623a00'
  tertiary: '#91dcff'
  on-tertiary: '#003546'
  tertiary-container: '#52c3ef'
  on-tertiary-container: '#004e66'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6cff82'
  primary-fixed-dim: '#47e266'
  on-primary-fixed: '#002106'
  on-primary-fixed-variant: '#00531a'
  secondary-fixed: '#ffddbb'
  secondary-fixed-dim: '#ffb868'
  on-secondary-fixed: '#2b1700'
  on-secondary-fixed-variant: '#673d00'
  tertiary-fixed: '#bee9ff'
  tertiary-fixed-dim: '#68d3ff'
  on-tertiary-fixed: '#001f2a'
  on-tertiary-fixed-variant: '#004d64'
  background: '#121317'
  on-background: '#e3e2e7'
  surface-variant: '#343539'
typography:
  headline-xl:
    fontFamily: Geist
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 52px
    letterSpacing: -0.03em
  headline-xl-mobile:
    fontFamily: Geist
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.025em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Geist
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 26px
    letterSpacing: -0.015em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: -0.005em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0em
  metric-display:
    fontFamily: Geist
    fontSize: 44px
    fontWeight: '500'
    lineHeight: 44px
    letterSpacing: -0.03em
  metric-display-sm:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 28px
    letterSpacing: -0.02em
  label-caps:
    fontFamily: Geist
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 12px
    letterSpacing: 0.08em
  label-mono:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-desktop: 1rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system embodies high-performance athletic telemetry, clinical exactitude, and quiet biometric authority. Designed for elite athletes, performance physiologists, and deliberate practitioners, the interface operates as an unvarnished window into human biology.

The visual direction strips away gamified fitness tropes, dramatic sci-fi gradients, and decorative glow effects. Instead, it relies on strict precision: dense telemetry blocks, hairline grid lines, deep obsidian depth, and calibrated physiologic color tags. The emotional tone is stoic, analytical, and uncompromisingly professional—presenting complex circadian, autonomic, and mechanical strain signals with absolute clarity.

## Colors

The palette is engineered around high-contrast legibility against pure dark surfaces, referencing clinical monitors and matte-carbon hardware.

### Base Canvases & Structural Surfaces
- **Canvas Base (`#0A0B0D`):** Pure background void, anchoring all peripheral modules.
- **Card / Module Canvas (`#111215`):** Level 1 container surface providing essential contrast without lifting off the canvas.
- **Elevated Interactive Canvas (`#181A1F`):** Applied strictly to active toggles, inputs, and flyout sheets.
- **Hairline Border (`#1E2025` or `rgba(255, 255, 255, 0.06)`): Structural demarcation line for bounding boxes and segmented dials.

### Telemetric Accents (Physiologic Data Only)
- **Recovery / Baseline Homeostasis (`#30D158`):** Optimal parasympathetic tone, high HRV, restorative sleep states. Never used for marketing or generic success banners.
- **Cardiovascular Strain / Exertion (`#FF9F0A`):** Accumulated acute workload, metabolic demand, and elevated heart rate zones.
- **Circadian & Rest / Sleep Phases (`#64D2FF` & `#5E5CE6`):** REM architecture, delta slow-wave sleep, and baseline core body temperature shifts.
- **Critical Deviation / Warning (`#FF453A`):** System-level physiological anomalies (e.g., severe resting HR elevation, degraded readiness).

### Monochromatic & Data Grays
- **Primary Telemetry (`#F5F5F7`):** Primary tabular data values, scalar metric units, active titles.
- **Secondary Telemetry (`#8E8E93`):** Metric labels, static axes, passive status indicators.
- **Tertiary / Inactive (`#636366`):** Secondary intervals, chart tick marks, disabled states.

## Typography

Typography prioritizes numerical legibility and tabular discipline. All metric readouts must activate tabular figures (`font-variant-numeric: tabular-nums; font-feature-settings: "tnum" 1, "cv01" 1`) to eliminate jitter during real-time telemetry streaming.

- **Geist** powers numerical readouts, titles, and technical data headers. Its tight glyph geometric metrics maintain sharpness at micro and display scales.
- **Inter** handles narrative insight summaries, physiological notes, and continuous long-form context, providing balance against the dense numeric displays.
- **Telemetry Labels (`label-caps`):** Rendered in uppercase with generous tracking (`+0.08em`) to demarcate sections without introducing heavy dividers.

## Layout & Spacing

Layout operates on an uncompromising 4px/8px incremental grid designed for dense information density without visual crowding.

- **Mobile (< 768px):** Single-column layout with 16px (`margin`) safe gutters. Module cards occupy full viewport width minus margins. Multi-metric arrays use rigid 2-column or 3-column micro-grids with an 8px (`space-sm`) internal gap.
- **Tablet (768px - 1024px):** 6-column fluid structure. Telemetry panels sit side-by-side with circadian architecture charts. Outer padding increases to 24px (`margin-tablet`).
- **Desktop (> 1024px):** 12-column rigid analytical console capped at an absolute max-width of 1440px. Gutters lock to 16px (`gutter-desktop`), and margins expand to 40px (`margin-desktop`). Multi-pane telemetry is laid out strictly on horizontal coordinate planes to allow cross-metric temporal correlation.

## Elevation & Depth

Visual hierarchy rejects drop shadows, volumetric skeuomorphism, and chromatic blur rings. Depth is achieved purely through calibrated luminance tiering and ultra-precise borders.

1. **Floor (Base Layer):** Pure `#0A0B0D` matte carbon black. Represents zero elevation.
2. **Structural Enclosures (Level 1 Surface):** `#111215` enclosed with a 1px solid hairline border in `#1E2025` (`rgba(255, 255, 255, 0.06)`). No drop shadow.
3. **Focused / Hovered Modules (Level 2 Surface):** `#15171C` with the hairline border shifted to `rgba(255, 255, 255, 0.12)`.
4. **Overlays & Drawers (Level 3 Surface):** `#181A1F` backed by an unblurred or subtly masked matte barrier (`rgba(10, 11, 13, 0.85)`). Drops a sharp 0px 4px 16px `rgba(0, 0, 0, 0.6)` shadow solely to ensure boundary separation from layered background graphs.

## Shapes

The geometric architecture is tight and engineered. Radii are intentionally small to preserve a technical, instrument-grade impression rather than a consumer lifestyle aesthetic.

- **Standard Enclosures & Cards:** 4px (`roundedness: 1`). Provides clean edge definition while softening pure right angles.
- **Interactive Buttons & Badges:** 4px or strictly clipped inline elements.
- **Micro Tags & Bar Dividers:** 2px subtle radius for internal chart segments and split interval markers.
- **No Pill / Stadium Radii:** Stadium or circular shapes are strictly forbidden for buttons or card containers; they are reserved solely for circular biometric progress rings and sensor status indicators.

## Components

### 1. Telemetry Cards
- **Base Style:** Background `#111215`, border 1px solid `#1E2025`, border-radius 4px, padding 12px or 16px.
- **Header Structure:** Displays `label-caps` in `#8E8E93` flush left, paired with an optional micro status dot (4px, colored by metric state) flush right.
- **Data Anchor:** Main numeric value rendered in `metric-display` (`#F5F5F7`), immediately followed by an inline baseline unit (e.g., `ms`, `bpm`, `%`) in `label-mono` (`#8E8E93`).
- **Footer Delta:** Micro trend indicators (+3.2% vs 14-day baseline) using 11px Inter in neutral stone gray or contextual physiological state colors.

### 2. Buttons & Selectors
- **Primary Control:** Background `#F5F5F7`, text `#0A0B0D`, font weight 500, radius 4px, zero border. Reserved strictly for primary functional triggers (e.g., "Export Telemetry", "Calibrate Baseline").
- **Secondary / Ghost Control:** Background transparent, text `#F5F5F7`, border 1px solid `#1E2025`, radius 4px. On hover: border-color `rgba(255, 255, 255, 0.2)`.
- **Segmented Range Toggles (e.g., Day / Week / Month):** Contained group enclosed in `#0A0B0D` with 1px border. Inactive tabs render in `#8E8E93`. Active segment renders with background `#181A1F`, text `#F5F5F7`, and a 1px border `rgba(255, 255, 255, 0.08)`.

### 3. Biometric Chips & Status Tags
- Ultra-compact, low-profile indicators.
- Structure: Background `#15171C`, border 1px solid `#1E2025`, height 20px, horizontal padding 6px.
- Contains an inline 4px geometric dot in `#30D158`, `#FF9F0A`, or `#64D2FF`, followed by a `label-caps` string in `#F5F5F7`.

### 4. Continuous & Interval Telemetry Charts
- **Baseline Guides:** Rendered as 1px dashed or solid lines in `#1E2025`.
- **Data Series:** Hairline stroke (1.5px) using the corresponding physiologic accent color.
- **Area Fills:** Solid opacity descending from 12% at the apex to 0% at the baseline floor. Never use vivid multi-stop gradients.

### 5. Inputs & Sliders
- **Field:** Background `#0A0B0D`, border 1px solid `#1E2025`, focus border 1px solid `#8E8E93`.
- **Sliders (Time range / Strain targeting):** Track height 2px in `#1E2025`. Active fill line in accent color (`#FF9F0A` or `#30D158`). Handle is a solid 10px square or 10px circle in `#F5F5F7` with no halo or glow.