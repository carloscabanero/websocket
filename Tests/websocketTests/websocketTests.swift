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

        wait(for: [expectation], timeout: 5000.0)

      let task = URLSession.shared.webSocketTask(with: URL(string: "wss://localhost:8000")!)
      task.resume()

        task.send(.string(message)) { error in if let error = error { XCTFail("\(error)") } }
      task.receive { result in
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
          expectation.fulfill()
      }

      wait(for: [expectation], timeout: 5.0)
    }
}
