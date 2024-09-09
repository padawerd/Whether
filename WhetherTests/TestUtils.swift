//
//  TestUtils.swift
//  WhetherTests
//
//  Created by David Padawer on 9/7/24.
//

@testable import Whether

struct TestUtils {
    static func buildGoodLocation() -> ForecastResponse.Location {
        return ForecastResponse.Location(name: "foo",
                                         region:"bar",
                                         localtime:"1984-12-34 03:21",
                                         localtime_epoch:1)
    }
    
    static func buildGoodCondition() -> ForecastResponse.Condition {
        return ForecastResponse.Condition(text: "baz",
                                          icon: "//google.com/64x64/icon.png")
    }
    
    static func buildGoodCurrent() -> ForecastResponse.CurrentHour {
        let condition = buildGoodCondition()
        return ForecastResponse.CurrentHour(temp_f: 2,
                                            condition: condition)
    }
    
    static func buildGoodForecast() -> ForecastResponse.Forecast {
        let minMax = ForecastResponse.MinMax(maxtemp_f: 11,
                                             mintemp_f: 10)
        let hour = ForecastResponse.FutureHour(temp_f: 12,
                                               chance_of_rain: 13,
                                               chance_of_snow: 14,
                                               condition: buildGoodCondition(),
                                               time: "1824-11-22 00:37",
                                               time_epoch: 37)
        let forecastDay = ForecastResponse.ForecastItem(day: minMax, hour: [hour])
        return ForecastResponse.Forecast(forecastday: [forecastDay])
    }
    
    static func buildGoodForecastResponse() -> ForecastResponse {
        let location = buildGoodLocation()
        let current = buildGoodCurrent()
        let forecast = buildGoodForecast()
        
        return ForecastResponse(location: location,
                                current: current,
                                forecast: forecast)
    }
}
