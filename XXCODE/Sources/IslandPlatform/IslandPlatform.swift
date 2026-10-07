import Foundation

public enum CapabilityStatus: String, Codable, Sendable { case available, unavailable, requiresJailbreak, requiresPrivateAPI, requiresDevice }

public struct Capability: Codable, Sendable, Equatable {
    public let id: String
    public let status: CapabilityStatus
    public let explanation: String
    public init(id: String, status: CapabilityStatus, explanation: String) { self.id = id; self.status = status; self.explanation = explanation }
}

public protocol PlatformModule: Sendable {
    static var identifier: String { get }
    static var capabilities: [Capability] { get }
}

public struct IslandState: Codable, Sendable, Equatable {
    public enum Mode: String, Codable, Sendable { case compact, expanded, interactive }
    public enum Context: String, Codable, Sendable { case idle, notification, music, timer, download, call, navigation, aiListening, aiThinking, aiSpeaking }
    public var mode: Mode
    public var context: Context
    public var title: String?
    public var detail: String?
    public init(mode: Mode = .compact, context: Context = .idle, title: String? = nil, detail: String? = nil) { self.mode = mode; self.context = context; self.title = title; self.detail = detail }
}

public actor IslandStore {
    public private(set) var state = IslandState()
    public init() {}
    public func update(_ state: IslandState) { self.state = state }
}

public protocol AIProvider: Sendable {
    var name: String { get }
    func respond(to prompt: String, history: [String]) async throws -> String
}

public struct LocalEchoProvider: AIProvider {
    public let name = "Local demo provider"
    public init() {}
    public func respond(to prompt: String, history: [String]) async throws -> String { "Demo response: \(prompt)" }
}

public enum AssistantIntent: String, Codable, Sendable { case openApp, runShortcut, setWallpaper, startMusic, pauseMusic, searchWeb, summarize, createReminder, startTimer, controlSetting, showIsland, hideIsland }

public struct AssistantActionResult: Sendable, Equatable { public let intent: AssistantIntent; public let succeeded: Bool; public let message: String }

public actor Assistant {
    public var provider: any AIProvider
    public private(set) var history: [String] = []
    public init(provider: any AIProvider = LocalEchoProvider()) { self.provider = provider }
    public func ask(_ prompt: String) async throws -> String { history.append(prompt); let response = try await provider.respond(to: prompt, history: history); history.append(response); return response }
}

public struct WallpaperAsset: Codable, Sendable, Equatable { public let name: String; public let fileExtension: String; public let byteCount: Int64; public init(name: String, fileExtension: String, byteCount: Int64) { self.name = name; self.fileExtension = fileExtension; self.byteCount = byteCount } }

public struct WallpaperValidator: Sendable {
    public let allowedExtensions: Set<String> = ["jpg", "jpeg", "png", "heic", "gif", "mp4", "mov"]
    public let maxBytes: Int64 = 500_000_000
    public init() {}
    public func validate(_ asset: WallpaperAsset) -> Result<Void, Error> {
        guard allowedExtensions.contains(asset.fileExtension.lowercased()) else { return .failure(ValidationError.unsupportedFormat) }
        guard asset.byteCount >= 0 && asset.byteCount <= maxBytes else { return .failure(ValidationError.invalidSize) }
        return .success(())
    }
    public enum ValidationError: Error, Equatable { case unsupportedFormat, invalidSize }
}

public struct JailbreakEnvironment: Codable, Sendable, Equatable {
    public let jailbreakPresent: Bool
    public let architecture: String
    public let osVersion: String
    public let injectionAvailable: Bool
    public let packageManager: String?
    public init(jailbreakPresent: Bool = false, architecture: String = "unknown", osVersion: String = "unknown", injectionAvailable: Bool = false, packageManager: String? = nil) { self.jailbreakPresent = jailbreakPresent; self.architecture = architecture; self.osVersion = osVersion; self.injectionAvailable = injectionAvailable; self.packageManager = packageManager }
    public var message: String { jailbreakPresent ? "System-level integration capability detected; verify each privilege before use." : "System-level integration unavailable on this device/firmware." }
}

public struct PackageManifest: Codable, Sendable, Equatable { public let identifier: String; public let version: String; public let dependencies: [String]; public let minimumOS: String; public let architecture: String; public let permissions: [String]; public init(identifier: String, version: String, dependencies: [String] = [], minimumOS: String = "17.0", architecture: String = "arm64", permissions: [String] = []) { self.identifier = identifier; self.version = version; self.dependencies = dependencies; self.minimumOS = minimumOS; self.architecture = architecture; self.permissions = permissions } }

public struct PackageChecker: Sendable {
    public init() {}
    public func missingDependencies(for manifest: PackageManifest, installed: Set<String>) -> [String] { manifest.dependencies.filter { !installed.contains($0) } }
}

public struct DiagnosticReport: Sendable, Equatable { public let checks: [String: Bool]; public let notes: [String]; public var passed: Bool { checks.values.allSatisfy { $0 } } }

public struct DiagnosticsEngine: Sendable {
    public init() {}
    public func run(environment: JailbreakEnvironment, requiredDependencies: Set<String>, installedDependencies: Set<String>) -> DiagnosticReport {
        let missing = requiredDependencies.subtracting(installedDependencies)
        return DiagnosticReport(checks: ["architecture-known": environment.architecture != "unknown", "dependencies-present": missing.isEmpty], notes: [environment.message] + (missing.isEmpty ? [] : ["Missing dependencies: \(missing.sorted().joined(separator: ", "))"]))
    }
}

public enum FeatureCatalog {
    public static let capabilities: [Capability] = [
        Capability(id: "island-ui", status: .available, explanation: "In-app Dynamic-Island-style presentation."),
        Capability(id: "ai-provider", status: .available, explanation: "Provider abstraction with local demo provider."),
        Capability(id: "wallpaper-library", status: .available, explanation: "Validated assets and playlists inside the app."),
        Capability(id: "system-springboard-injection", status: .requiresJailbreak, explanation: "Not available to ordinary App Store applications."),
        Capability(id: "private-control-centre", status: .requiresPrivateAPI, explanation: "Apple does not provide a supported public API."),
        Capability(id: "true-always-on-display", status: .requiresDevice, explanation: "Cannot be provided by this app on unsupported hardware."),
        Capability(id: "sideloading-installer", status: .requiresDevice, explanation: "Requires an authorized signing/install workflow; no bypass is implemented.")
    ]
}
