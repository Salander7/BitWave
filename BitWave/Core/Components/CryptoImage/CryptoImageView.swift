//
//  CryptoImageView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 27/06/2024.
//

import SwiftUI

struct CryptoImageView: View {
    
    @State var viewModel: CryptoImageViewModel
    
    init(coin: Coin) {
        _viewModel = State(wrappedValue: CryptoImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.palette.secondaryTextColor)
            }
        }
    }
}

#Preview {
    CryptoImageView(coin: SwiftUIPreview.instance.coin)
        .padding()
        .previewLayout(.sizeThatFits)
}

