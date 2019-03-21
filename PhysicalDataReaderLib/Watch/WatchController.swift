//
//  WatchController.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 12/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

protocol WatchReaderDelegate: class {
    func didGetHeartRate(hr: Int)
}

public class WatchController: NSObject {

    private var session: WCSession!
    private var evaluator: HeartRateEvaluation!
    private weak var watchDelegate: WatchReaderDelegate?
   
    public func setup(delegate: WatchReaderDelegate) {
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            self.watchDelegate = delegate
        }
    }
    
    public func startListeningForHR() {
        self.evaluator = HeartRateEvaluation()
        self.session.sendMessage(["Start":"get hr"], replyHandler: nil, errorHandler: nil)
    }
    
   public func stopHR() -> HeartEvaluationData {
        self.session.sendMessage(["End":"stop hr"], replyHandler: nil, errorHandler: nil)
        return self.evaluator.evaluateSession()
    }
}

extension WatchController: WCSessionDelegate {
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let received = message["HeartRate"] as? Int {
            self.evaluator.heartRates.append(received)
            self.watchDelegate?.didGetHeartRate(hr: received)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
