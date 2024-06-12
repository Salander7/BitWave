//
//  ClickedCoinDataService.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 14/08/2024.
//

import Foundation
import Combine

class ClickedCoinDataService {
    
    @Published var coinInfo: ClickedCoin? = nil
    
    var clickedCoinSubscription: AnyCancellable?
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        fetchClickedCoin()
    }
    
    func fetchClickedCoin() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }
        
        clickedCoinSubscription = NetworkManager.fetch(url: url)
            .decode(type: ClickedCoin.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] returnedClickedCoin in
                print("Fetched Coin Info: \(returnedClickedCoin)")
                print("Reddit URL: \(String(describing: returnedClickedCoin.links?.subredditURL))")
                self?.coinInfo = returnedClickedCoin
                self?.clickedCoinSubscription?.cancel()
            })
    }
}
