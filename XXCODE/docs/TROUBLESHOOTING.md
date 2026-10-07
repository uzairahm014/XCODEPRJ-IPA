# Troubleshooting

If `swift test` fails, run it again after reading the compiler error; do not delete `.build` as a first response. `./scripts/diagnose` records detected host architecture, Swift version, Xcode path, and dependency status. iOS-only features that compile but cannot run on macOS must be verified on a simulator/device before being described as working.
