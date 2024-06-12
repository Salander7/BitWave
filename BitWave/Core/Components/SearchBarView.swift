//
//  SearchBarView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 03/07/2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var search: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.secondary)
            TextField("Search", text: $search)
            
                .foregroundStyle(Color.palette.accentColor)
                .autocorrectionDisabled(true)
                .overlay(Image(systemName: "xmark")
                    
                    .imageScale(.small)
                    .foregroundStyle(Color.secondary)
                         
                    .opacity(search.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.dismissKeyboard()
                        search = ""
                    }
                    ,alignment: .trailing)
                
            
                
        }
        
        .font(.title3)
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.palette.backgroundColor))
        .shadow(color: .gray.opacity(0.20), radius: 10, x: 0, y: 0)
        .padding()
    }
     
}

#Preview {
    SearchBarView(search: .constant(""))
      
}
