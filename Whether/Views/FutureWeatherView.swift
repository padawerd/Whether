//
//  FutureWeatherView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI


struct FutureWeatherView: View {
    
    var futureHour: ViewModel.FutureHour
    
    var body: some View {
            VStack {
                Text(futureHour.time)
                    .padding([.leading, .trailing, .top])
                AsyncImageWithPlaceholderView(imageUrl: futureHour.iconUrl)
                    .padding([.top, .bottom], -10)
                Text(futureHour.probabilityOfPrecipitation)
                    .padding([.leading, .trailing])
                Text(futureHour.temperature)
                    .padding([.leading, .trailing, .bottom])
            }
            .background(Styles.SECONDARY_BACKGROUND_COLOR)
            .foregroundStyle(Styles.PRIMARY_FOREGROUND_COLOR)
    }
}
