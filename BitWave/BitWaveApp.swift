//
//  BitWaveApp.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 12/06/2024.
//

import SwiftUI

@main
struct BitWaveApp: App {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
                
            }
            .environmentObject(viewModel)
        }
    }
}
