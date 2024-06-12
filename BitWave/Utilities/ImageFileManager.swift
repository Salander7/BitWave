//
//  ImageFileManager.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 01/07/2024.
//

import Foundation
import SwiftUI

class ImageFileManager {
    
    static let instance = ImageFileManager()
    private init() {
        
    }
    
    func storeImageToFolder(image: UIImage, imageName: String, folderName: String) {
        
        createFolder(folderName: folderName)
        
        guard let data = image.pngData(), let url = fetchURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        do {
            try data.write(to: url)
        } catch let error {
            print("\(error) storing image error \(imageName)")
        }
    }
    
    func fetchImageFromTheFolder(imageName: String, folderName: String) -> UIImage? {
        guard let url = fetchURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolder(folderName: String) {
        guard let url = fetchURLForFolder(folderName: folderName) else {
            return
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("\(error) Creating directory error: \(folderName)")
            }
        }
    }
    
    private func fetchURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appending(path: folderName, directoryHint: .inferFromPath)
    }
    private func fetchURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = fetchURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appending(path: imageName + ".png", directoryHint: .inferFromPath)
    }
}

