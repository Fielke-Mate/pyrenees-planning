# Pyrenees planning

A planner for multi-day walks on the GR10, GR11 and HRP: where to start and
finish, how to get there by train from Paris, where you can sleep each night,
daily distance and climb, and maps saved for use with no signal.

Live at <https://fielke-mate.github.io/pyrenees-planning/>.

| Page | |
|---|---|
| `/` (`index.html`) | The planner |
| `/hrp-2026.html` | Archived map from the Pont d'Espagne to Luchon trip, 12-17 Sep 2026 - see [ARCHIVE-HRP-2026.md](ARCHIVE-HRP-2026.md) |

Everything is static: no server, and no build step for the planner.

## On the phone

1. Open the site in Chrome (Android) or Safari (iOS)
2. **Add to Home Screen** - Share → Add to Home Screen on iOS, ⋮ → Add to
   Home screen on Android
3. Plan your section, then tap **⇩ Offline maps** → **Save map for this
   section** while still on wifi. The size is shown before anything downloads.

**Add to Home Screen is not optional on iOS.** Safari clears the cache of
sites that are only bookmarked after about 7 days unused. Installed ones are
exempt.

## What works with no signal

Saved on the first visit with signal:

- the planner itself, and all route, hut and access data for the three routes
- **your GPS position** - the receiver needs no data connection
- map tiles for every section you saved, up to a hard cap

When there is signal, the data is re-checked on every load, so a hut that has
since closed reaches a phone that saved the old data. Refuge and hotel wifi
login pages cannot overwrite saved files.

## Files

| File | |
|---|---|
| `index.html` | The planner. Hand-edited, no build step. |
| `planner.html` | Forwards old links and home-screen icons to the front page, keeping any plan in the link |
| `hrp-2026.html` | The archived trip map, generated from `src/hrp_wallon_luchon.html` |
| `data/` | Route lines (`routes/gr10.json`, `gr11.json`, `hrp.json`), places to sleep (`shelters.json`) and access points (`access.json`) |
| `sw.js` | Service worker: saves the pages and data, and map tiles per section |
| `planner.webmanifest`, `manifest.webmanifest` | Make the planner and the archived map installable |
| `leaflet.js`, `leaflet.css`, `icon-*.png` | Map library (vendored, so no CDN) and home-screen icons |
| `src/` | Build and test tools, and the data pipeline (`src/data/`) |
| `reference/` | Source material: timetables, notes, maps. Not used by the site. |
| `ROADMAP.md`, `DATA-MODEL.md` | What is done, what is next, and how the data is shaped |

## Making changes

Work on a branch, open a pull request, and merge it into `main`. GitHub Pages
publishes `main` within a couple of minutes; `./verify-deploy.sh` waits until
the served front page matches your local `index.html`.

The service worker fetches pages and data network-first, so a phone with
signal picks up a new version on next open. Bump `VERSION` in `sw.js` when
you change `sw.js` itself or the list of files it saves. Map tiles live in a
separate, unversioned cache, so a redeploy never throws away a download.

After cloning, run this once so the pre-commit check is active:

```
git config core.hooksPath .githooks
```

Before committing:

```
python src/build.py --check    # planner lint; archived map matches its source
node src/test_planner.js       # day planning against the real route and hut data
```

`python src/build.py` (without `--check`) rebuilds `hrp-2026.html`. The data
pipeline that produces `data/` is described in [src/data/README.md](src/data/README.md);
its downloads are cached in git-ignored folders under `src/data/`.

### What the build refuses to do

Each guard exists because the mistake behind it actually happened here.

| Guard | The mistake it prevents |
|---|---|
| a second copy of the source | An edit went into a top-level copy while the build read `src/`, producing a page silently missing the change |
| `--check` (pre-commit hook) | Committing an `hrp-2026.html` that does not match its source |
| temporal-dead-zone lint (planner and archive) | A module-level `const` read by a function that startup calls earlier in the file. It throws at load and aborts the rest of the script, but hoisted functions stay callable so the page looks alive. `node --check` cannot see it - it is a runtime error. This happened twice. |
| inline handler lint (planner) | An `on*=` handler in popup HTML naming a function that no longer exists. The button renders and the click throws into the void. |
| popup consistency (archive) | A popup's heading or elevation drifting from its `shelterIndex` entry. Renaming a hut moved the popup's key but left the old name in its `<h4>`, so the map kept announcing "Cabane de Mommour"; correcting entry elevations left two popups quoting superseded figures. Elevation tolerance 30 m. |
| `__hrpReady` sentinel (archive) | Tests asserting "the page works" when the script actually threw partway through |

The TDZ lint follows the call graph, since both real cases were indirect
(`updateDayCards` -> `calcDayStats` -> the const). Put the value inside the
function or make it a hoisted function; `tdz-ok` in a comment on the
declaration overrides it.

## Data and licences

- **Routes and huts:** OpenStreetMap, ODbL 1.0, © OpenStreetMap contributors.
  Each file records its source, relation or feature ids and fetch date.
- **Access points:** built from the official SNCF, liO and
  Pyrénées-Atlantiques timetables.
- **Map tiles:** OpenTopoMap, CC-BY-SA. They permit downloading "as long as
  our server is not overly strained by mass downloads". Saving is capped at 4
  concurrent requests and skips anything already saved - please don't loop it.

**This is a planning aid, not a navigation system.** Carry a proper offline topo
app and a paper map, and do not rely on any hut being open, stocked or standing.
