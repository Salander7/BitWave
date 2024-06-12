//
//  RoundButtonAnimationView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 17/06/2024.
//

import SwiftUI

struct RoundButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
      Circle()
            .stroke(lineWidth: 3.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeInOut(duration: 1.0) : .none, value: animate)
    }
}

#Preview {
    RoundButtonAnimationView(animate: .constant(false))
        .foregroundStyle(.blue)
        .frame(width: 20, height: 20)
}
