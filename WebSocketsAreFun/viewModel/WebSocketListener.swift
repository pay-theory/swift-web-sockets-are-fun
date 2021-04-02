//
//  Websocket.swift
//  Pay Theory
//
//  Created by Aron Price on 4/1/21.
//

import Foundation
/**
 * Responsible for managing WebSocket network events
 */
public class WebSocketListener: NSObject, URLSessionWebSocketDelegate {
    
    private var session: WebSocketSession?
    
    /**
     * Attach a session
     */
    func prepare(_session: WebSocketSession) {
        self.session = _session
    }
    
    /**
     * Platform Protocol for reacting to websocket connections
     */
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("connected")
        self.session!.setOpened(_opened: true)
    }
    
    /**
     * Platform Protocol for reacting to websocket disconnect
     */
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("disconnected")
        self.session!.setOpened(_opened: false)
    }

    /**
     * Platform Protocol for reacting to websocket errors
     */
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError: Error?) {
        if (didBecomeInvalidWithError != nil) {
            self.session!.handler!.handleError(error:didBecomeInvalidWithError!)
        }
        print("errored")
        if (self.session!.isOpened()) {
            self.session!.close()
        }
    }
}
