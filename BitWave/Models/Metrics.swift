//
//  Metrics.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 05/07/2024.
//

import Foundation

struct Metrics: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentage: Double?
    
    init(title: String, value: String, percentage: Double? = nil) {
        self.title = title
        self.value = value
        self.percentage = percentage
    }
}
