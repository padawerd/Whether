//
//  ForecastView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI

struct ForecastView: View {
    
    var future: ViewModel.Future
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(future.futureHours, id: \.timeEpoch) { hour in
                    FutureWeatherView(futureHour: hour)
                        .cornerRadius(Styles.CORNER_RADIUS)
                }
            }
            .cornerRadius(Styles.CORNER_RADIUS)
            .padding()
        }
    }
}
