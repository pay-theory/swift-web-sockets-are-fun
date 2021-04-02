//
//  BackgroundApp.swift
//  WebSocketsAreFun
//
//  Created by Aron Price on 4/2/21.
//

import Foundation
/**
 * Protocol for reacting to app suspension and awakening
 */
@objc protocol BackgroundAppProtocol {

    @objc func appMovedToBackground()
    
    @objc func appCameToForeground()
}
