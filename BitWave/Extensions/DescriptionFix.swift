//
//  DescriptionFix.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 20/08/2024.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
