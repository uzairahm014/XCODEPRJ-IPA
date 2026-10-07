import Foundation
import IslandPlatform

@main
struct PlatformDemo {
    static func main() async {
        let environment = JailbreakEnvironment(architecture: "arm64", osVersion: "macOS (ProcessInfo.processInfo.operatingSystemVersionString)")
        let diagnostics = DiagnosticsEngine().run(environment: environment, requiredDependencies: [], installedDependencies: [])
        let island = IslandStore()
        await island.update(IslandState(mode: .expanded, context: .aiThinking, title: "Assistant", detail: "Ready"))
        let assistant = Assistant()
        let response = try? await assistant.ask("Show the platform status")
        print("IslandPlatform demo")
        print("\(environment.message)")
        print("Diagnostics passed: \(diagnostics.passed)")
        print("Assistant: \(response ?? "unavailable")")
        print("Capabilities: \(FeatureCatalog.capabilities.count)")
    }
}
