# Feasibility matrix

Status checked 2026-10-06 against the local Xcode/Swift environment and current public compatibility information. The target is iPhone 13 Pro Max (A15), iOS 27.0.

| Feature | Currently possible? | Requires jailbreak? | Requires exploit? | Requires private API? | Possible without jailbreak? | Test environment | Implementation plan | Limitations |
|---|---|---:|---:|---:|---:|---|---|---|
| Island UI | Yes, in-app | No | No | No | Yes | iOS Simulator/device | SwiftUI/Live Activity adapter | Cannot overlay every app or replace SpringBoard |
| AI assistant | Yes, with providers | No | No | No | Yes | Simulator/device | AIProvider + App Intents/Shortcuts | Permissions, network, and provider availability |
| Voice | Yes through public frameworks | No | No | No | Yes | Device preferred | Speech and AVFoundation adapters | Background/wake-word behavior is restricted |
| Wallpapers | App library and previews | No | No | No | Yes | Simulator/device | Validated asset library | Cannot silently replace system wallpaper without user flow |
| Full theming | Partial | Usually | Sometimes | Often | Partial | Device/research environment | Theme model + supported app surfaces | App icons/widgets are constrained by iOS |
| Notifications | Partial | No for app-owned | No | No | Partial | Device | Notification service extensions and summaries | Apps cannot read arbitrary notification history |
| Control Centre | App-owned controls only | Yes | Possibly | Yes | Partial | Device | Shortcuts/App Intents and settings links | Private system modules are unavailable |
| Lock screen | Widgets/Live Activities | No | No | No | Partial | Device | WidgetKit/ActivityKit adapters | No true arbitrary lock-screen replacement |
| Music | Yes through public media APIs | No | No | No | Yes | Device | MediaPlayer adapter | Provider-specific restrictions |
| Automation | Shortcuts/App Intents | No | No | No | Partial | Device | Intent/action graph | Many triggers/actions require user approval |
| Sideloading | Authorized workflows only | No | No | No | Partial | Device + signing account | Package metadata and diagnostics | No signing bypass or unauthorized installer |
| System tweaks | No on target | Yes | Depends | Often | No | Research/jailbreak-only | Isolated adapter interfaces | No public supported route for this target |
| True Always-On Display | No on target | N/A | N/A | N/A | No | Supported hardware only | Interface stub | Hardware/display behavior cannot be emulated by an app |

Public compatibility research reviewed on 2026-10-06: [palera1n documentation](https://docs.palera.in/installing-palera1n/) describes checkm8-compatible A8–A11 devices, while the project's [published README](https://github.com/palera1n/palera1n) does not establish A15/iOS 27 support. No exploit is bundled or inferred.
