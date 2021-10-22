import XCTest
import Network


@testable import websocket

final class websocketTests: XCTestCase {
    func testWebSocket() throws {
      let message = "Hello World"
      let expectation = XCTestExpectation(description: "Message received")

      // Start webserver. Wait for it to be ready. We will create a proper ready flag.
      let server = try BKWebSocketServer()
      RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1))
        
      let task = URLSession.shared.webSocketTask(with: URL(string: "ws://localhost:8000")!)
      task.resume()

        task.send(.string(message)) { error in if let error = error { XCTFail("\(error)") } }
      task.receive { result in
          expectation.fulfill()

          switch result {
          case .success(let result):
              var msg: String? = nil
              switch result {
              case .data(let data):
                msg = String(data: data, encoding: .utf8)
              case .string(let str):
                msg = str
              @unknown default:
                  XCTFail("Unknown")
              }
              XCTAssert(msg == message)
          case .failure(let error):
              XCTFail("\(error)")
          }
      }

      wait(for: [expectation], timeout: 2.0)
    }
}
