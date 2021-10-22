import Network
import Foundation

public class BKWebSocketServer {
    var listener: NWListener!
    let queue = DispatchQueue(label: "WebSocketServer")
    
    public init() throws {
        try startListening()
    }
    
    // TODO Port
    func startListening() throws {
        let parameters = NWParameters.tcp
        let websocketOptions = NWProtocolWebSocket.Options()
        parameters.defaultProtocolStack.applicationProtocols.insert(websocketOptions, at: 0)
        
        self.listener = try NWListener(using: parameters, on: 8000)
        
        listener.newConnectionHandler = { [weak self] in self?.handleNewConnection($0) }
        // TODO Review the state
        listener.stateUpdateHandler = { print("WebSocket Listener \($0)") }
        listener.start(queue: queue)
    }
    
    func handleNewConnection(_ conn: NWConnection) {
        // TODO Skipping on the statehandler for the connection for now
        //connections.append(conn)
        conn.start(queue: queue)
        receiveNextMessage(conn)
    }
    
    func receiveNextMessage(_ conn: NWConnection) {
        conn.receiveMessage { (content, context, isComplete, error) in
            if let data = content, let context = context {
                let reply = self.handleMessage(data: data, context: context)
                let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
                let context = NWConnection.ContentContext(identifier: "binaryContext",
                                                          metadata: [metadata])
                
                conn.send(content: reply, contentContext: context, completion: .idempotent)
                self.receiveNextMessage(conn)
            }
        }
    }
    
    func handleMessage(data: Data, context: NWConnection.ContentContext) -> Data {
        // TODO We may need an additional Framer for our protocol, specially if we are
        // sending data in chunks (maybe for big files?).
        return data
    }
}
