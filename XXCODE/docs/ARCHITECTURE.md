# Architecture

The package is intentionally small and independently testable. `IslandPlatform` currently contains the foundational contracts; feature folders are reserved for adapters as the prototype grows.

```text
Core contracts
├── Island state store
├── AIProvider / Assistant / AssistantIntent
├── Wallpaper validation
├── JailbreakEnvironment capability detection
├── PackageManifest / PackageChecker
└── DiagnosticsEngine

Adapters to add
├── DynamicIsland (SwiftUI + Live Activities)
├── Voice (Speech + AVFoundation)
├── Music (MediaPlayer)
├── Automation (App Intents + Shortcuts)
├── Settings (SwiftUI)
└── Device/Jailbreak adapters (explicitly capability-gated)
```

No adapter may claim success without a successful underlying API call. Privileged adapters are optional and must degrade to `CapabilityStatus.requiresJailbreak`, `.requiresPrivateAPI`, or `.requiresDevice`.
