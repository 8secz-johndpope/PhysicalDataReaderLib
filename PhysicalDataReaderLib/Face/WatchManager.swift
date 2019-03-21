//
//  WatchManager.swift
//  Watch Extension
//
//  Created by Oliver Larsen on 18/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

protocol WatchManagerDelegate: class {
    func getLatestHeartRate(newHeartRate: Double)
}
class WatchManager: NSObject {
    
    private weak var delegate: WatchManagerDelegate?
    private var session = WCSession.default
    private let sessionManager = SessionManager()
    
    public func setupSession(delegate: WatchManagerDelegate) {
        self.delegate = delegate
        self.sessionManager.delegate = self
        self.session.delegate = self
        self.session.activate()
    
    }
    
    private func sendToApp(count: Double) {
        
        if self.session.isReachable {
            self.session.sendMessage(["HeartRate": count], replyHandler: nil, errorHandler: { error in print("Error sending message", error) })
        } else {
            print("Phone is not reachable")
        }
    }
    
}
extension WatchManager: SessionManagerDelegate {
    
    func sessionManager(_ manager: SessionManager, didChangeHeartRateTo newHeartRate: Double) {
        self.sendToApp(count: newHeartRate)
        self.delegate?.getLatestHeartRate(newHeartRate: newHeartRate)
    }
}

extension WatchManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let message = message["Start"] as? String {
            self.sessionManager.start()
            print("hello  \(message)")
        } else if let message = message["End"] as? String {
            self.sessionManager.stop()
            print(message)
        }
    }
    
}
