//
//  Color.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 13/06/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let palette = Palette()
}

struct Palette {
    let accentColor = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let green = Color("DollarColor")
    let red = Color("CherryColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}
