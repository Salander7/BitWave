//
//  CurrencyFormat.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 20/06/2024.
//

import Foundation

extension Double {
    
    private var numberFormatter: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
    
        return formatter
    }
    func decimalCurrency() -> String {
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number) ?? "$0.00"
    }
    func numberToString() -> String {
        return String(format: "%.2f", self)
    }
    func percentToString() -> String {
        return numberToString() + "%"
    }
    func formattedWithAbbreviations() -> String {
            let num = abs(Double(self))
            let sign = (self < 0) ? "-" : ""

            switch num {
            case 1_000_000_000_000...:
                let formatted = num / 1_000_000_000_000
                let stringFormatted = formatted.numberToString()
                return "\(sign)\(stringFormatted)Tr"
            case 1_000_000_000...:
                let formatted = num / 1_000_000_000
                let stringFormatted = formatted.numberToString()
                return "\(sign)\(stringFormatted)Bn"
            case 1_000_000...:
                let formatted = num / 1_000_000
                let stringFormatted = formatted.numberToString()
                return "\(sign)\(stringFormatted)M"
            case 1_000...:
                let formatted = num / 1_000
                let stringFormatted = formatted.numberToString()
                return "\(sign)\(stringFormatted)K"
            case 0...:
                return self.numberToString()

            default:
                return "\(sign)\(self)"
            }
        }

}

