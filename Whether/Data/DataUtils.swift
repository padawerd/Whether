//
//  ForecastResponseUtils.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation
import OSLog
import SwiftUI

struct DataUtils {
    
    static let logger = Logger()
    
    // Expects a time of the form "YYYY-MM-DD HH:MM"
    // DateTimeFormatter would be good if we needed timezones and such, but regex is plenty for now.
    static func formatTime(time: String) -> String? {
        let dateRegex = /([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2})/
        if let match = time.firstMatch(of: dateRegex) {
            return String(match.2)
        }
        return nil
    }
    
    // Expects a String representing a scheme-relative URL.
    // Assumes the scheme exposed by WeatherClient.
    static func buildIconUrl(urlString: String) -> URL? {
        return URL(string: WeatherClient.scheme + ":" + urlString)
    }
    
    // Expects a String representing a scheme-relative URL.
    // Expects the passed-in String directs to a 64x64 resolution
    // Assumes the scheme exposed by WeatherClient.
    // Assumes a desired resolution of 128x128 (currently the largest available from weather api)
    static func buildBigIconUrl(urlString: String) -> URL? {
        return URL(string: WeatherClient.scheme + ":" + urlString.replacingOccurrences(of: "64x64", with: "128x128"))
    }
    
    static func probabilityOfPrecipitation(hour: ForecastResponse.FutureHour) -> Double {
        // there's probably more sophisticated ways to measure this given more data, but lets be cautious given what we've got.
        // relevant XKCD: https://xkcd.com/1985/
        return max(hour.chance_of_rain, hour.chance_of_snow)
    }
    
    static func locationName(location: ForecastResponse.Location) -> String {
        return "\(location.name), \(location.region)"
    }
    
    static func buildLocation(forecastResponse: ForecastResponse) -> ViewModel.Location? {
        let locationName = locationName(location: forecastResponse.location)
        let timeEpoch = forecastResponse.location.localtime_epoch
        guard let locationTime = formatTime(time: forecastResponse.location.localtime) else {
            logger.error("Failed to format location time")
            return nil
        }
        let location = ViewModel.Location(name: locationName, time: locationTime, timeEpoch: timeEpoch)
        return location
    }
    
    static func buildCurrent(forecastResponse: ForecastResponse) -> ViewModel.Current? {
        guard let iconUrl = buildBigIconUrl(urlString: forecastResponse.current.condition.icon) else {
            logger.error("Failed to build big icon URL")
            return nil
        }
        let conditionText = forecastResponse.current.condition.text
        let temperature = LocalizedStringKey("TEMPERATURE_FORMAT_\(String(forecastResponse.current.temp_f))")
        guard let forecastDay = forecastResponse.forecast.forecastday.first else {
            logger.error("Failed to find any forecast days")
            return nil
        }
        let low = LocalizedStringKey("LOW_TEMPERATURE_FORMAT_\(String(forecastDay.day.mintemp_f))")
        let high = LocalizedStringKey("HIGH_TEMPERATURE_FORMAT_\(String(forecastDay.day.mintemp_f))")
        let current = ViewModel.Current(iconUrl: iconUrl,
                                        conditionText: conditionText,
                                        temperature: temperature,
                                        low: low,
                                        high: high)
        return current
    }
    
    static func buildFuture(forecastResponse: ForecastResponse) -> ViewModel.Future? {
        guard let forecastDay = forecastResponse.forecast.forecastday.first else {
            logger.error("Failed to find any forecast days")
            return nil
        }
        // not map, because we want to be able to return from the function if anything's missing
        var futureHours: [ViewModel.FutureHour] = []
        for hour in forecastDay.hour {
            // design decision: if any icons can't be shown, nuke the whole view.
            guard let hourIconUrl = buildIconUrl(urlString:hour.condition.icon) else {
                return nil
            }
            let probabilityOfPrecipitation = LocalizedStringKey("PROBABILITY_OF_PRECIPITATION_FORMAT_\(String(probabilityOfPrecipitation(hour: hour)))")
            let temperature = LocalizedStringKey("TEMPERATURE_FORMAT_\(String(hour.temp_f))")
            guard let time = formatTime(time: hour.time) else {
                return nil
            }
            let timeEpoch = hour.time_epoch
            let futureHour = ViewModel.FutureHour(iconUrl: hourIconUrl,
                                                  probabilityOfPrecipitation: probabilityOfPrecipitation,
                                                  temperature: temperature,
                                                  time: time,
                                                  timeEpoch: timeEpoch)
            futureHours.append(futureHour)
        }
        
        let future = ViewModel.Future(futureHours: futureHours)
        return future
    }
    
    static func buildViewModel(forecastResponse: ForecastResponse?, errorResponse: ErrorResponse?) -> ViewModel? {
        
        if let errorResponseUnwrapped = errorResponse {
            if errorResponseUnwrapped.error.code == 1006 {
                return ViewModel(canFindLocation: false,
                                 isLoading: false,
                                 current: nil,
                                 future: nil,
                                 location: nil)
            } else {
                logger.error("Got an error response but didn't recognize the code: \(errorResponseUnwrapped.error.code, privacy: .public)")
                return nil
            }
        }
        
        guard let forecastResponseUnwrapped = forecastResponse else {
            logger.error("Failed to deserialize ForecastResponse")
            return nil
        }
            
        let location = buildLocation(forecastResponse: forecastResponseUnwrapped)
        let current = buildCurrent(forecastResponse: forecastResponseUnwrapped)
        let future = buildFuture(forecastResponse: forecastResponseUnwrapped)
        
        return ViewModel(canFindLocation: true,
                         isLoading: false,
                         current: current,
                         future: future,
                         location: location)
    }
    
    static func loadingViewModel() -> ViewModel {
        return ViewModel(canFindLocation: true,
                         isLoading: true,
                         current: nil,
                         future: nil,
                         location: nil)
    }
}
