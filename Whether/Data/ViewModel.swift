//
//  DataModel.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation

struct ViewModel {
    
    struct Current {
        let iconUrl: URL
        let conditionText: String
        let temperature: String
        let low: String
        let high: String
    }
    
    struct FutureHour {
        let iconUrl: URL
        let probabilityOfPrecipitation: String
        let temperature: String
        let time: String
        let timeEpoch: Int
    }
    
    struct Future {
        let futureHours: [FutureHour]
    }
    struct Location {
        let name: String
        let time: String
        let timeEpoch: Int
    }
    
    let canFindLocation: Bool
    let isLoading: Bool
    let current: Current?
    let future: Future?
    let location: Location?
    
}
