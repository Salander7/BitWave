//
//  MarketCapDataService.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 09/07/2024.
//

import Foundation
import Combine

class MarketCapDataService {
    @Published var marketCap: GlobalMarketData? = nil
    var marketSubscription: AnyCancellable?
    
    init() {
        fetchMarketData()
    }
    
    func fetchMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        marketSubscription = NetworkManager.fetch(url: url)
            .decode(type: Global.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.manageCompletion, receiveValue: { [weak self] global in
                print(global)
                self?.marketCap = global.data
                self?.marketSubscription?.cancel()
            })
    }
}

