# IslandPlatform

IslandPlatform is a modular, non-jailbreak Swift prototype for an in-app Dynamic-Island-style interface, provider-based assistant, validated wallpaper library, package metadata, diagnostics, and future capability-gated integrations.

This repository does not jailbreak devices, bypass signing, inject into SpringBoard, or claim support that Apple does not expose. On an iPhone 13 Pro Max with A15 and iOS 27, system-wide Island replacement, private Control Centre changes, true Always-On Display, and tweak injection remain unavailable without a verified compatible privilege mechanism. The native SwiftUI companion app in IslandApp.xcodeproj provides the supported in-app experience.

## Quick start

```sh
./scripts/build
./scripts/test
./scripts/diagnose
./scripts/package
```

See [docs/FEASIBILITY.md](docs/FEASIBILITY.md), [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), and [docs/BUILD.md](docs/BUILD.md).

Open IslandApp.xcodeproj in Xcode, select a signing team and an iPhone target, then Run to install the supported companion app on a device.
