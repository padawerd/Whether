//
//  ButtonView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI

struct AsyncButtonView: View {
    
    let systemImageName: String
    let action: () async -> Void
    
    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }, label: {
            Image(systemName: systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Styles.SECONDARY_BACKGROUND_COLOR)
                .padding()
        })
        .frame(width:60, height:60)
        .cornerRadius(Styles.CORNER_RADIUS)
        .background(Styles.SECONDARY_BACKGROUND_COLOR)
    }
    
    
    
}
