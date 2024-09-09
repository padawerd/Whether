//
//  CurrentWeatherView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI


struct CurrentWeatherView: View {
    
    var current: ViewModel.Current
    var location: ViewModel.Location
    
    var body: some View {
            
            VStack {
                Text(location.name)
                    .padding([.leading, .trailing, .top])
                Text(location.time)
                    .padding([.leading, .trailing])
                AsyncImageWithPlaceholderView(imageUrl: current.iconUrl)
                Text(current.conditionText)
                    .padding([.leading, .trailing])
                Text(current.temperature)
                    .padding([.leading, .trailing])
                    .font(.system(size: 30))
                HStack {
                    Text(current.low)
                    Text(current.high)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .background(Styles.SECONDARY_BACKGROUND_COLOR)
            .foregroundStyle(Styles.PRIMARY_FOREGROUND_COLOR)
    }
}
