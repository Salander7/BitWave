//
//  ClickedCoinVM.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 14/08/2024.
//


import Foundation
import Combine

class ClickedCoinVM: ObservableObject {
    
    @Published var cryptoProfileMetrics: [Metrics] = []
    @Published var moreInfoMetrics: [Metrics] = []
    @Published var coinDescription: String? = nil
    @Published var websiteLink: String? = nil
    @Published var redditLink: String? = nil
    
    @Published var coin: Coin
    private let clickedCoinDataService: ClickedCoinDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.clickedCoinDataService = ClickedCoinDataService(coin: coin)
        self.addSubscribers()
    }

    private func addSubscribers() {
        clickedCoinDataService.$coinInfo
            .combineLatest($coin)
            .map({ clickedCoin, coin -> (cryptoProfile: [Metrics], moreInfo: [Metrics]) in
                
                let price = coin.currentPrice.decimalCurrency()
                let amountChange = coin.priceChangePercentage24H
                let priceMetric = Metrics(title: "Current Price", value: price, percentage: amountChange)
                let marketCap = "€" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapChange = coin.marketCapChangePercentage24H
                let marketCapMetric = Metrics(title: "Market Value", value: marketCap, percentage: marketCapChange)
                let rank = "\(coin.rank)"
                let rankMetric = Metrics(title: "Rank", value: rank)
                let volume = "€" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeMetric = Metrics(title: "Volume", value: volume)
                
                let cryptoProfile: [Metrics] = [priceMetric, marketCapMetric, rankMetric, volumeMetric]
                
                
                let high = coin.high24H?.decimalCurrency() ?? ""
                let highMetric = Metrics(title: "24h High", value: high)
                let low = coin.low24H?.decimalCurrency() ?? ""
                let lowMetric = Metrics(title: "24h Low", value: low)
                let priceChange = coin.priceChange24H?.decimalCurrency() ?? ""
                let pricePercentChange = coin.priceChangePercentage24H
                let priceChangeMetric = Metrics(title: "24h Price Change", value: priceChange, percentage: pricePercentChange)
                let marketCapDifference = "€" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapPercentChange = coin.marketCapChangePercentage24H
                let marketCapChangeMetric = Metrics(title: "24h Market Cap Change", value: marketCapDifference, percentage: marketCapPercentChange)
                
                let blockTime = clickedCoin?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "" : "\(blockTime)"
                let blockMetric = Metrics(title: "Block Time", value: blockTimeString)
                
                let hashing = clickedCoin?.hashingAlgorithm ?? ""
                let hashingMetric = Metrics(title: "Hashing Algorithm", value: hashing)
                
                let moreInfo: [Metrics] = [highMetric, lowMetric, priceChangeMetric, marketCapChangeMetric, blockMetric, hashingMetric]
                
                return (cryptoProfile, moreInfo)
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedCoinInfo in
                self?.cryptoProfileMetrics = fetchedCoinInfo.cryptoProfile
                self?.moreInfoMetrics = fetchedCoinInfo.moreInfo
            }
            .store(in: &cancellables)
        
        clickedCoinDataService.$coinInfo
            .receive(on: DispatchQueue.main) 
            .sink { [weak self] fetchedCoinInfo in
                print("Fetched Reddit URL: \(String(describing: fetchedCoinInfo?.links?.subredditURL))")
                self?.coinDescription = fetchedCoinInfo?.readableDescription
                self?.websiteLink = fetchedCoinInfo?.links?.homepage?.first
                self?.redditLink = fetchedCoinInfo?.links?.subredditURL
            }
            .store(in: &cancellables)

    }
}
