import XCTest
@testable import websocket

final class websocketTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(websocket().text, "Hello, World!")
    }
}
