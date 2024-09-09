//
//  ForecastResponse.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation

// TODO: coding keys
// TODO: Too dependent on weatherapi structure?
struct ForecastResponse: Codable {
    
    struct Location: Codable {
        let name: String
        let region: String
        let localtime: String
        let localtime_epoch: Int
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
    }
    
    struct CurrentHour: Codable {
        let temp_f: Double
        let condition: Condition
    }
    
    struct FutureHour: Codable {
        let temp_f: Double
        let chance_of_rain: Double
        let chance_of_snow: Double
        let condition: Condition
        let time: String
        let time_epoch: Int
    }
    
    struct MinMax: Codable {
        let maxtemp_f: Double
        let mintemp_f: Double
    }
    
    struct ForecastItem: Codable {
        let day: MinMax
        let hour: [FutureHour]
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastItem]
    }
    
    let location: Location
    let current: CurrentHour
    let forecast: Forecast
}
