# Build

Requirements: macOS 14+, Xcode 27/Swift 6, and no external dependency for the current prototype.

Run `./scripts/build` for the library and demo, `./scripts/test` for XCTest, and `./scripts/build-ios` for the native SwiftUI iPhone simulator app. Use `swift run platform-demo` to exercise the local demo. Open `IslandApp.xcodeproj` in Xcode, choose your signing team and connected iPhone, then press Run to install it on the device. The app shows supported in-app features immediately; system-wide features remain capability-gated.
