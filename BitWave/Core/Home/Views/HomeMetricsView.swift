//
//  HomeMetricsView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 08/07/2024.
//

import SwiftUI

struct HomeMetricsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @Binding var displayHoldings: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.metrics) { metric in
                MetricsView(metric: metric)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: displayHoldings ? .trailing : .leading)
    }
}

#Preview {
    HomeMetricsView(displayHoldings: .constant(false))
        .environmentObject(SwiftUIPreview.instance.homeVM)
}
