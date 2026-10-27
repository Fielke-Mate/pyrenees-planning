# Reference material

Source material for working on the map: guidebook pages, maps, PDFs, notes,
screenshots, raw data. Nothing in here is used by the site or the build.

Files uploaded in a Claude session only live in that session's temporary
machine. Anything worth keeping goes in this folder and gets committed.

**This repo is public and served by GitHub Pages.** Once merged to `main`,
anything here can be opened at
`https://fielke-mate.github.io/pyrenees-planning/reference/<file>`. Keep private or
copyrighted material out, or link to it from `links.md` instead.

Keep single files under ~50 MB; GitHub refuses anything over 100 MB.

## Layout

- `maps/` — map images, GPX/KML, route sketches
- `docs/` — PDFs, guidebook extracts, articles (e.g. the bus 965
  Lourdes–Cauterets timetable)
- `notes/` — your own notes and trip plans
  - `claude-memory/` — what earlier Claude sessions learned about this project
    (data sources, rules, trip dates). Read `MEMORY.md` first.
  - `launch.json` — Claude desktop app preview config; it expects to sit in
    `.claude/` one level above the site folder
- `links.md` — material that lives elsewhere (shared drives, websites)
