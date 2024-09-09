//
//  WhetherTests.swift
//  WhetherTests
//
//  Created by David Padawer on 9/7/24.
//

import XCTest
@testable import Whether

final class DataUtilsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFormatTime() {
        // arrange
        let unformattedTime = "1990-12-25 12:34"
        let expected = "12:34"
        
        // act
        let actual = DataUtils.formatTime(time: unformattedTime)

        // assert
        XCTAssertEqual(expected, actual)
    }
    
    func testFormatTimeFail() {
        // arrange
        let badTime = "foo"
        
        // act
        let actual = DataUtils.formatTime(time: badTime)

        // assert
        XCTAssertNil(actual)
    }
    
    func testBuildIconUrl() {
        // arrange
        let urlString = "//google.com"
        let expected = URL(string:"https://google.com")
        
        // act
        let actual = DataUtils.buildIconUrl(urlString: urlString)
        
        // assert
        XCTAssertEqual(expected, actual)
    }
    
    func testBuildBigIconUrl() {
        // arrange
        let urlString = "//google.com/64x64/image.png"
        let expected = URL(string:"https://google.com/128x128/image.png")
        
        // act
        let actual = DataUtils.buildBigIconUrl(urlString: urlString)
        
        // assert
        XCTAssertEqual(expected, actual)
    }
    
    func testProbabilityOfPrecipitation() {
        // arrange
        let condition = ForecastResponse.Condition(text:"foo", icon:"bar")
        let hour = ForecastResponse.FutureHour(temp_f: 1,
                                               chance_of_rain: 2,
                                               chance_of_snow: 3,
                                               condition: condition,
                                               time: "someTime",
                                               time_epoch: 4)
        let expected = 3.0
    
        // act
        let actual = DataUtils.probabilityOfPrecipitation(hour: hour)
        
        // assert
        XCTAssertEqual(expected, actual)
    }
    
    func testLocationName() {
        // arrange
        let location = ForecastResponse.Location(name: "foo",
                                                 region:"bar",
                                                 localtime:"baz",
                                                 localtime_epoch:1)
        let expected = "foo, bar"
        
        // act
        let actual = DataUtils.locationName(location: location)
        
        // assert
        XCTAssertEqual(expected, actual)
    }
    
    func testBuildLocation() {
        // arrange
        let forecastResponse = TestUtils.buildGoodForecastResponse()
        let expected = ViewModel.Location(name: "foo, bar",
                                          time: "03:21",
                                          timeEpoch: 1)
        
        // act
        let actual = DataUtils.buildLocation(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNotNil(actual)
        XCTAssertEqual(expected.name, actual!.name)
        XCTAssertEqual(expected.time, actual!.time)
        XCTAssertEqual(expected.timeEpoch, actual!.timeEpoch)
    }
    
    func testBuildLocationBadTime() {
        // arrange
        let location = ForecastResponse.Location(name: "foo",
                                                 region: "bar",
                                                 localtime: "badTime",
                                                 localtime_epoch: 1)
        let current = TestUtils.buildGoodCurrent()
        let forecast = TestUtils.buildGoodForecast()
        let forecastResponse = ForecastResponse(location: location,
                                                current: current,
                                                forecast: forecast)
        // act
        let actual = DataUtils.buildLocation(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNil(actual)
    }

    func testBuildCurrent() {
        // arrange
        let forecastResponse = TestUtils.buildGoodForecastResponse()
        let expected = ViewModel.Current(iconUrl: URL(string:"https://google.com/128x128/icon.png")!,
                                         conditionText: "baz",
                                         temperature: "someTemp",
                                         low: "someLow",
                                         high: "someHigh")
        
        // act
        let actual = DataUtils.buildCurrent(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNotNil(actual)
        XCTAssertEqual(expected.iconUrl, actual!.iconUrl)
        XCTAssertEqual(expected.conditionText, actual!.conditionText)
    }
    
    func testBuildCurrentBadIconUrl() {}
    func testBuildCurrentBadForecastDay() {}
    
    func testBuildFuture() {
        // arrange
        let forecastResponse = TestUtils.buildGoodForecastResponse()
        let expected = ViewModel.Future(futureHours: [ViewModel.FutureHour(iconUrl: URL(string:"https://google.com/64x64/icon.png")!,
                                                                 probabilityOfPrecipitation:"foo",
                                                                 temperature: "bar",
                                                                 time: "00:37",
                                                                 timeEpoch: 37)])
        
        // act
        let actual = DataUtils.buildFuture(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.futureHours.count, 1)
        XCTAssertEqual(expected.futureHours.first!.iconUrl, actual!.futureHours.first!.iconUrl)
        XCTAssertEqual(expected.futureHours.first!.time, actual!.futureHours.first!.time)
        XCTAssertEqual(expected.futureHours.first!.timeEpoch, actual!.futureHours.first!.timeEpoch)
    }
    
    func testBuildFutureNoForecastDay() {
        // arrange
        let forecast = ForecastResponse.Forecast(forecastday: [])
        let forecastResponse = ForecastResponse(location: TestUtils.buildGoodLocation(),
                                                current: TestUtils.buildGoodCurrent(),
                                                forecast: forecast)
        
        // act
        let actual = DataUtils.buildFuture(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNil(actual)
    }
    
    func testBuildFutureBadTime() {
        // arrange
        let minMax = ForecastResponse.MinMax(maxtemp_f: 11,
                                             mintemp_f: 10)
        let condition = ForecastResponse.Condition(text: "foo", icon: "bar")
        let hour = ForecastResponse.FutureHour(temp_f: 12,
                                               chance_of_rain: 13,
                                               chance_of_snow: 14,
                                               condition: condition,
                                               time: "foo",
                                               time_epoch: 37)
        let forecastDay = ForecastResponse.ForecastItem(day: minMax, hour: [hour])
        let forecast = ForecastResponse.Forecast(forecastday: [forecastDay])
        let forecastResponse = ForecastResponse(location: TestUtils.buildGoodLocation(),
                                                current: TestUtils.buildGoodCurrent(),
                                                forecast: forecast)
        
        // act
        let actual = DataUtils.buildFuture(forecastResponse: forecastResponse)
        
        // assert
        XCTAssertNil(actual)
        
    }
    
    func testBuildViewModel() {
        // arrange
        let location = TestUtils.buildGoodLocation()
        let current = TestUtils.buildGoodCurrent()
        let forecast = TestUtils.buildGoodForecast()
        let forecastResponse = ForecastResponse(location: location,
                                                current: current,
                                                forecast: forecast)
        
        // act
        let actual = DataUtils.buildViewModel(forecastResponse: forecastResponse,
                                              errorResponse: nil)
        
        // assert
        XCTAssertNotNil(actual)
        XCTAssertTrue(actual!.canFindLocation)
        XCTAssertFalse(actual!.isLoading)
        XCTAssertNotNil(actual?.location)
        XCTAssertNotNil(actual?.current)
        XCTAssertNotNil(actual?.future)
        
    }
    
    func testBuildViewModelNotFoundError() {
        // arrange
        let error = ErrorResponse.Error(code: 1006, message: "foo")
        let errorResponse = ErrorResponse(error: error)
        
        // act
        let actual = DataUtils.buildViewModel(forecastResponse: nil,
                                              errorResponse: errorResponse)
        
        // assert
        XCTAssertNotNil(actual)
        XCTAssertFalse(actual!.canFindLocation)
    }
    func testBuildViewModelUnrecognizedError() {
        // arrange
        let error = ErrorResponse.Error(code: 123, message: "foo")
        let errorResponse = ErrorResponse(error: error)
        
        // act
        let actual = DataUtils.buildViewModel(forecastResponse: nil,
                                              errorResponse: errorResponse)
        
        // assert
        XCTAssertNil(actual)
    }
    func testBuildViewModelMissingResponses() {
        // act
        let actual = DataUtils.buildViewModel(forecastResponse: nil,
                                              errorResponse: nil)
        
        // assert
        XCTAssertNil(actual)
    }
}
