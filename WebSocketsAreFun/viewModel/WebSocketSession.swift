//
//  WebsocketSession.swift
//  Pay Theory
//
//  Created by Aron Price on 4/1/21.
//

import Foundation
/**
 * Responsible for managing websocket session
 * including closing and restarting as appropriate
 */
public class WebSocketSession {
    public let REQUIRE_RESPONSE = true
    private var provider: WebSocketProvider?
    private var listener: WebSocketListener?
    private var isOpen: Bool = false
    var handler: WebSocketProtocol?
    
    init(){}
    
    /**
     * initialize session and create listener
     */
    func prepare(_provider: WebSocketProvider, _handler: WebSocketProtocol) {
        self.handler = _handler
        self.provider = _provider
        self.listener = WebSocketListener()
        self.listener!.prepare(_session: self)
    }
    
    /**
     * handle changes to socket connection status
     */
    func setOpened(_opened:Bool) {
        self.isOpen = _opened
        if (isOpen) {
            self.handler!.handleConnect()
        } else {
            self.handler!.handleDisconnect()
            self.decompose()
        }
    }
    
    /**
     * share socket connection status
     */
    func isOpened() -> Bool {
        return self.isOpen
    }

    /**
     * Open WebSocket if not already open
     */
    func open(url:String) {
        if (!self.isOpen) {
            self.provider!.startSocket(url: url, listener: self.listener!, _handler: self.handler!)
        } else {
            print("cannot open socket, already open")
        }
    }

    /**
     * close WebSocket if not already closed
     */
    func close() {
        if (self.isOpen) {
            self.provider!.stopSocket()
        } else {
            print("cannot close socket, already closed")
        }
    }

    /**
     * Send an action, message and optional response request to WebSocket
     * requiresResponse set to true will trigger the receiver to listen for websocket response
     */
    func sendMessage(action: String, messageBody: [String: Any], requiresResponse: Bool = false) {
        if (self.isOpen) {
            let message: [String: Any] = [
                "action": action,
                "body": messageBody
            ]
            
            self.provider!.sendMessage(message: .string(dictToString(dict:message)), handler: self.handler!)
            
            if (requiresResponse) {
                self.provider!.receive()
            }
        } else {
            print("cannot send message, socket closed")
        }
    }
    /**
     * Convert dictionary to string to pass into websocket
     */
    private func dictToString(dict:[String: Any]) -> String {
        do {
        let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    /**
     * clean up session memory
     */
    private func decompose() {
        self.listener = nil
        self.provider = nil
        self.handler = nil
    }
}
