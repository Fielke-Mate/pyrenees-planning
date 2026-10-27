---
name: hiking-route-data-sources
description: Use BRouter (not OSRM) for hiking/trail routing; Overpass API for OSM feature coordinates
metadata: 
  node_type: memory
  type: reference
  originSessionId: 54a269c5-48fe-4046-b63a-8f3d0d51d52d
  modified: 2026-09-07T08:31:56.950Z
---

For hiking/trail routing, use **BRouter** — free, no API key:
`https://brouter.de/brouter?lonlats=<lon1>,<lat1>|<lon2>,<lat2>&profile=hiking-beta&alternativeidx=0&format=geojson`
Returns GeoJSON `features[0].geometry.coordinates` as `[lon, lat, elevation]` — includes real
elevation. `properties` has `track-length` (m), `filtered ascend`, `plain-ascend`. Multi-waypoint
routes work by joining waypoints with `|`.

**Do NOT use OSRM's public demo server** (`router.project-osrm.org`) for foot/hiking routes. Its
"foot" profile is car-network-derived and produces nonsense in mountain terrain — huge spurious
loops, or straight-line fallbacks. Verified failure case: a 1.85 km mountain hop that BRouter
routed correctly at 2.3 km (1.24x ratio).

For authoritative coordinates of OSM features (stations, refuges, peaks), use **Overpass API**:
POST to `https://overpass-api.de/api/interpreter` with body `data=<urlencoded query>`,
`Content-Type: application/x-www-form-urlencoded`, and a **User-Agent header** (omitting it
returns HTTP 406).

Sanity-check any routed result against straight-line distance: real trails rarely exceed ~4x.

Related: [[verify-map-data-never-guess]]
