//
//  CryptoImageService.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 28/06/2024.
//

import Foundation
import SwiftUI
import Combine

class CryptoImageService {
    
    @Published var image: UIImage? = nil
    
   private var imageSubscription: AnyCancellable?
    
    private let coin: Coin
    
    private let fileManager = ImageFileManager.instance
    
    private let folderName = "crptoImages"
    
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        fetchCryptoImage()
    }
    
    private func fetchCryptoImage() {
        if let savedImage = fileManager.fetchImageFromTheFolder(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("image is displayed from file manager.")
        } else {
            downloadCryptoImage()
            print("image is downloading")
        }
        
    }
        
    private func downloadCryptoImage() {
       
        guard let url = URL(string: coin.image) else {
            return
        }
        
        imageSubscription = NetworkManager.fetch(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.manageCompletion, receiveValue: { [weak self] fetchedImage in
                guard let self = self, let downloadedImage = fetchedImage else {
                    return
                }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.storeImageToFolder(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
}
