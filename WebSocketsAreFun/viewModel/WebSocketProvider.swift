//
//  WebSocketProvider.swift
//  Pay Theory
//
//  Created by Aron Price on 4/1/21.
//

import Foundation

/**
 * Responsible for all calls made to websocket server
 */
public class WebSocketProvider {
    var webSocket: URLSessionWebSocketTask?
    var handler: WebSocketProtocol?
    
    /**
     * creates a WebSocket and begins the connection
     */
    func startSocket(url: String, listener: WebSocketListener, _handler: WebSocketProtocol) {
        let urlSession = URLSession(configuration: .default, delegate: listener, delegateQueue: OperationQueue())        
        handler = _handler
        webSocket = urlSession.webSocketTask(with: URL(string:url)!)
        self.webSocket!.resume()
    }
    
    /**
     * receives a WebSocket message and routes based on type
     */
    func receive() {
        webSocket!.receive { result in
        switch result {
        case .success(let message):
          switch message {
          case .string(let text):
            self.handler!.receiveMessage(message: text)
          default:
            print("recieved unknown response type")
          }
        case .failure(let error):
            self.handler!.handleError(error: error)
            self.stopSocket()
        }
      }
    }
    
    /**
     * sends a WebSocket message
     */
    func sendMessage(message:URLSessionWebSocketTask.Message, handler: WebSocketProtocol) {
        webSocket?.send(message, completionHandler: { (error) in
            if (error != nil) {
                self.handler!.handleError(error: error!)
                self.stopSocket()
            }
        })
    }

    /**
     * ends a WebSocket connection
     */
    func stopSocket() {
        webSocket?.cancel(with: .normalClosure, reason: webSocket?.closeReason)
    }
}
    
    
