//
//  XButton.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 11/07/2024.
//

import SwiftUI

struct XButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.subheadline)
        }
    }
}

#Preview {
    XButton()
}

