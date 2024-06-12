//
//  HoldingsImageView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 11/07/2024.
//

import SwiftUI

struct HoldingsImageView: View {
    let crypto: Coin
    var body: some View {
        VStack {
            CryptoImageView(coin: crypto)
                .frame(width: 50, height: 50)
            Text(crypto.symbol.uppercased())
                .font(.subheadline)
                .foregroundColor(Color.palette.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .frame(width: 60)
    }
}

#Preview {
    Group {
        HoldingsImageView(crypto: SwiftUIPreview.instance.coin)
            .previewLayout(.sizeThatFits)
    }
}

