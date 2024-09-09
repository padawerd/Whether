//
//  ContentView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI
import OSLog

struct ContentView: View {
    
    private static let logger = Logger()
    
    @State private var viewModel: ViewModel? = DataUtils.loadingViewModel()
    @State private var hasFetchedStartLocation = false
    
    var body: some View {
        // Gross! Hack to allow ignoring safe areas (don't shove up when keyboard comes up)
        GeometryReader { _ in
            VStack {
                LocationView(viewModel: $viewModel)
                    .padding()
                Spacer()
                if let viewModelUnwrapped = viewModel {
                    if let current = viewModel?.current, let location = viewModel?.location, let future = viewModel?.future  {
                        CurrentWeatherView(current: current,
                                           location:location)
                        .cornerRadius(Styles.CORNER_RADIUS)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        ForecastView(future: future)
                    } else if viewModelUnwrapped.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.extraLarge)
                            .cornerRadius(Styles.CORNER_RADIUS)
                        Spacer()
                    } else if !viewModelUnwrapped.canFindLocation {
                        ErrorView(errorText: "CANT_FIND_LOCATION_ERROR_TEXT")
                        Spacer()
                    }
                } else {
                    ErrorView(errorText: "UNKNOWN_ERROR_TEXT")
                    Spacer()
                }
            }
            .frame(maxHeight:.infinity)
            .cornerRadius(Styles.CORNER_RADIUS)
            .task({
                await fetchStartLocation()
            })
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Styles.PRIMARY_BACKGROUND_COLOR)
    }
    
    func fetchStartLocation() async {
        if (!hasFetchedStartLocation) {
            hasFetchedStartLocation = true
            do {
                try viewModel = await WeatherClient.realTimeWeather(location: Constants.START_LOCATION)
            } catch {
                ContentView.logger.error("\(error, privacy: .public)")
            }
        }
    }
}

#Preview {
    ContentView()
}
