//
//  HeartRateEvaluation.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 12/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation

class HeartRateEvaluation {
    
    var heartRates: [Int] = []
    
    func evaluateSession() -> HeartEvaluationData {
        
        let evaluationData = HeartEvaluationData (
            averageHR: self.getAverageHeartRate(),
            increaseHR: self.getIncreaseInHr()
        )
        return evaluationData
        
    }
    
    private func getAverageHeartRate () -> Int {
        guard  self.heartRates.count > 0 else { return 0 }
        var sum = 0
        for hr in self.heartRates {
            sum += hr
        }
        return sum / self.heartRates.count
    }
    
    private func getIncreaseInHr() -> Int {
           if let maxVal = self.heartRates.max() {
            let startValue = heartRates[1] // using second index since first sometimes is off
            let difference = maxVal - startValue
            return difference
        }
        return 0
    }
    
}
struct HeartEvaluationData {
    var averageHR: Int?
    var increaseHR: Int?
}
