//
//  OverallEvaluation.swift
//  PhysicalDataReaderLib
//
//  Created by Oliver Larsen on 22/03/2019.
//  Copyright © 2019 Amsiq. All rights reserved.
//

import Foundation

public enum OverallResult {
    case very_good
    case good
    case average
    case bad
    case very_bad
}


public class OverallEvaluation   {
    var totalScore = 0
    
    public func overallEvaluation(facedata: FaceEvaluationData, heartdata: HeartEvaluationData ) {
         let smilePercentage = facedata.getNumberOfExpression(expression: .smiling, percentage: true)
        let heart = heartdata.increaseHR
        
    }
    
    
    public func cooleval() -> OverallResult  {
        
        
        switch self.totalScore {
        case 0...10:
            return .very_bad
        case 11...33:
            return .bad
        case 34...50:
            return .average
        case 50...75:
            return .good
        case 75...100:
            return .very_good
        default:
            return .average
        }
        
        
    }
    
    
}
