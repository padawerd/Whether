//
//  DataModel.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation
import SwiftUI

struct ViewModel {
    
    struct Current {
        let iconUrl: URL
        let conditionText: String
        let temperature: LocalizedStringKey
        let low: LocalizedStringKey
        let high: LocalizedStringKey
    }
    
    struct FutureHour {
        let iconUrl: URL
        let probabilityOfPrecipitation: LocalizedStringKey
        let temperature: LocalizedStringKey
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
