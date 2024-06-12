//
//  Coin.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 17/06/2024.
//

import Foundation

struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let activeHoldings: Double?

    func updateHoldings(count: Double) -> Coin {
        return Coin(
            id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice,
            marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply,
            totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage,
            athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate,
            lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D,
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, activeHoldings: count
        )
    }

    var activeHoldingsPrice: Double {
        return (activeHoldings ?? 0) * currentPrice
    }

    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

