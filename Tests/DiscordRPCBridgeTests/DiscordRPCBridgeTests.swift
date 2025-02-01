import Testing
@testable import DiscordRPCBridge
import WebKit

@Test @MainActor func testBridgeFunctional() async throws {
    let bridge = DiscordRPCBridge()

    let mockWebView = WKWebView(frame: .zero)
    bridge.startBridge(for: mockWebView)

    // Wait for server to start
    try await Task.sleep(for: .seconds(1))

    #expect(bridge.isServerReady)

    bridge.stopBridge()
}
