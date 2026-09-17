---
name: Kinetic Obsidian
colors:
  surface: '#121316'
  surface-dim: '#121316'
  surface-bright: '#38393d'
  surface-container-lowest: '#0d0e11'
  surface-container-low: '#1b1b1f'
  surface-container: '#1f1f23'
  surface-container-high: '#292a2d'
  surface-container-highest: '#343538'
  on-surface: '#e3e2e6'
  on-surface-variant: '#bacbbc'
  inverse-surface: '#e3e2e6'
  inverse-on-surface: '#2f3034'
  outline: '#849587'
  outline-variant: '#3b4a3f'
  surface-tint: '#00e388'
  primary: '#b4ffcb'
  on-primary: '#00391e'
  primary-container: '#00f090'
  on-primary-container: '#00683b'
  inverse-primary: '#006d3e'
  secondary: '#a5e7ff'
  on-secondary: '#003543'
  secondary-container: '#00d2ff'
  on-secondary-container: '#00566a'
  tertiary: '#ffeae1'
  on-tertiary: '#561f00'
  tertiary-container: '#ffc5ab'
  on-tertiary-container: '#993d00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#58ffa5'
  primary-fixed-dim: '#00e388'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#00522e'
  secondary-fixed: '#b6ebff'
  secondary-fixed-dim: '#47d6ff'
  on-secondary-fixed: '#001f28'
  on-secondary-fixed-variant: '#004e60'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb693'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7a3000'
  background: '#121316'
  on-background: '#e3e2e6'
  surface-variant: '#343538'
typography:
  display-hero:
    fontFamily: Space Grotesk
    fontSize: 56px
    fontWeight: '700'
    lineHeight: 60px
    letterSpacing: -0.04em
  display-hero-mobile:
    fontFamily: Space Grotesk
    fontSize: 44px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.03em
  headline-metric:
    fontFamily: Space Grotesk
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-metric-mobile:
    fontFamily: Space Grotesk
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: '0'
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: '0'
  body-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: 0.005em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-data:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.08em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-compact: 0.5rem
  margin: 1rem
  margin-sm: 0.75rem
  space-2xs: 0.125rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
  space-2xl: 2rem
---

## Brand & Style

This design system expresses high-performance biometric mastery: a technical, focused, and quiet aesthetic engineered for elite athletes, data-driven biohackers, and recovery-obsessed performers. The interface evokes a subterranean telemetry station or an ultra-luxury cockpit, stripping away extraneous consumer-app decoration to spotlight physiological telemetry.

The visual style merges pure OLED darkness, tactile frosted-glass depth, and laser-precise neon luminescence:
- **True Pitch Foundation:** Leverages deep OLED black backgrounds to eliminate screen boundaries and maximize battery efficiency during 24/7 wear monitoring.
- **Bioluminescent Signaling:** Employs narrow-spectrum, high-saturation accents strictly for data attribution—not decoration. Every hue conveys an exact physiological readiness tier or biological domain.
- **Instrumentation Realism:** Integrates micro-borders, sub-pixel edge lighting, and high-density monospaced data readouts to project laboratory-grade instrumentation.

## Colors

The palette operates on a calibrated luminance model where semantic state dictates visual dominance:

- **Recovery Emerald (`#00F090` / secondary grade `#10B981`):** Serves as primary validation. Represents primed autonomous nervous systems, optimal HRV balance, and readiness scores between 67% and 100%.
- **Deep Cyan & Restorative Azure (`#00D2FF` / `#38BDF8`):** Dictates sleep cycles, slow-wave sleep (SWS), baseline skin temperature, and parasympathetic dominant states.
- **Kinetic Amber & Solar Orange (`#FF6B00` / `#F59E0B`):** Denotes day strain accumulation, target cardiovascular training zones (Zone 3–5), and systemic caloric load.
- **Stress Crimson (`#FF3B56`):** Indicates low recovery (<33%), acute physical exhaustion, irregular arterial pulse metrics, or autonomic nervous system duress.
- **Neural Violet (`#8B5CF6`):** Applied specifically to REM sleep phases, predictive algorithm recommendations, and synthetic biomarker modeling.

