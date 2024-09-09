//
//  ErrorView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI

struct ErrorView: View {
    
    let errorText: LocalizedStringKey
    
    var body: some View {
        Text(errorText)
            .padding()
            .background(Styles.SECONDARY_BACKGROUND_COLOR)
            .foregroundStyle(Styles.PRIMARY_FOREGROUND_COLOR)
            .font(.system(size: 20))
            .cornerRadius(Styles.CORNER_RADIUS)
    }
}
