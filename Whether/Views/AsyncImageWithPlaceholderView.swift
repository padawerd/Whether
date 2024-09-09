//
//  AsyncImageWithPlaceholderView.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import SwiftUI

struct AsyncImageWithPlaceholderView: View {
    
    var imageUrl: URL
    
    var body: some View {
        AsyncImage(url:imageUrl,
                   content: { image in
            image.cornerRadius(Styles.CORNER_RADIUS)
        }, placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.regular)
                .cornerRadius(Styles.CORNER_RADIUS)
                .padding(20)
        })
    }
}
