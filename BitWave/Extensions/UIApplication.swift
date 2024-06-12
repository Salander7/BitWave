//
//  UIApplication.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 04/07/2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
