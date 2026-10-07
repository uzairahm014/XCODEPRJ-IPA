# IslandPlatform development notes

IslandPlatform is an honest, capability-gated Swift prototype for iOS customization. Ordinary-app functionality must never be presented as SpringBoard or kernel modification. Any privileged integration belongs behind a separate adapter and must report unavailable when the environment does not provide it.

## Commands

- `./scripts/build` — build the package and demo
- `./scripts/test` — run unit tests
- `./scripts/diagnose` — write `diagnostics/report.md`
- `./scripts/package` — create a source archive in `outputs/`

Use Swift 6/Xcode 27 where available. Do not add secrets or copied copyrighted assets.
