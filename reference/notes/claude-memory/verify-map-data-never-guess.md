---
name: verify-map-data-never-guess
description: "Martin wants real fetched data for maps/routes, never estimated coordinates or placeholder straight lines"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 54a269c5-48fe-4046-b63a-8f3d0d51d52d
  modified: 2026-09-07T08:32:07.640Z
---

On map and route work, never invent coordinates or draw straight-line segments between guessed
waypoints as a stand-in for a real path. Fetch actual geometry from an authoritative source and
verify it before presenting.

**Why:** Martin checks the output against the rendered topo map and immediately spots lines that
cut across terrain instead of following trails. Guessed waypoints also badly understate distance —
a hand-picked 8-waypoint chain measured 11.6 km where the real trail was 24.3 km. He called
straight-line placeholders "completely not allowed."

**How to apply:** Reach for a real data source first (see [[hiking-route-data-sources]]). If an
API returns something implausible, debug the source or switch tools — do not paper over it with
approximated waypoints. Verify numerically (distance vs straight-line ratio, endpoint elevations)
AND visually (zoom in on the rendered map to confirm the line overlays the mapped path) before
saying it's done. When he says guidance "has been very clear," it means stop iterating on guesses
and go build a workflow that fetches ground truth.

**Coordinate precision is a provenance signal.** Hand-entered coordinates show up as 3 decimal
places (about +-55 m); fetched ones carry 6. Auditing that split across an existing dataset found
28 of 58 shelters hand-placed, three of them pointing at empty hillside, including two duplicates
of huts already in the list under different names. Check the decimal-place distribution before
trusting any coordinate table, including one I built earlier in the same project.

**For anything safety-bearing, absent beats approximate.** Martin's standard: shelters are drawn
on the map and drive "how far to the next place I can sleep", so a wrong pin could send someone to
open ground at dusk. Where a feature could not be found in OSM at all, remove it rather than show
it at a guessed position, and record the source feature id (`OSM node/892738761`) in the data so
the claim is auditable later.

