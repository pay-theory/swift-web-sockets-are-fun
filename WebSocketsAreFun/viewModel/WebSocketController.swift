//
//  WebSocketController.swift
//  WebSocketsAreFun
//
//  Created by Aron Price on 4/2/21.
//

import Foundation
import SwiftUI

/**
 * WebSocketController
 * implements BackgroundAppProtocol and WebSocketProtocol
 * provides WebSocket session management
 */
class WebSocketController: BackgroundAppProtocol, WebSocketProtocol {
    var session: WebSocketSession
    
    init(){
        self.session = WebSocketSession()
        self.initializeBackgroundApp()
    }
    
    /**
     * WebSocketProtocol implementation
     * react to incoming WebSocket message
     */
    func receiveMessage(message: String) {
        print("message received")
        print(message)
        let messageBody = ["thank you":"sir","may i":"have another"]
        self.session.sendMessage(action: "speak",messageBody: messageBody,requiresResponse: self.session.REQUIRE_RESPONSE)
    }
    
    /**
     * WebSocketProtocol implementation
     * react to successful WebSocket connection
     */
    func handleConnect() {
        print("socket connected")
        let messageBody = ["say":"something"]
        self.session.sendMessage(action: "speak",messageBody: messageBody,requiresResponse: self.session.REQUIRE_RESPONSE)
    }
    
    /**
     * WebSocketProtocol implementation
     * react to WebSocket error
     */
    func handleError(error: Error) {
        print("socket error")
        print(error.localizedDescription)
    }
    
    /**
     * WebSocketProtocol implementation
     * react to WebSocket disconnect
     */
    func handleDisconnect() {
        print("socket disconnected")
    }
    
    /**
     * BackgroundAppProtocol implementation
     * react to suspension
     */
    func appMovedToBackground() {
        self.session.close()
    }
    
    /**
     * BackgroundAppProtocol implementation
     * react to awakened
     */
    func appCameToForeground() {
        self.open(provider: WebSocketProvider())
    }
    
    /**
     * initializes observers to react when suspended or awakened
     */
    private func initializeBackgroundApp() {
        let notificationCenter = NotificationCenter.default
        
        // observe for app suspension
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // observe for app awake
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /**
     * initializes or reinitializes a session and opens the socket
     */
    private func open(provider: WebSocketProvider) {
        print("opening connection")
        self.session.prepare(_provider: provider, _handler: self)
        self.session.open(url:"wss://echo.websocket.org")
    }
}
