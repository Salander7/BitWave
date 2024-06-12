//
//  RoundButtonView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 13/06/2024.
//

import SwiftUI

struct RoundButtonView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.palette.accentColor)
            .frame(width: 50, height: 50)
            .background(Circle().foregroundStyle(Color.palette.backgroundColor))
            .shadow(color: Color.palette.accentColor.opacity(0.20), radius: 10, x: 0, y: 0)
            .padding()
    }
}

struct RoundButtonView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            RoundButtonView(iconName: "text.book.closed")
                .previewLayout(.sizeThatFits)
            RoundButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
             
        }
    }
}
