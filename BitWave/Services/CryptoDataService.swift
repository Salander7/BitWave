//
//  CryptoDataService.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 24/06/2024.
//

import Foundation
import Combine

class CryptoDataService {
    @Published var coinsList: [Coin] = []
    var subscription: AnyCancellable?
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        subscription = NetworkManager.fetch(url: url)
            .decode(type: [Coin].self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.manageCompletion, receiveValue: { [weak self] coins in
                self?.coinsList = coins
                self?.subscription?.cancel()
            })
    }
}
