//
//  HomeViewModel.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 21/06/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var metrics: [Metrics] = []
    @Published var coinList: [Coin] = []
    @Published var coinBalance: [Coin] = []
    @Published var isRefreshing: Bool = false
    @Published var search: String = ""
    @Published var sortedCoins: SortedCoins = .holdings
    
    private let cryptoDataService = CryptoDataService()
    private let marketCapDataService = MarketCapDataService()
    private let holdingsCoreDataService = HoldingsCoreDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortedCoins {
        case order,
             reversedOrder,
             holdings,
             reversedHoldings,
             price,
             reversedPrice
    }
    
    init() {
        subscribeToDataServices()
    }
    
    private func subscribeToDataServices() {
        $search
            .combineLatest(cryptoDataService.$coinsList, $sortedCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.coinList = coins
            }
            .store(in: &cancellables)
        
        $coinList
            .combineLatest(holdingsCoreDataService.$savedEntity)
            .map(convertAllCoinsToHoldings)
            .sink { [weak self] fetchedCoins in
                guard let self = self else {
                    return
                }
                self.coinBalance = self.sortHoldingsCoinsInNeed(coin: fetchedCoins)
            }
            .store(in: &cancellables)
        
        marketCapDataService.$marketCap
            .combineLatest($coinBalance)
            .map(transformMarketCapData)
            .sink { [weak self] metrics in
                self?.metrics = metrics
                self?.isRefreshing = false 
            }
            .store(in: &cancellables)
        
    }
    
    func updateHoldings(coin: Coin, amount: Double) {
        holdingsCoreDataService.updateHoldings(coin: coin, amount: amount)
    }
    
    func refreshCoins() {
        isRefreshing = true
        cryptoDataService.fetchCoins()
        marketCapDataService.fetchMarketData()
        HapticsManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(searchText: String, coins: [Coin], order: SortedCoins) -> [Coin] {
                let filteredCoins = filterCoins(searchText: searchText, coins: coins)
                let orderedCoins = sortCoins(order: order, coins: filteredCoins)
                return orderedCoins
    }
    
    private func filterCoins(searchText: String, coins: [Coin]) -> [Coin] {
        guard !searchText.isEmpty else {
            return coins
        }
        
        let lowercasedText = searchText.lowercased()
        return coins.filter { coin in
            coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(order: SortedCoins, coins: [Coin]) -> [Coin] {
        switch order {
        case .order:
            return coins.sorted(by: { $0.rank < $1.rank})
        case .reversedOrder:
            return coins.sorted(by: { $0.rank > $1.rank})
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice})
        case .reversedPrice:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice})
        case .holdings:
            return coins.sorted(by: { $0.rank < $1.rank})
        case .reversedHoldings:
            return coins.sorted(by: { $0.rank > $1.rank})
       
        }
    }
    
    private func sortHoldingsCoinsInNeed(coin: [Coin]) -> [Coin] {
        switch sortedCoins {
        case .holdings:
            return coin.sorted(by: { $0.activeHoldingsPrice > $1.activeHoldingsPrice })
        case .reversedHoldings:
            return coin.sorted(by: { $0.activeHoldingsPrice < $1.activeHoldingsPrice })
        default:
            return coin
        }
    }
    
    private func convertAllCoinsToHoldings(allCoins: [Coin], holdingsEntities: [Holdings]) -> [Coin] {
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = holdingsEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(count: entity.activeHoldingsAmount)
            }
    }
    
    private func transformMarketCapData(_ marketCapData: GlobalMarketData?, coinBalance: [Coin]) -> [Metrics] {
        guard let data = marketCapData else {
            return []
        }
        
        let holdingsValue = coinBalance
            .map({ $0.activeHoldingsPrice })
            .reduce(0, +)
        
        let oldValue = coinBalance.map { coin -> Double in
            let currentValue = coin.activeHoldingsPrice
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let oldValue = currentValue / (1 + percentChange)
            return oldValue
        }
            .reduce(0, +)
        let percentageChange = ((holdingsValue - oldValue) / oldValue) 
        
        return [
            Metrics(title: "Market Cap", value: data.marketCap, percentage: data.marketCapChangePercentage24HUsd),
            Metrics(title: "24h", value: data.volume),
            Metrics(title: "Dominance", value: "BTC: \(data.btc)"),
            Metrics(title: "Holdings", value: holdingsValue.decimalCurrency(), percentage: percentageChange)
            
        ]
    }
}


