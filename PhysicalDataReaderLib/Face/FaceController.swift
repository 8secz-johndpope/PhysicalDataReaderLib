//
//  FaceController.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 26/02/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//
import ARKit
import Foundation

public protocol FaceDelegate: class {
    func detectExpression(expression: String) 
    func didDetectFace(detected: Bool)
}

public class FaceController: NSObject {
    
    private weak var faceDelegate: FaceDelegate?
    private var evaluator:FaceEvaluation!
    private var reader = FaceReader ()
    private var session: ARSession!
    
    public func setup(delegate: FaceDelegate) {
        self.session = ARSession()
        self.session.delegate = self
        self.faceDelegate = delegate
    }
    
     public func startSession() {
        self.evaluator = FaceEvaluation()
        guard ARFaceTrackingConfiguration.isSupported else { print("Get True Depth noob" ); return }
        let configuration = ARFaceTrackingConfiguration()
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
     public func stopSession() -> FaceEvaluationData {
        self.session.pause()
        return self.evaluator.evaluateSession()
    }
}
    // MARK: ARSession Delegate
    extension FaceController: ARSessionDelegate {
        
       public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            let result = self.reader.intelligentFaceDecoding(anchors: anchors)
            
            self.evaluator.addExpression(expression: result)
            self.faceDelegate?.detectExpression(expression: result.rawValue)
        }
        
       public func session(_ session: ARSession, didUpdate frame: ARFrame) {
             let isFaceTracked = self.reader.isFaceTracked()
        
            self.faceDelegate?.didDetectFace(detected: isFaceTracked)
        }
    

    }
