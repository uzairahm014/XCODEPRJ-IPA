import XCTest
@testable import IslandPlatform

final class IslandPlatformTests: XCTestCase {
    func testIslandStateRoundTrip() async { let store = IslandStore(); let expected = IslandState(mode: .expanded, context: .music, title: "Track"); await store.update(expected); let actual = await store.state; XCTAssertEqual(actual, expected) }
    func testAssistantUsesProviderAndStoresHistory() async throws { let assistant = Assistant(); let response = try await assistant.ask("hello"); let historyCount = await assistant.history.count; XCTAssertEqual(response, "Demo response: hello"); XCTAssertEqual(historyCount, 2) }
    func testWallpaperValidation() { let validator = WallpaperValidator(); if case .failure = validator.validate(WallpaperAsset(name: "a", fileExtension: "png", byteCount: 100)) { XCTFail("valid PNG rejected") }; guard case .failure(let error) = validator.validate(WallpaperAsset(name: "a", fileExtension: "exe", byteCount: 100)) else { return XCTFail("unsupported format accepted") }; XCTAssertEqual(error as? WallpaperValidator.ValidationError, .unsupportedFormat) }
    func testPackageDependencies() { let checker = PackageChecker(); let manifest = PackageManifest(identifier: "demo", version: "1", dependencies: ["core", "voice"]); XCTAssertEqual(checker.missingDependencies(for: manifest, installed: ["core"]), ["voice"]) }
    func testDiagnosticsDetectMissingDependencies() { let report = DiagnosticsEngine().run(environment: JailbreakEnvironment(architecture: "arm64"), requiredDependencies: ["core"], installedDependencies: []); XCTAssertFalse(report.passed); XCTAssertTrue(report.notes.joined().contains("core")) }
}
