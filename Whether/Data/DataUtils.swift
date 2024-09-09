//
//  ForecastResponseUtils.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation

struct DataUtils {
    
    // Expects a time of the form "YYYY-MM-DD HH:MM"
    static func formatTime(time: String) -> String? {
        let separators = CharacterSet(charactersIn: " ")
        return time.components(separatedBy: separators).last
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
    
    static func buildViewModel(forecastResponse: ForecastResponse?, errorResponse: ErrorResponse?) -> ViewModel? {
        
        if let errorResponseUnwrapped = errorResponse {
            if errorResponseUnwrapped.error.code == 1006 {
                return ViewModel(canFindLocation: false,
                                 isLoading: false,
                                 current: nil,
                                 future: nil,
                                 location: nil)
            } else {
                // TODO: log about it
                return nil
            }
        }
        
        guard let forecastResponseUnwrapped = forecastResponse else {
            return nil
        }
            
        // location
        let locationName = locationName(location: forecastResponseUnwrapped.location)
        let timeEpoch = forecastResponseUnwrapped.location.localtime_epoch
        guard let locationTime = formatTime(time: forecastResponseUnwrapped.location.localtime) else {
            return nil
        }
        let location = ViewModel.Location(name: locationName, time: locationTime, timeEpoch: timeEpoch)
            
        // current
        guard let iconUrl = buildBigIconUrl(urlString: forecastResponseUnwrapped.current.condition.icon) else {
            return nil
        }
        let conditionText = forecastResponseUnwrapped.current.condition.text
        let temperature = "\(forecastResponseUnwrapped.current.temp_f)° F"
        guard let forecastDay = forecastResponseUnwrapped.forecast.forecastday.first else {
            return nil
        }
        let low = "Low: \(forecastDay.day.mintemp_f)"
        let high = "High: \(forecastDay.day.maxtemp_f)"
        let current = ViewModel.Current(iconUrl: iconUrl,
                                        conditionText: conditionText,
                                        temperature: temperature,
                                        low: low,
                                        high: high)
        
        
        // future
        
        
        // not map, because we want to be able to return from the function if anything's missing
        var futureHours: [ViewModel.FutureHour] = []
        for hour in forecastDay.hour {
            // design decision: if any icons can't be shown, nuke the whole view.
            guard let hourIconUrl = buildIconUrl(urlString:hour.condition.icon) else {
                return nil
            }
            let probabilityOfPrecipitation = "\(probabilityOfPrecipitation(hour: hour))% PoP"
            let temperature = "\(hour.temp_f)° F"
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
