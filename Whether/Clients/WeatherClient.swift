//
//  WeatherClient.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import Foundation

struct WeatherClient {
    
    // Expects an xcconfig at Whether/Config.xcconfig
    private static let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String
    static let scheme = "https"
    private static let host = "api.weatherapi.com"
    private static let forecastPath = "/v1/forecast.json"
    private static let locationQueryKey = "q"
    private static let apiQueryKey = "key"
    
    // call out decision to not use Alamofire
    static func realTimeWeather(location: String) async throws -> ViewModel? {
        guard let apiKeyUnwrapped = apiKey else {
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = forecastPath
        urlComponents.queryItems = [
            URLQueryItem(name: apiQueryKey, value: apiKeyUnwrapped),
            URLQueryItem(name: locationQueryKey, value: location)
        ]
        
        let url = urlComponents.url
        if let urlUnwrapped = url {
            let (data, _) = try await URLSession.shared.data(from: urlUnwrapped)
            
            // not worth reusing JSONDecoder, the actual decoding is WAY more expensive than creating the object
            if let forecastResponse = try? JSONDecoder().decode(ForecastResponse.self, from: data) {
                return DataUtils.buildViewModel(forecastResponse: forecastResponse, errorResponse: nil)
            } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                return DataUtils.buildViewModel(forecastResponse: nil, errorResponse: errorResponse)
            }
        }
        return nil
    }
    
}
