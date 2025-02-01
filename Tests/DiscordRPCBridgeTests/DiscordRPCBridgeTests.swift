import Testing
@testable import DiscordRPCBridge
import WebKit

@Test @MainActor func testBridgeFunctional() async throws {
    let bridge = DiscordRPCBridge()

    let mockWebView = WKWebView(frame: .zero)
    await bridge.startBridge(for: mockWebView)

    // Check if the server has started
    #expect(bridge.isServerReady)

    // Stop the bridge.
    bridge.stopBridge()
}
