//
//  GlobalMarketData.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 09/07/2024.
//

import Foundation



struct Global: Codable {
    let data: GlobalMarketData?
}

struct GlobalMarketData: Codable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    
    var marketCap: String {
        if let cap = totalMarketCap.first(where: { $0.key == "eur" }){
            return "€" + cap.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let cap = totalVolume.first(where: { $0.key == "eur" }){
            return "€" + cap.value.formattedWithAbbreviations()
        }
        return ""
        
    }
    var btc: String {
        if let cap = marketCapPercentage.first(where: { $0.key == "btc" }){
            return cap.value.percentToString()
        }
        return ""
    }
}

