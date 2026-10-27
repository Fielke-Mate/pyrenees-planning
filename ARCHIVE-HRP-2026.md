# Archived: HRP Pont d'Espagne to Luchon, 12-17 Sep 2026

`hrp-2026.html` is the single-trip map this project started as: one fixed
six-day itinerary on the Haute Randonnée Pyrénéenne, with its shelters, day
splits, elevation profile, GPS position and GPX export. The trip is in the
past and the planner on the front page has replaced it. It is kept as it was,
apart from an "Archived trip" header line linking to the planner.

Live at <https://fielke-mate.github.io/pyrenees-planning/hrp-2026.html>.

## Building

`hrp-2026.html` is generated from `src/hrp_wallon_luchon.html` by
`python src/build.py`. The build inlines Leaflet 1.9.4 (vendored in `src/`, so
no CDN and the page works with no signal), adds the PWA tags, sets
`crossOrigin` on the tile layer, and appends the offline block. It is
deterministic: rebuilding without changing the source reproduces
`hrp-2026.html` byte for byte.

**`src/hrp_wallon_luchon.html` is the only source.** Editing `hrp-2026.html`
directly gets overwritten by the next build.

## On the phone

1. Open the page in Chrome (Android) or Safari (iOS)
2. **Add to Home Screen**
3. Open it from that icon, tap **⇩ Offline maps** → **Download corridor**,
   while still on wifi

Standard detail is ~474 tiles / ~22 MB and covers 2 km either side of the
route at zoom 9–14. High detail adds zoom 15: ~1,500 tiles / ~71 MB.

## What works with no signal

Cached by the page itself, so always available:

- the route, all 58 shelters, the day splits and the elevation profile
- leg distances between shelters
- **your GPS position** — the receiver needs no data connection

Only the topographic background needs the tile download. Without it you get
the route on a blank background, which is still perfectly readable.

## Exporting

**Export GPX** in the header writes GPX 1.1 with a single `<trk>` - Komoot,
Gaia and Garmin all import that reliably, whereas multiple `<trk>` elements get
split or partly ignored. It exports the plan as it currently stands, including
any overnight stops you have changed and the live Day 6 re-route.

- **Whole route** - 8,781 points, ~590 KB
- **Selected day** - pick a day card first; ~1,500 points, ~100 KB
- **Overnight stops as waypoints** (on by default), or every shelter currently
  shown on the map
- **Reduce points** - simplifies at 5 m for apps that cap track size. Costs
  about 2.2 km of the 144 km; the exact loss is reported after each download.

Per-day files are the easier import if a tool complains about size.

## Route geometry

Every route array was measured against OpenStreetMap highway geometry - the
distance from each point to the nearest mapped way:

| array | points | median | max | > 25 m |
|---|---|---|---|---|
| TRACK | 7,912 | 0.2 m | 55 m | 1 |
| LUCHON_DESCENT | 1,480 | 0.2 m | 0.7 m | 0 |
| BUS965_ROUTE | 319 | 0.2 m | 0.6 m | 0 |
| BUS_ROUTE | 418 | 0.2 m | 0.6 m | 0 |

TRACK was not always like that. It used to be a decimated 1,408-point line that
cut switchback corners: median 3.3 m off the trail but up to 104 m, with 50
points beyond 25 m. Because the shortcuts skipped real zigzags it **understated
distance by 9.1%** - 121.11 km where the trail is 132.15 km. That is the
dangerous direction for an error, since distance drives the time estimates.

It was re-routed through its own waypoints with BRouter (hiking-beta), which
keeps every curated decision - the Parzan spur and the Marcadau descent stay cut
- while restoring the real trail between them. Verified afterwards that no point
strays more than 250 m from the original line, so nothing new was introduced.
Three short stretches kept their original geometry where BRouter's server-side
watchdog repeatedly timed out.

The headline total moved from 134 km to 144 km as a result. The route on the
ground did not change; the measurement of it got honest.

## Shelter data

All 55 shelters carry coordinates taken from OpenStreetMap, at full precision,
with the source feature id recorded in each entry (`OSM node/892738761`). None
are hand-placed.

They were not always. An audit found 28 of the original 58 entered by hand at
three decimal places (about +-55 m), and three of those sat on open hillside:

- **Gite La Munia (Heas)** - a duplicate of Auberge de la Munia, pinned 464 m away
- **Abri de Caillauas** - a duplicate of Refuge de Caillauas, the same OSM feature
- **Cabane de Sarnes / Crabioules** - no feature of that name within 3 km of the
  pin, and none anywhere nearby. Removed rather than shown in a guessed place.

Two were also misnamed: *Cabane de Mommour* is **Cabane du Cortail de Batoua**,
and *Gite du Maillet* is **Auberge du Maillet**.

Leg distances include the walk off the route to reach each shelter, marked
with a leading `~` because the off-route portion is straight-line and therefore
a minimum. The climb figure covers the on-route part only.