### Surface Architecture
- **Canvas Base:** `#08090C` (Absolute deep field, 0% opacity interference).
- **Surface Elevation 1 (Cards):** `#111318` (Low-reflectance midnight alloy).
- **Surface Elevation 2 (Elevated Sheets/Widgets):** `#181B22` (Subtle blue-gray tint).
- **Surface Overlay (Interactive States):** `rgba(255, 255, 255, 0.04)`.
- **Structural Separation:** `rgba(255, 255, 255, 0.08)` hairline borders across card perimeters.

## Typography

Typography establishes an uncompromising hierarchy between macro performance scores and real-time raw biometrics.

- **Numeric Figures & Primary Scores (`Space Grotesk`):** Displays overall scores (Strain 0.0–21.0, Recovery 0–100%, Sleep Quality %). Characterized by tight tracking, geometric curves, and assertive athletic presence.
- **Biometric Telemetry & Timestamps (`JetBrains Mono`):** All tabular data—including real-time BPM, millisecond HRV (rMSSD), respiratory rate, and delta changes—must render in monospaced format with tabular figures (`tnum`) to eliminate micro-jittering during continuous 1 Hz wireless data streaming.
- **Core Interface & Content (`Inter`):** Powers system headers, descriptive coaching feedback, sleep stage breakdowns, and metric explanations with optimized vertical cadence and neutral clarity.
- **Capitalization Rules:** Domain section headers and badge labels utilize `label-caps` in all caps (`text-transform: uppercase`) with `0.08em` tracking to deliver tactical clarity.

## Layout & Spacing

The layout is built for high-density mobile viewports (optimized for 390px–412px handheld canvases) with rigorous structural compression:

- **Grid Framework:** A 4-column fluid mobile grid with `margin: 1rem` (16px) and `gutter: 0.75rem` (12px). Metric cards span full width (4 columns) or split into dual telemetry tiles (2 columns each).
- **Baseline Metric Grid:** Anchored to a strict 4px sub-grid (`0.25rem`). Padding inside data cards follows an asymmetric formula: vertical `space-md` (12px) and horizontal `space-lg` (16px) to maximize horizontal scan-width for charts and sparklines.
- **Vertical Hierarchy:**
  - Section blocks separate via `space-xl` (24px).
  - Metric sub-items within a singular card divide via `space-sm` (8px).
  - High-density telemetry counters keep numeric readouts and metric unit tags bound at `space-xs` (4px).
- **Thumb Zone Safety:** Bottom action sheets and the floating navigation dock maintain an absolute minimum bottom clearance of `2.25rem` (36px) above home indicator zones.

## Elevation & Depth

Visual separation bypasses heavy drop shadows in favor of luminosity layering, surface luminance stacking, and precision edge diffraction:

- **Surface Layering (Tonal Stepping):**
  - *Layer 0 (Canvas):* Deep void `#08090C`.
  - *Layer 1 (Card Matrix):* `#111318` background with an outer border of `1px solid rgba(255, 255, 255, 0.08)`.
  - *Layer 2 (Embedded Pods / Progress Tracks):* `#0B0D11` recessed inset surfaces, conveying physical enclosure inside the card.
  - *Layer 3 (Floating Bars / Dialogs):* `#181B22` with a subtle top edge highlight: `inset 0 1px 0 0 rgba(255, 255, 255, 0.12)`.
- **Glassmorphism & Optical Diffusion:**
  - Dynamic navigation dock and header app bars use `backdrop-filter: blur(20px) saturate(180%)` over `rgba(8, 9, 12, 0.78)`.
- **Photonic Glow (Data Halos):**
  - High-potency metrics (e.g., green 98% Recovery or orange 18.2 Strain) project a soft atmospheric back-glow: `box-shadow: 0 0 32px -8px rgba(accent_color, 0.22)`. This treatment is restricted to primary radial meters and active tracking indicators.

