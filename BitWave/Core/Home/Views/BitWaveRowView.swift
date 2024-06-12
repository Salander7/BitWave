//
//  BitWaveRowView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 18/06/2024.
//

import SwiftUI

struct BitWaveRowView: View {
    let coin: Coin
    let displayBalanceColumn: Bool
    
    var body: some View {
        ZStack {
            Color.palette.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                leftColumn
                Spacer()
                if displayBalanceColumn {
                    middleColumn
                }
                rightColumn
                    .frame(maxWidth: UIScreen.main.bounds.width / 3, alignment: .trailing)
                    .padding(.trailing) 
            }
            .font(.subheadline)

        }
    }
}

struct BitWaveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BitWaveRowView(coin: thePreview.coin, displayBalanceColumn: true)
                .previewLayout(.sizeThatFits)
            BitWaveRowView(coin: thePreview.coin, displayBalanceColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension BitWaveRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.palette.secondaryTextColor)
                .frame(minWidth: 40)
            CryptoImageView(coin: coin)
                .frame(width: 40, height: 40)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 7)
                .foregroundStyle(Color.palette.accentColor)
        }
    }
    
    private var middleColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.activeHoldingsPrice.decimalCurrency())
                .fontWeight(.semibold)
            Text((coin.activeHoldings ?? 0).numberToString())
        }
        .foregroundStyle(Color.palette.accentColor)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.decimalCurrency())
                .fontWeight(.semibold)
                .foregroundStyle(Color.palette.accentColor)
            Text(coin.priceChangePercentage24H?.percentToString() ?? "")
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.palette.green : Color.palette.red)
        }
    }
}
