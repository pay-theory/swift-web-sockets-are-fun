//
//  WebSocketProtocol.swift
//  Pay Theory
//
//  Created by Aron Price on 4/1/21.
//

import Foundation
/**
 * Protocol for reacting to websocket events
 */
protocol WebSocketProtocol {

    /**
     process incoming messages
     */
    func receiveMessage(message:String)
    
    /**
     react to connection success
     */
    func handleConnect()
    
    /**
     react to an error
     */
    func handleError(error:Error)
    
    /**
     react to disconnect
     */
    func handleDisconnect()

}
