//
//  CryptoImageViewModel.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 28/06/2024.
//

import Foundation
import SwiftUI
import Combine

@Observable class CryptoImageViewModel {
    var image: UIImage? = nil
    var isLoading: Bool = false
    private let coin: Coin
    private let imageDataService: CryptoImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.imageDataService = CryptoImageService(coin: coin)
        subscribe()
        self.isLoading = true
    }
    
    private func subscribe() {
        imageDataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] fetchedImage in
                self?.image = fetchedImage
            }
            .store(in: &cancellables)
    }
}
