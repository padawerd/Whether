//
//  LocationView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI

struct LocationView: View {
    
    @State private var text = ""
    @State private var lastSearch = ""
    @Binding var viewModel: ViewModel?
    
    // force an instantiation of CLLocationManager on the main thread
    private let locationClient = LocationClient.shared
    
    var body: some View {
        HStack {
            TextField("",
                      text: $text,
                      prompt: Text("Where are you?")
                                .foregroundStyle(Styles.SECONDARY_FOREGROUND_COLOR))
            .padding([.leading, .trailing], 5)
            .padding([.top, .bottom], 10)
            .background(Styles.SECONDARY_BACKGROUND_COLOR)
            .foregroundColor(Styles.PRIMARY_FOREGROUND_COLOR)
            .cornerRadius(Styles.CORNER_RADIUS)
            
            AsyncButtonView(systemImageName: "magnifyingglass",
                            action: updateForecastResponse)
            .cornerRadius(Styles.CORNER_RADIUS)
            AsyncButtonView(systemImageName: "location.circle", 
                            action: getCurrentLocation)
            
            .cornerRadius(Styles.CORNER_RADIUS)
        }
        .cornerRadius(Styles.CORNER_RADIUS)
    }
    
    func updateForecastResponse() async {
        if (text != "" && text != lastSearch) {
            viewModel = DataUtils.loadingViewModel()
            lastSearch = text
            do {
                try viewModel = await WeatherClient.realTimeWeather(location: text)
            } catch {
                print("\(error)")
            }
        }
    }
    
    func getCurrentLocation() async {
        LocationClient.shared.getCurrentLocation(callback: { location in
            if let locationUnwrapped = location {
                text = locationUnwrapped
                Task {
                    await updateForecastResponse()
                }
            } else {
                viewModel = nil
            }
        })
    }
}

