//
//  HapticsManager.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 18/07/2024.
//

import Foundation
import SwiftUI

class HapticsManager {
    
    static private let feedbackGenerator = UINotificationFeedbackGenerator()
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        feedbackGenerator.notificationOccurred(type)
    }
}