## Shapes

The geometry balances ergonomic hand-feel with structural engineering aesthetics:

- **Primary Cards & Containers:** Standardized at `rounded-lg` (`1rem` / 16px) to echo the physical radiuses of modern handheld devices.
- **Telemetry Pods & Sub-Tiles:** Set at standard `roundedness` (`0.5rem` / 8px) to establish clean nesting geometry within parent cards.
- **Pills, Badges & Dynamic Status Toggles:** Strict continuous capsules (`rounded-full` / `9999px`) to immediately distinguish active status tags, workout markers, and biometric qualifiers from analytical content blocks.
- **Dividers & Tick Marks:** 1px stroke widths with zero rounding on data axes to reinforce calibrated gauge instrumentation.

## Components

### 1. Radial Score Gauge (Signature Component)
- **Geometry:** 220px circular vector arc with an 8px track width.
- **Track Styling:** Recessed track rendered in `rgba(255, 255, 255, 0.06)` with rounded stroke ends. Active arc dynamically painted in neon recovery, cyan, or kinetic orange.
- **Center Cluster:** Contains the headline score in `display-hero`, a small uppercase status pill (`label-caps`) floating directly below, and real-time delta baseline values in `JetBrains Mono`.

### 2. Biometric Metric Cards
- **Architecture:** `#111318` surface container framed by `rgba(255, 255, 255, 0.08)` borders.
- **Header:** Metric title in `label-caps` (dimmed to `rgba(255, 255, 255, 0.5)`), pairing an icon tinted with domain-specific accent color.
- **Value Row:** Numeric readouts in `headline-metric` paired with unit descriptors (`ms`, `bpm`, `hrs`) in `label-data`.
- **Footer:** Integrated 40px sparkline or multi-stage horizontal distribution bar (e.g., Deep, Light, REM, Awake breakdown) with zero outer margins.

### 3. Precision Buttons
- **Primary CTA:** Solid accent fill (e.g., `#00F090`) with high-contrast pitch black text (`#08090C`, weight 600). Radius set to `0.5rem` (8px). Pressed state reduces scale to `0.98` with an inner shadow `inset 0 2px 4px rgba(0,0,0,0.3)`.
- **Ghost / Glass CTA:** Background `rgba(255, 255, 255, 0.04)`, hairline border `rgba(255, 255, 255, 0.12)`, text `#FFFFFF`. On active touch: `rgba(255, 255, 255, 0.08)`.

### 4. Physiological Status Chips & Trend Badges
- **Structure:** Capsule geometry (`rounded-full`) with vertical padding of `2px` and horizontal padding of `8px`.
- **States:**
  - *Optimal:* Fill `rgba(0, 240, 144, 0.12)`, text `#00F090`, border `1px solid rgba(0, 240, 144, 0.3)`.
  - *Elevated:* Fill `rgba(255, 107, 0, 0.12)`, text `#FF6B00`, border `1px solid rgba(255, 107, 0, 0.3)`.
  - *Suppressed:* Fill `rgba(255, 59, 86, 0.12)`, text `#FF3B56`, border `1px solid rgba(255, 59, 86, 0.3)`.

### 5. Floating Navigation Dock
- **Layout:** Suspended horizontal pill docked 16px from screen borders, with `backdrop-filter: blur(24px)` over `#111318` at 85% opacity.
- **Navigation Items:** 5 tactical tabs (Today/Pulse, Recovery, Strain, Sleep, Trends).
- **Active State Indicator:** An illuminated 3mm indicator dot tinted with the respective section accent positioned directly beneath the icon, accompanied by a micro-radial blur beneath the glyph.

### 6. Tabular Biometric Lists
- **Structure:** Zero-line separation; items rely on `space-md` alternating vertical pacing.
- **Columns:** Left-aligned biological marker name (e.g., "Heart Rate Variability"), right-aligned live value in `JetBrains Mono` with an accompanying mini trend glyph (`↑`, `↓`, or `—`).