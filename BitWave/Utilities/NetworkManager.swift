//
//  NetworkManager.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 25/06/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case uRLResponseError(url: URL)
        case unknownError
        
        var errorDescription: String? {
            switch self {
                
            case .uRLResponseError(url: let url):
               return "URL Response Error occurred: \(url)"
            case .unknownError:
               return "An unknown error occurred"
            }
        }
    }
    
    static func fetch(url: URL) -> AnyPublisher<Data, any Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ 
                try manageURLResponse(output: $0, url: url)
            })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func manageURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.uRLResponseError(url: url)
        }
        return output.data
    }
    
    static func manageCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
