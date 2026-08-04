# defmodule.io — Experience Section Spec

Add a new homepage section beneath the hero. Uses the existing "defmodule" daisyUI theme; no new theme values needed except `--text-lo: #8B87A8` if not already defined.

## Content

- Kicker: `// experience` — small, JetBrains Mono, `#7F77DD`
- H2 (mono, base-content, medium weight):
  **"Fifteen years in production. Six on the BEAM."**
- Snippet (sans, `--text-lo`, max-width ~540px):
  "A decade of shipping production systems, then a deliberate move all-in
  on Elixir — Phoenix and LiveView ever since, with IoT-over-PubSub and
  geospatial pipelines along the way."

## Timeline Graph

Horizontal Gantt-style bars. Two-column grid: label (~130px, mono, 11px,
`#CECBF6`) + full-width track. Track: `bg-neutral` (#1C1930), rounded,
~22px tall. X-axis spans 2011 → 2026 with year ticks below
(2011 / 2014 / 2017 / 2020 / 2023 / 2026, `--text-lo`, 10px).

Bars (position as % of the 2011–2026 span):

1. **Production systems** — 2011 → now (full width).
   Muted gradient `#1C1930` → `#3C3489`. Understated foundation bar.
   Label inside right edge: "2011 →"
2. **Elixir / OTP** — ~2020 → now (left: 60%, width: 40%).
   Primary gradient `#26215C` → `#534AB7`. Label: "2020 →"
3. **Phoenix** — ~2020 → now. Same primary gradient. Label: "2020 →"
4. **LiveView** — ~2020 → now. Accent gradient `#0F3B30` → `#5DCAA5` —
   the ONE highlighted bar (headline offering). Label: "2020 →" in
   `#04342C` on the bar end.
5. **IoT / PubSub** — 1-year segment, solid `#3C3489`.
   PLACEHOLDER POSITION (~2022) — confirm actual year. Label "1 yr"
   outside the segment in `--text-lo`.
6. **Geospatial** — 1-year segment, solid `#3C3489`.
   PLACEHOLDER POSITION (~2024) — confirm actual year. Label "1 yr".

Rules:
- Ongoing bars end flush right with a "→" in the label; closed segments
  show duration instead.
- Never more than 6 bars — more dilutes the specialist claim.
- Purple/accent gradients run dark → light left-to-right.

## Chip Row

Below the graph, pill badges on `bg-neutral`, mono 11px, `#CECBF6`:
- `Principal Architect`
- `LiveView since 0.x` — VERIFY before shipping (true if started pre-1.0)
- `open source: x402 for Elixir` — accent text `#5DCAA5`; add only once
  the library ships

## Implementation Notes

- Build as a function component (e.g. `<.experience_timeline />`) with
  bars driven by a list of `%{label, start_year, end_year | :now, style}`
  so real dates are a data edit, not a markup edit.
- Bars are plain divs with % offsets — no charting lib needed.
- On narrow viewports, let the label column collapse above each track.
- This section is a credibility device, like the adjacent code proof
  block — if both feel redundant, this section wins.

## Open Items

- [ ] Real years for IoT/PubSub and geospatial segments
- [ ] Verify "LiveView since 0.x"
