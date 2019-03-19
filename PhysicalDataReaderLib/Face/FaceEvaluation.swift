//
//  FaceEvaluationswift.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 21/02/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation

class FaceEvaluation {
    
    private var counts: [String: Int] = [:]
    private var totalCount = 0
    private var lastExpression: FaceState?
    private var specialCases: [FaceState] = [.winking, .tongue_out]
    
    func addExpression(expression: FaceState) {
        
        if specialCases.contains(expression) && specialCases.contains(self.lastExpression ?? .not_determined) {
            return
        }
//
//        if expression == .winking && self.lastExpression == .winking {
//            return
//        }
        
        self.counts[expression.rawValue, default: 0] += 1
        self.totalCount += 1
        self.lastExpression = expression
    }
    
    func evaluateSession() -> FaceEvaluationData {
        
        let evaluationData = FaceEvaluationData (
        totalExpressions: self.totalCount,
        mostUsed: counts.max { a, b in a.value < b.value }?.key,
        counts: self.counts
        )
        return evaluationData
    }
    
    private func specialExpression() -> Bool {
    
        return false
    }
}

public struct FaceEvaluationData {
    var totalExpressions: Int?
    var mostUsed: String?
    var counts: [String: Int]?
    
    func getNumberOfExpression(expression: FaceState, percentage:Bool) -> Int? {
        if let counts = self.counts, let value = counts[expression.rawValue], let total = self.totalExpressions {
             return percentage ? getPercentage(value, total) : value
        } else { return 0 }
    }
    
    private func getPercentage(_ value: Int, _ max: Int) -> Int {
        return Int((Double(value) / Double(max)) * 100.0 )
    }
  
}
